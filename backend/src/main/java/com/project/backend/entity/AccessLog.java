package com.project.backend.entity;

import com.project.backend.dto.response.Movie;
import com.project.backend.enums.DeviceType;
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
@Table(name = "Access_Log")
public class AccessLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(nullable = false)
    private Profile profile;

    private String deviceName;

    @Enumerated(EnumType.STRING)
    private DeviceType deviceType;
    private String deviceAddress;
    private String location;
    private String status;
    private LocalDateTime lastLogin;
}


