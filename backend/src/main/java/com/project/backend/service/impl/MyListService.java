package com.project.backend.service.impl;

import com.project.backend.dto.request.MyListCreationRequest;
import com.project.backend.dto.response.APIMovieResponse;
import com.project.backend.dto.response.Movie;
import com.project.backend.entity.Profile;
import com.project.backend.repository.ProfileRepository;
import com.project.backend.service.IMovieService;
import com.project.backend.service.IMyListService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MyListService implements IMyListService {
    private final ProfileRepository profileRepository;
    private final IMovieService movieService;
    @Override
    public boolean addToMyList(MyListCreationRequest myListCreationRequest) {
        Profile profile = profileRepository.findById(myListCreationRequest.getProfileId()).orElseThrow(() -> new RuntimeException("Profile not found"));
        StringBuilder myList = null;
        if(profile.getMyMovieList() == null || profile.getMyMovieList().trim().isEmpty()) {
            myList = new StringBuilder();
        } else {
            if(profile.getMyMovieList().contains(myListCreationRequest.getSlugMovie())) {
                return true;
            }
            myList = new StringBuilder(profile.getMyMovieList());
        }
        myList.append(myListCreationRequest.getSlugMovie()).append(",");
        profile.setMyMovieList(myList.toString());
        profileRepository.save(profile);
        return true;
    }

    @Override
    public List<Movie> getMyListByProfileId(Long profileId) {
        Profile profile = profileRepository.findById(profileId)
                .orElseThrow(() -> new RuntimeException("Profile not found"));

        String myList = profile.getMyMovieList();
        if (myList == null || myList.trim().isEmpty()) {
            return Collections.emptyList();
        }

        String[] slugs = myList.split(",");

        List<CompletableFuture<Movie>> futures = Arrays.stream(slugs)
                .map(String::trim)
                .filter(slug -> !slug.isEmpty())
                .map(slug -> CompletableFuture.supplyAsync(() -> {
                    try {
                        return movieService.getMovieBySlugAsync(slug).join().getMovie();
                    } catch (Exception e) {
                        System.err.println("Failed to get movie for slug: " + slug);
                        return null;
                    }
                }))
                .collect(Collectors.toList());

        return futures.stream()
                .map(CompletableFuture::join)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }


}
