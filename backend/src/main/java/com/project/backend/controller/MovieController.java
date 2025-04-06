package com.project.backend.controller;

import com.project.backend.dto.response.*;
import com.project.backend.service.impl.MovieService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/v1/movies")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class MovieController {

    private final MovieService movieService;

    @GetMapping(value = "/{slug}")
    public TemplateResponse<APIMovieResponse> getMovieBySlug(@PathVariable("slug") String slug) throws IOException {
        APIMovieResponse response = movieService.getMovieBySlug(slug);
        return TemplateResponse.<APIMovieResponse>builder()
                .result(response)
                .build();
    }

    @GetMapping("")
    public TemplateResponse<APIMovieListResponse> getMovieList(@RequestParam(value = "page") int page) throws IOException {
        APIMovieListResponse response = movieService.getMovieList(page);
        return TemplateResponse.<APIMovieListResponse>builder()
                .result(response)
                .build();
    }

    @GetMapping(value = "/genre/{slug}")
    public TemplateResponse<List<Movie>> getAllMoviesByGenreSlug(@PathVariable("slug") String slug) throws IOException {
        List<Movie> response = movieService.getAllMoviesByGenreSlug(slug);
        return TemplateResponse.<List<Movie>>builder()
                .result(response)
                .build();
    }

    @GetMapping(value = "/year/{year}")
    public TemplateResponse<List<Movie>> getAllMoviesByYear(@PathVariable("year") String year) throws IOException {
        List<Movie> response = movieService.getAllMoviesByYear(year);
        return TemplateResponse.<List<Movie>>builder()
                .result(response)
                .build();
    }

    @GetMapping(value = "/country/{slug}")
    public TemplateResponse<List<Movie>> getAllMoviesByNationSlug(@PathVariable("slug") String slug) throws IOException {
        List<Movie> response = movieService.getAllMoviesByCountrySlug(slug);
        return TemplateResponse.<List<Movie>>builder()
                .result(response)
                .build();
    }

    @GetMapping(value = "/search")
    public TemplateResponse<List<Movie>> searchMovie(@RequestParam(value = "keyword") String keyword) throws IOException {
        List<Movie> response = movieService.searchMovie(keyword);
        return TemplateResponse.<List<Movie>>builder()
                .result(response)
                .build();
    }
}