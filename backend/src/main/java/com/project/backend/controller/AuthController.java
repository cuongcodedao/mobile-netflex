package com.project.backend.controller;

import com.project.backend.dto.request.AccountCreationRequest;
import com.project.backend.dto.request.LogoutRequest;
import com.project.backend.dto.request.RefreshTokenRequest;
import com.project.backend.dto.request.SignInRequest;
import com.project.backend.dto.response.AccountResponse;
import com.project.backend.dto.response.AuthResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.exception.UserAlreadyExistsException;
import com.project.backend.service.IAccountService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {
    private final IAccountService accountService;

    @PostMapping("/signup")
    public TemplateResponse<AccountResponse> createAccount(@RequestBody @Valid AccountCreationRequest accountCreationRequest) throws UserAlreadyExistsException {
        AccountResponse response = accountService.createAccount(accountCreationRequest);
        return TemplateResponse.<AccountResponse>builder()
                .result(response)
                .build();
    }

    @PostMapping("/signin")
    public TemplateResponse<AuthResponse> login(@RequestBody @Valid SignInRequest signInRequest) {
        AuthResponse response = accountService.login(signInRequest);
        return TemplateResponse.<AuthResponse>builder()
                .result(response)
                .build();
    }

    @PostMapping("/refresh-token")
    public TemplateResponse<AuthResponse> refreshToken(@RequestBody @Valid RefreshTokenRequest refreshToken) {
        AuthResponse response = accountService.refreshToken(refreshToken.getRefreshToken());
        return TemplateResponse.<AuthResponse>builder()
                .result(response)
                .build();
    }
    @GetMapping("/check-email")
    public TemplateResponse<Boolean> checkEmailExists(@RequestParam String email) {
        boolean exists = accountService.isEmailExists(email);
        return TemplateResponse.<Boolean>builder()
                .result(exists)
                .build();
    }

    @PostMapping("/logout")
    public TemplateResponse<Void> logout(@RequestBody @Valid LogoutRequest logoutRequest) {
        accountService.logout(logoutRequest);
        return TemplateResponse.<Void>builder()
                .build();
    }
}
