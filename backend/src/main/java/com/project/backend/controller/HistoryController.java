package com.project.backend.controller;

import com.project.backend.dto.request.HistoryCreationRequest;
import com.project.backend.dto.response.HistoryResponse;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IHistoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/history")
@RequiredArgsConstructor
public class HistoryController {
    private final IHistoryService historyService;

    @GetMapping("/profile/{profileId}")
    public TemplateResponse<List<HistoryResponse>> getAllHistoriesByProfileId(@PathVariable Long profileId) {
        return TemplateResponse.<List<HistoryResponse>>builder()
                .result(historyService.getAllHistoriesByProfileId(profileId))
                .build();
    }

    @PostMapping("")
    public TemplateResponse<HistoryResponse> createHistory(@RequestBody @Valid HistoryCreationRequest historyRequest) {
        HistoryResponse response = historyService.create(historyRequest);
        return TemplateResponse.<HistoryResponse>builder()
                .result(response)
                .build();
    }



    @DeleteMapping("/{id}")
    public TemplateResponse<Void> deleteHistory(@PathVariable Long id) {
        historyService.delete(id);
        return TemplateResponse.<Void>builder()
                .build();
    }
    @DeleteMapping("/profile/{profileId}")
    public TemplateResponse<Void> deleteAllHistoriesByProfileId(@PathVariable Long profileId) {
        historyService.deleteAllByProfileId(profileId);
        return TemplateResponse.<Void>builder()
                .build();
    }
}