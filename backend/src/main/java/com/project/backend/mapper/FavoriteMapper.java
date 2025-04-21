package com.project.backend.mapper;


import com.project.backend.dto.FavoriteDTO;
import com.project.backend.entity.Favorite;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface FavoriteMapper {

     FavoriteDTO toFavoriteDTO(Favorite favorite);
     Favorite toFavorite(FavoriteDTO favoriteDTO);
}
