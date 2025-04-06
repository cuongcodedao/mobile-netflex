package com.project.backend.controller;

import com.project.backend.dto.response.Category;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IGenreService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/genres")
public class GenreController {
    private final IGenreService genreService;

    @GetMapping("")
    public TemplateResponse<List<Category>> getAllGenres() throws IOException {
        List<Category> categories = genreService.getAllGenres();
        return TemplateResponse.<List<Category>>builder()
                .result(categories)
                .build();
    }
}