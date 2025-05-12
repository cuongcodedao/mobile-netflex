package com.project.backend.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Data
public class LogoutRequest {
    String email;
    String refreshToken;
    String accessToken;
    Long accessLogId;
}
