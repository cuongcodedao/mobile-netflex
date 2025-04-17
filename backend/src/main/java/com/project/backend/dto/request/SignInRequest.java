package com.project.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class SignInRequest {
    @NotBlank(message = "Email is required!")
    private String email;

    @NotBlank(message = "Password is required!")
    private String password;
    private String deviceId;
    private String deviceName;
    private String deviceType;
    private String deviceAddress;
    private String location;

}
