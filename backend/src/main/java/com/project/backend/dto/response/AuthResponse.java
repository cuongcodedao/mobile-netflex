package com.project.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {
    private AccountResponse account;
    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";
    private int expiresIn;
}
