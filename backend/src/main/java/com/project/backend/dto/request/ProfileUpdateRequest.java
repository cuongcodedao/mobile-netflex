package com.project.backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import lombok.experimental.FieldDefaults;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProfileUpdateRequest {
    @NotNull(message = "Profile ID is required!")
    Long id;

    @NotBlank(message = "Username is required!")
    String username;

    @NotBlank(message = "Avatar is required!")
    String avatar;

    boolean kid;

    @NotNull(message = "Account ID is required!")
    @JsonProperty("account_id")
    Long accountId;
}
