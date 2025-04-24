package com.project.backend.dto.response;

import com.project.backend.entity.Plan;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class AccountResponse {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private Plan currentPlan;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private boolean enabled;
}
