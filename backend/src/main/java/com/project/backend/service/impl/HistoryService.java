package com.project.backend.service.impl;


import com.project.backend.dto.request.HistoryCreationRequest;
import com.project.backend.dto.response.HistoryResponse;
import com.project.backend.entity.History;
import com.project.backend.entity.Profile;
import com.project.backend.mapper.HistoryMapper;
import com.project.backend.repository.HistoryRepository;
import com.project.backend.repository.ProfileRepository;
import com.project.backend.service.IHistoryService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class HistoryService implements IHistoryService {
    private final HistoryRepository historyRepository;
    private final ProfileRepository profileRepository;
    private final HistoryMapper historyMapper;
    private final MovieService movieService;

    @Override
    public HistoryResponse create(HistoryCreationRequest historyRequest) {
        Profile profile = profileRepository.findById(historyRequest.getProfileId())
                .orElseThrow(() -> new RuntimeException("Profile not found"));
        History existHistory = historyRepository.findByMovieSlugAndProfileIdAndEpisode(historyRequest.getMovieSlug(), profile.getId(), historyRequest.getEpisode());
        if (existHistory != null) {
            existHistory.setWatchDuration(historyRequest.getWatchDuration());
            existHistory = historyRepository.save(existHistory);
            HistoryResponse historyResponse =  historyMapper.toHistoryDTO(existHistory);
            try {
                historyResponse.setMovie(movieService.getMovieBySlug(historyRequest.getMovieSlug()).getMovie());
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            return historyResponse;
        }
        History history = historyMapper.toHistory(historyRequest);
        history.setProfile(profile);
        history = historyRepository.save(history);
        HistoryResponse historyResponse =  historyMapper.toHistoryDTO(history);
        try {
            historyResponse.setMovie(movieService.getMovieBySlug(historyRequest.getMovieSlug()).getMovie());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return historyResponse;
    }


    @Override
    public void delete(Long id) {
        History history = historyRepository.findById(id).orElseThrow(()-> new RuntimeException("History not found"));
        historyRepository.delete(history);
    }

    @Override
    public List<HistoryResponse> getAllHistoriesByProfileId(Long profileId) {
        List<HistoryResponse> historyDTOS =  historyRepository.findAllByProfileId(profileId)
                .stream()
                .map(history -> {
                    HistoryResponse historyDTO = historyMapper.toHistoryDTO(history);
                    try {
                        historyDTO.setMovie(movieService.getMovieBySlug(history.getMovieSlug()).getMovie());
                    } catch (IOException e) {
                        throw new RuntimeException(e);
                    }
                    return historyDTO;
                })
                .toList();
        return historyDTOS;
    }

    @Override
    @Transactional
    public void deleteAllByProfileId(Long profileId) {
        historyRepository.deleteAllByProfileId(profileId);
    }


}