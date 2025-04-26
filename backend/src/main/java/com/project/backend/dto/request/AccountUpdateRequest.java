package com.project.backend.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountUpdateRequest {
    @NotNull(message = "Account ID is required!")
    Long id;

    String password;

    @NotBlank(message = "First name is required!")
    String firstName;

    @NotBlank(message = "Last name is required!")
    String lastName;


}
