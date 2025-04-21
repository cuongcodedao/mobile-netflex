package com.project.backend.service;

import com.project.backend.dto.FavoriteDTO;

import java.util.List;

public interface IFavoriteService {
    FavoriteDTO addToFavorite(FavoriteDTO favoriteDTO);
    FavoriteDTO removeFromFavorite(Long id);
    List<FavoriteDTO> getAllFavoritesByProfileId(Long profileId);
    FavoriteDTO getFavoriteById(Long id);
}
