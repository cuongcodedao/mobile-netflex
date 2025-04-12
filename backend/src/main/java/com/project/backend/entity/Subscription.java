package com.project.backend.entity;

import com.project.backend.enums.PaymentStatus;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.time.LocalDateTime;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
@Table(name = "Subscription")
public class Subscription {
    @Id
    private String id;

    @ManyToOne
    @JoinColumn(nullable = false)
    private Account account;

    @ManyToOne
    @JoinColumn(nullable = false)
    private Plan plan;

    private LocalDate startDate;
    @Enumerated(EnumType.STRING)
    private PaymentStatus status;
    private boolean active;
}

