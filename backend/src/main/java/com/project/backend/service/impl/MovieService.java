package com.project.backend.service.impl;

import com.google.gson.Gson;
import com.project.backend.dto.response.APIMovieListResponse;
import com.project.backend.dto.response.APIMovieResponse;
import com.project.backend.dto.response.APIResponse;
import com.project.backend.dto.response.Movie;
import com.project.backend.repository.ApiClient;
import com.project.backend.service.IMovieService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MovieService implements IMovieService {

    private final ApiClient apiClient;


    @Override
    public APIMovieResponse getMovieBySlug(String slug) throws IOException {
        APIMovieResponse apiResponse = apiClient.getMovieBySlug(slug);
        return apiResponse;
    }

    @Override
    public APIMovieListResponse getMovieList(int page) throws IOException {
        APIMovieListResponse apiResponse = apiClient.getMovieList(page);
        return apiResponse;
    }

    @Override
    public List<Movie> getAllMoviesByGenreSlug(String slug) throws IOException {
        return apiClient.getAllMoviesByGenreSlug(slug).getData().getItems();
    }

    @Override
    public List<Movie> getAllMoviesByYear(String year) throws IOException {
        return apiClient.getAllMoviesByYear(year).getData().getItems();
    }

    @Override
    public List<Movie> getAllMoviesByCountrySlug(String slug) throws IOException {
        return apiClient.getAllMoviesByCountrySlug(slug).getData().getItems();

    }

    @Override
    public List<Movie> searchMovie(String keyword) throws IOException {
        return apiClient.searchMovie(keyword).getData().getItems();
    }

}
