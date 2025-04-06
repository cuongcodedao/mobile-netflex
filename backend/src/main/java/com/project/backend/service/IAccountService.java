package com.project.backend.service;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.response.AccountResponse;

import java.util.List;

public interface IAccountService {
    void deleteAccount(Long id);
    AccountResponse getAccountById(Long id);
    AccountResponse updateAccount(AccountUpdateRequest accountUpdateRequest);
    List<AccountResponse> getAllAccounts();
    AccountResponse createAccount(AccountCreationRequest accountCreationRequest);
}
