package com.project.backend.service.impl;

import com.project.backend.dto.request.HistoryCreationRequest;
import com.project.backend.dto.response.APIMovieResponse;
import com.project.backend.dto.response.EpisodeReponse;
import com.project.backend.dto.response.HistoryResponse;
import com.project.backend.dto.response.ServerData;
import com.project.backend.entity.History;
import com.project.backend.entity.Profile;
import com.project.backend.mapper.HistoryMapper;
import com.project.backend.repository.HistoryRepository;
import com.project.backend.repository.ProfileRepository;
import com.project.backend.service.IHistoryService;
import com.project.backend.service.IMovieService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class HistoryService implements IHistoryService {
    private final HistoryRepository historyRepository;
    private final ProfileRepository profileRepository;
    private final HistoryMapper historyMapper;
    private final IMovieService movieService;

    private final ExecutorService executor = Executors.newFixedThreadPool(10); // Giới hạn 10 luồng song song

    @Override
    public HistoryResponse create(HistoryCreationRequest historyRequest) {
        Profile profile = profileRepository.findById(historyRequest.getProfileId())
                .orElseThrow(() -> new RuntimeException("Profile with ID " + historyRequest.getProfileId() + " not found"));

        History history = historyRepository.findByMovieSlugAndProfileIdAndEpisodeIndex(
                historyRequest.getMovieSlug(), profile.getId(), historyRequest.getEpisodeIndex());

        if (history != null) {
            history.setWatchDuration(historyRequest.getWatchDuration());
        } else {
            history = historyMapper.toHistory(historyRequest);
            history.setProfile(profile);
        }

        history = historyRepository.save(history);

        HistoryResponse historyResponse = historyMapper.toHistoryDTO(history);
        historyResponse.setEpisode(getEpisodeInfo(history.getMovieSlug(), history.getEpisodeIndex()));
        return historyResponse;
    }

    @Override
    public void delete(Long id) {
        History history = historyRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("History with ID " + id + " not found"));
        historyRepository.delete(history);
    }

    @Override
    public List<HistoryResponse> getAllHistoriesByProfileId(Long profileId) {
        List<History> histories = historyRepository.findAllByProfileId(profileId);

        List<CompletableFuture<HistoryResponse>> futures = histories.stream()
                .map(history -> CompletableFuture.supplyAsync(() -> {
                    HistoryResponse dto = historyMapper.toHistoryDTO(history);
                    try {
                        APIMovieResponse movieResponse = movieService.getMovieBySlugAsync(history.getMovieSlug()).join();
                        ServerData serverData = movieResponse.getEpisodes().get(0).getServerData().get(history.getEpisodeIndex());
                        EpisodeReponse episode = EpisodeReponse.builder()
                                .poster_url(movieResponse.getMovie().getPoster_url())
                                .name(serverData.getName())
                                .slug(movieResponse.getMovie().getSlug())
                                .filename(serverData.getFilename())
                                .link_embed(serverData.getLink_embed())
                                .link_m3u8(serverData.getLink_m3u8())
                                .build();
                        dto.setEpisode(episode);
                    } catch (Exception e) {
                        // Ghi log nếu cần, không throw để không ảnh hưởng các phần tử khác
                        System.err.println("Error fetching movie for slug: " + history.getMovieSlug());
                    }
                    return dto;
                }, executor))
                .collect(Collectors.toList());

        return futures.stream()
                .map(CompletableFuture::join)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void deleteAllByProfileId(Long profileId) {
        historyRepository.deleteAllByProfileId(profileId);
    }

    private EpisodeReponse getEpisodeInfo(String movieSlug, int episodeIndex) {
        try {
            APIMovieResponse movieResponse = movieService.getMovieBySlug(movieSlug);
            ServerData serverData = movieResponse.getEpisodes().get(0).getServerData().get(episodeIndex);

            return EpisodeReponse.builder()
                    .poster_url(movieResponse.getMovie().getPoster_url())
                    .name(serverData.getName())
                    .slug(serverData.getSlug())
                    .filename(serverData.getFilename())
                    .link_embed(serverData.getLink_embed())
                    .link_m3u8(serverData.getLink_m3u8())
                    .build();

        } catch (IOException | IndexOutOfBoundsException e) {
            throw new RuntimeException("Failed to retrieve episode info for slug: " + movieSlug + ", episode index: " + episodeIndex, e);
        }
    }
}
