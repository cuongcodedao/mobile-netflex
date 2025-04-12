package com.project.backend.entity;

import com.project.backend.enums.PlanName;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "Plan")
public class Plan {
    @Id
    private String id;
    @Enumerated(EnumType.STRING)
    private PlanName planName;

    private double price;
    private int maxNumberOfProfile;
    private int maxNumberOfDevice;
    private int maxNumberOfDeviceActive;
}
