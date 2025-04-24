package com.project.backend.controller;

import com.project.backend.dto.response.Category;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.ICategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/category")
public class CategoryController {
    private final ICategoryService categoryService;

    @GetMapping("")
    public TemplateResponse<List<Category>> getAllCategories() throws IOException {
        List<Category> categories = categoryService.getAllCategories();
        return TemplateResponse.<List<Category>>builder()
                .result(categories)
                .build();
    }
}