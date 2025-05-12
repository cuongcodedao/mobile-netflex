package com.project.backend.controller;

import com.project.backend.dto.request.MyListCreationRequest;
import com.project.backend.dto.response.Movie;
import com.project.backend.dto.response.TemplateResponse;
import com.project.backend.service.IMyListService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/v1/mylist")
public class MyListController {
    private final IMyListService myListService;

    @PostMapping("")
    public TemplateResponse<Boolean> addToMyList(@RequestBody MyListCreationRequest myListCreationRequest) {
        boolean result = myListService.addToMyList(myListCreationRequest);
        return TemplateResponse.<Boolean>builder()
                .result(result)
                .build();
    }

    @GetMapping("/profile/{profileId}")
    public TemplateResponse<List<Movie>> getMyListByProfileId(@PathVariable Long profileId) {
        List<Movie> myList = myListService.getMyListByProfileId(profileId);
        return TemplateResponse.<List<Movie>>builder()
                .result(myList)
                .build();
    }
}
