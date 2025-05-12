package com.project.backend.service;

import com.project.backend.dto.request.MyListCreationRequest;
import com.project.backend.dto.response.Movie;

import java.util.List;

public interface IMyListService {

    boolean addToMyList(MyListCreationRequest myListCreationRequest);
    List<Movie> getMyListByProfileId(Long profileId);

}
