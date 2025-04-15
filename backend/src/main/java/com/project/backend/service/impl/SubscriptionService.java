package com.project.backend.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.backend.config.PaypalConfig;
import com.project.backend.dto.request.SubscriptionCreationRequest;
import com.project.backend.dto.response.PaypalSubscriptionResponse;
import com.project.backend.dto.response.SubscriptionResponse;
import com.project.backend.entity.Account;
import com.project.backend.entity.Plan;
import com.project.backend.entity.Subscription;
import com.project.backend.enums.PaymentStatus;
import com.project.backend.mapper.SubscriptionMapper;
import com.project.backend.repository.AccountRepository;
import com.project.backend.repository.PlanRepository;
import com.project.backend.repository.SubscriptionRepository;
import com.project.backend.service.IPaypalService;
import com.project.backend.service.ISubscriptionService;
import lombok.RequiredArgsConstructor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SubscriptionService implements ISubscriptionService {
    private final SubscriptionRepository subscriptionRepository;
    private final IPaypalService paypalService;
    private final SubscriptionMapper subscriptionMapper;
    private final AccountRepository accountRepository;
    private final PlanRepository planRepository;

    @Override
    @Transactional
    public PaypalSubscriptionResponse create(SubscriptionCreationRequest subscriptionDTO) throws IOException {
        PaypalSubscriptionResponse paypalSubscriptionResponse = paypalService.createSubscription(subscriptionDTO);
        Account account = accountRepository.findById(subscriptionDTO.getAccountId())
                .orElseThrow(() -> new RuntimeException("Account not found"));
        Plan plan = planRepository.findById(subscriptionDTO.getPlanId()).orElseThrow(() -> new RuntimeException("Plan not found"));
        Subscription subscription = Subscription.builder()
                .id(paypalSubscriptionResponse.getId())
                .account(account)
                .plan(plan)
                .startDate(LocalDate.now())
                .status(PaymentStatus.APPROVAL_PENDING)
                .build();
        subscriptionRepository.save(subscription);
        return paypalSubscriptionResponse;
    }

    public PaypalSubscriptionResponse activeSubscription(String subscriptionId) throws IOException {
        PaypalSubscriptionResponse subscriptionResponse = paypalService.getSubscription(subscriptionId);
        Subscription subscription = subscriptionRepository.findById(subscriptionId)
                .orElseThrow(() -> new RuntimeException("Subscription not found"));
        Account account = subscription.getAccount();
        subscription.setStatus(PaymentStatus.valueOf(subscriptionResponse.getStatus()));
        if(subscriptionResponse.getStatus().equals("ACTIVE")) {
            account.setCurrentPlan(subscription.getPlan());
            subscription.setActive(true);
            accountRepository.save(account);
        }
        subscriptionRepository.save(subscription);
        return subscriptionResponse;
    }

    @Override
    public void cancelSubscription(String subscriptionId) throws IOException {
        Subscription subscription = subscriptionRepository.findById(subscriptionId)
                .orElseThrow(() -> new RuntimeException("Subscription not found"));
        subscription.setActive(false);
        subscription.setStatus(PaymentStatus.CANCELED);
        subscriptionRepository.save(subscription);
        paypalService.cancelSubscription(subscriptionId);
    }

    public List<SubscriptionResponse> getAllSubscriptions() {
        return subscriptionRepository.findAll().stream()
                .map(subscriptionMapper::toSubscriptionResponse)
                .collect(Collectors.toList());
    }



}