package com.project.backend.controller;

import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.entity.Plan;
import com.project.backend.service.IPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/plan")
@RequiredArgsConstructor
public class PlanController {
     private final IPlanService planService;
     @GetMapping("")
     public TemplateResponse<List<Plan>> getAllPlans() {
         List<Plan> plans = planService.getAllPlans();
         return TemplateResponse.<List<Plan>>builder()
                 .result(plans)
                 .build();
     }
}
