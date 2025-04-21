package com.project.backend.controller;

import com.project.backend.dto.FavoriteDTO;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IFavoriteService;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RequestMapping("/api/v1/favorite")
@RestController
public class FavoriteController {
    private final IFavoriteService favoriteService;

    @GetMapping("/profile/{profileId}")
    public TemplateResponse<List<FavoriteDTO>> getAllFavoritesByProfileId(@PathVariable Long profileId) {
        List<FavoriteDTO> favorites = favoriteService.getAllFavoritesByProfileId(profileId);
        return TemplateResponse.<List<FavoriteDTO>>builder()
                .result(favorites)
                .build();
    }

    @PostMapping("")
    public TemplateResponse<FavoriteDTO> addToFavorite(@RequestBody FavoriteDTO favoriteDTO) {
        FavoriteDTO favorite = favoriteService.addToFavorite(favoriteDTO);
        return TemplateResponse.<FavoriteDTO>builder()
                .result(favorite)
                .build();
    }

    @DeleteMapping("/{id}")
    public TemplateResponse<FavoriteDTO> removeFromFavorite(@PathVariable Long id) {
        FavoriteDTO favorite = favoriteService.removeFromFavorite(id);
        return TemplateResponse.<FavoriteDTO>builder()
                .result(favorite)
                .build();
    }

    @GetMapping("/{id}")
    public TemplateResponse<FavoriteDTO> getFavoriteById(@PathVariable Long id) {
        FavoriteDTO favorite = favoriteService.getFavoriteById(id);
        return TemplateResponse.<FavoriteDTO>builder()
                .result(favorite)
                .build();
    }
}
