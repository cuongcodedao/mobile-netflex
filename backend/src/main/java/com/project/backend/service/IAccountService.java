package com.project.backend.service;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.AccountUpdateRequest;
import com.project.backend.dto.request.LogoutRequest;
import com.project.backend.dto.request.SignInRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.dto.response.AuthResponse;
import com.project.backend.exception.UserAlreadyExistsException;

import java.util.List;

public interface IAccountService {
    void deleteAccount(Long id);
    AccountResponse getAccountById(Long id);
    AccountResponse updateAccount(Long id, AccountUpdateRequest accountUpdateRequest);
    List<AccountResponse> getAllAccounts();
    AccountResponse createAccount(AccountCreationRequest accountCreationRequest) throws UserAlreadyExistsException;
    AuthResponse login(SignInRequest signInRequest);
    AuthResponse refreshToken(String refreshToken);
    boolean isEmailExists(String email);
    void logout(LogoutRequest logoutRequest);
}
