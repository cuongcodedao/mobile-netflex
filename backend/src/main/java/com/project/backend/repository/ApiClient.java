package com.project.backend.repository;

import com.project.backend.dto.response.*;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


@FeignClient(
        name = "movieApiClient",
        url = "${external.movie-api.base-url}"

)
public interface ApiClient {
    @GetMapping(value = "/phim/{slug}", produces = MediaType.APPLICATION_JSON_VALUE)
    APIMovieResponse getMovieBySlug(@PathVariable("slug") String slug);

    @GetMapping(value = "/danh-sach/phim-moi-cap-nhat-v3", produces = MediaType.APPLICATION_JSON_VALUE)
    APIMovieListResponse getMovieList(@RequestParam(value = "page") int page);

    @GetMapping(value = "/the-loai", produces = MediaType.APPLICATION_JSON_VALUE)
    List<Category> getAllGenres();

    @GetMapping(value = "/quoc-gia", produces = MediaType.APPLICATION_JSON_VALUE)
    List<Country> getAllCountries();

    @GetMapping(value = "/v1/api/the-loai/{slug}", produces = MediaType.APPLICATION_JSON_VALUE)
    APIResponse getAllMoviesByGenreSlug(@PathVariable("slug") String slug);

    @GetMapping(value = "/v1/api/nam/{slug}", produces = MediaType.APPLICATION_JSON_VALUE)
    APIResponse getAllMoviesByYear(@PathVariable("slug") String slug);

    @GetMapping(value = "/v1/api/quoc-gia/{slug}", produces = MediaType.APPLICATION_JSON_VALUE)
    APIResponse getAllMoviesByCountrySlug(@PathVariable("slug") String slug);

    @GetMapping(value = "/v1/api/tim-kiem", produces = MediaType.APPLICATION_JSON_VALUE)
    APIResponse searchMovie(@RequestParam(value = "keyword") String keyword);

}
