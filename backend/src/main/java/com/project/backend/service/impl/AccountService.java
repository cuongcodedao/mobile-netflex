package com.project.backend.service.impl;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.entity.Account;
import com.project.backend.mapper.AccountMapper;
import com.project.backend.repository.AccountRepository;
import com.project.backend.service.IAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AccountService implements IAccountService {
    private final AccountRepository accountRepository;
    private final AccountMapper accountMapper;

    @Override
    public List<AccountResponse> getAllAccounts() {
        return accountRepository.findAll().stream()
                .map(accountMapper::toAccountResponse)
                .collect(Collectors.toList());
    }

    @Override
    public AccountResponse getAccountById(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        return accountMapper.toAccountResponse(account);
    }

    @Override
    public AccountResponse createAccount(AccountCreationRequest accountCreationRequest) {
        Account account = accountMapper.toAccount(accountCreationRequest);
        account.setCreatedAt(LocalDateTime.now());
        account = accountRepository.save(account);
        return accountMapper.toAccountResponse(account);
    }

    @Override
    public AccountResponse login(String email, String password) {
        Account account = accountRepository.findByEmailAndPassword(email, password);
        return accountMapper.toAccountResponse(account);
    }

    @Override
    public AccountResponse updateAccount(AccountUpdateRequest accountUpdateRequest) {
        Account account = accountRepository.findById(accountUpdateRequest.getId())
                .orElseThrow(() -> new RuntimeException("Account not found"));
        account.setUpdatedAt(LocalDateTime.now());
        accountMapper.updateAccount(account, accountUpdateRequest);
        return accountMapper.toAccountResponse(account);
    }

    @Override
    public void deleteAccount(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        account.setEnabled(false);
        accountRepository.save(account);
    }


}