package com.project.backend.controller;

import com.project.backend.dto.HistoryDTO;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/history")
@RequiredArgsConstructor
public class HistoryController {
    private final IHistoryService historyService;

    @GetMapping("/profile/{profileId}")
    public TemplateResponse<List<HistoryDTO>> getAllHistoriesByProfileId(@PathVariable Long profileId) {
        return TemplateResponse.<List<HistoryDTO>>builder()
                .result(historyService.getAllHistoriesByProfileId(profileId))
                .build();
    }

    @PostMapping("")
    public TemplateResponse<HistoryDTO> createHistory(@RequestBody HistoryDTO historyRequest) {
        HistoryDTO response = historyService.create(historyRequest);
        return TemplateResponse.<HistoryDTO>builder()
                .result(response)
                .build();
    }

    @PutMapping("/{id}")
    public TemplateResponse<HistoryDTO> updateHistory(@PathVariable Long id, @RequestBody HistoryDTO historyRequest) {
        historyRequest.setId(id);
        HistoryDTO response = historyService.update(historyRequest);
        return TemplateResponse.<HistoryDTO>builder()
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