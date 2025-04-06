package com.project.backend.service;

import com.project.backend.dto.response.APIResponse;
import com.project.backend.dto.response.Category;

import java.io.IOException;
import java.util.List;

public interface IGenreService {
    List<Category> getAllGenres() throws IOException;


}
