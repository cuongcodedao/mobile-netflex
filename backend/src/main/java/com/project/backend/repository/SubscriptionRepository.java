package com.project.backend.repository;

import com.project.backend.entity.Subscription;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SubscriptionRepository extends JpaRepository<Subscription, String> {
    Subscription findByAccountIdAndActive(Long id, boolean active);
}