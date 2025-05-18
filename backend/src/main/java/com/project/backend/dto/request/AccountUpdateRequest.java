package com.project.backend.dto.request;

import jakarta.validation.constraints.Size;
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
    Long id;

    @Size(min = 8, message = "Password must have at least 8 characters!")
    @Size(max = 20, message = "Password can have at most 20 characters!")
    String password;

    String firstName;

    String lastName;


}
