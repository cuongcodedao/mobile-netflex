package com.project.backend.service.impl;

import com.project.backend.entity.Plan;
import com.project.backend.repository.PlanRepository;
import com.project.backend.service.IPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PlanService implements IPlanService {
    private final PlanRepository planRepository;

    @Override
    public List<Plan> getAllPlans() {
        return planRepository.findAll();
    }
}
