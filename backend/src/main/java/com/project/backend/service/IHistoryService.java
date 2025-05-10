package com.project.backend.service;

import com.project.backend.dto.request.HistoryCreationRequest;
import com.project.backend.dto.response.HistoryResponse;

import java.util.List;


public interface IHistoryService {
    HistoryResponse create(HistoryCreationRequest historyRequest);
    void delete(Long id);
    List<HistoryResponse> getAllHistoriesByProfileId(Long profileId);
    void deleteAllByProfileId(Long profileId);
}
