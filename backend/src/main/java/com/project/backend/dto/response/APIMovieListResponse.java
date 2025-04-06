package com.project.backend.dto.response;

import lombok.Data;
import org.hibernate.query.sqm.internal.KeyBasedPagination;

import java.util.List;

@Data
public class APIMovieListResponse {
    private boolean status;
    private List<Movie> items;
    private Pagination pagination;
}

@Data
class Pagination {
    private int totalItems;
    private int totalItemsPerPage;
    private int currentPage;
    private int totalPages;
    private int updateToday;

}