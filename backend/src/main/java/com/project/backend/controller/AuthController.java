package com.project.backend.controller;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.RefreshTokenRequest;
import com.project.backend.dto.request.SignInRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.dto.response.AuthResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.exception.UserAlreadyExistsException;
import com.project.backend.service.IAccountService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    private final IAccountService accountService;

    @PostMapping("/signup")
    public TemplateResponse<AccountResponse> createAccount(@RequestBody AccountCreationRequest accountCreationRequest) throws UserAlreadyExistsException {
        AccountResponse response = accountService.createAccount(accountCreationRequest);
        return TemplateResponse.<AccountResponse>builder()
                .result(response)
                .build();
    }

    @PostMapping("/signin")
    public TemplateResponse<AuthResponse> login(@RequestBody SignInRequest signInRequest) {
        AuthResponse response = accountService.login(signInRequest);
        return TemplateResponse.<AuthResponse>builder()
                .result(response)
                .build();
    }

    @PostMapping("/refresh-token")
    public TemplateResponse<AuthResponse> refreshToken(@RequestBody RefreshTokenRequest refreshToken) {
        AuthResponse response = accountService.refreshToken(refreshToken.getRefreshToken());
        return TemplateResponse.<AuthResponse>builder()
                .result(response)
                .build();
    }
}
