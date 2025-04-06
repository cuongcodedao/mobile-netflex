package com.project.backend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.project.backend.dto.response.APIMovieListResponse;
import com.project.backend.dto.response.APIMovieResponse;
import com.project.backend.dto.response.APIResponse;
import com.project.backend.dto.response.Movie;

import java.io.IOException;
import java.util.List;

public interface IMovieService {
    APIMovieResponse getMovieBySlug(String slug) throws IOException;
    APIMovieListResponse getMovieList(int page) throws IOException;
    List<Movie> getAllMoviesByGenreSlug(String slug) throws IOException;
    List<Movie> getAllMoviesByYear(String year) throws IOException;
    List<Movie> getAllMoviesByCountrySlug(String slug) throws IOException;
    List<Movie> searchMovie(String keyword) throws IOException;
}
