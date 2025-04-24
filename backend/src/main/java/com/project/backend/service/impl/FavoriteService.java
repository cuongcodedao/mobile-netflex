package com.project.backend.service.impl;

import com.project.backend.dto.FavoriteDTO;
import com.project.backend.entity.Favorite;
import com.project.backend.mapper.FavoriteMapper;
import com.project.backend.repository.FavoriteRepository;
import com.project.backend.service.IFavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FavoriteService implements IFavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final FavoriteMapper favoriteMapper;

    @Override
    public FavoriteDTO addToFavorite(FavoriteDTO favoriteDTO) {
        Favorite favorite = favoriteMapper.toFavorite(favoriteDTO);
        favorite = favoriteRepository.save(favorite);
        return favoriteMapper.toFavoriteDTO(favorite);
    }

    @Override
    public FavoriteDTO removeFromFavorite(Long id) {
        Favorite favorite = favoriteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        favoriteRepository.delete(favorite);
        return favoriteMapper.toFavoriteDTO(favorite);
    }

    @Override
    public List<FavoriteDTO> getAllFavoritesByProfileId(Long profileId) {
        List<Favorite> favorites = favoriteRepository.findAllByProfileId(profileId);
        return favorites.stream()
                .map(favoriteMapper::toFavoriteDTO)
                .toList();
    }

    @Override
    public FavoriteDTO getFavoriteById(Long id) {
        Favorite favorite = favoriteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Favorite not found"));
        return favoriteMapper.toFavoriteDTO(favorite);
    }


}
