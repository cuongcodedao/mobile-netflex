package com.project.backend.controller;

import com.project.backend.dto.request.SubscriptionCreationRequest;
import com.project.backend.dto.response.SubscriptionResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.ISubscriptionService;
import com.project.backend.service.impl.PaypalService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/subscription")
@RequiredArgsConstructor
public class SubscriptionController {
    private final ISubscriptionService subscriptionService;

    @PostMapping("")
    public TemplateResponse<?> create(@RequestBody @Valid SubscriptionCreationRequest subscriptionCreationRequest) throws IOException {
        return TemplateResponse.builder()
                .result(subscriptionService.create(subscriptionCreationRequest))
                .build();
    }

    @GetMapping("/{subscription_id}")
    public TemplateResponse<?> activeSubscription(@PathVariable String subscription_id) throws IOException {
        return TemplateResponse.builder()
                .result(subscriptionService.activeSubscription(subscription_id).getStatus())
                .build();
    }
    @DeleteMapping("/cancel/{subscription_id}")
    public TemplateResponse<?> cancelSubscription(@PathVariable String subscription_id) throws IOException {
        subscriptionService.cancelSubscription(subscription_id);
        return TemplateResponse.builder()
                .result("Subscription cancelled successfully")
                .build();
    }

    @DeleteMapping("/cancel/account/{account_id}")
    public TemplateResponse<?> cancelSubscription(@PathVariable Long account_id) throws IOException {
        subscriptionService.cancelSubscriptionByAccountId(account_id);
        return TemplateResponse.builder()
                .result("Subscription cancelled successfully")
                .build();
    }
    @GetMapping("")
    public TemplateResponse<List<SubscriptionResponse>> getAllSubscriptions() throws IOException {
        List<SubscriptionResponse> response = subscriptionService.getAllSubscriptions();
        return TemplateResponse.<List<SubscriptionResponse>>builder()
                .result(response)
                .build();
    }

}