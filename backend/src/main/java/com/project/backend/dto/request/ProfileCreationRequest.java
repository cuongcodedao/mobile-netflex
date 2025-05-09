package com.project.backend.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.w3c.dom.stylesheets.LinkStyle;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ProfileCreationRequest {
    @NotBlank(message = "Username is required!")
    String username;

    @NotBlank(message = "Avatar is required!")
    String avatar;

    boolean kid;

    @NotNull(message = "Account ID is required!")
    @JsonProperty("account_id")
    Long accountId;

    List<String> favorite_genres;

}
