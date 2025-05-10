package com.project.backend.exception;


import com.project.backend.dto.response.TemplateResponse;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.naming.AuthenticationException;
import java.nio.file.AccessDeniedException;
import java.util.Map;
import java.util.Objects;
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
    private static String MIN_ATTRIBUTE = "min";

    @ExceptionHandler(value = Exception.class)
    ResponseEntity<TemplateResponse> handlingRuntimeException(Exception exception){
        TemplateResponse apiResponse = new TemplateResponse();
        exception.printStackTrace();

        apiResponse.setCode(ErrorCode.UNCATEGORIZED_EXCEPTION.getCode());
        apiResponse.setMessage(ErrorCode.UNCATEGORIZED_EXCEPTION.getMessage());

        return ResponseEntity.status(ErrorCode.UNCATEGORIZED_EXCEPTION.getHttpStatusCode()).body(apiResponse);
    }

    @ExceptionHandler(value = BadCredentialsException.class)
    ResponseEntity<TemplateResponse> handlingBadCredentialsException(BadCredentialsException exception){
        TemplateResponse apiResponse = new TemplateResponse();
        apiResponse.setCode(ErrorCode.BAD_CREDENTIALS.getCode());
        apiResponse.setMessage(ErrorCode.BAD_CREDENTIALS.getMessage());

        return ResponseEntity.status(ErrorCode.BAD_CREDENTIALS.getHttpStatusCode()).body(apiResponse);
    }


    @ExceptionHandler(value = AppException.class)
    ResponseEntity<TemplateResponse> handlingAppException(AppException exception){
        ErrorCode errorCode = exception.getErrorCode();
        TemplateResponse apiResponse = new TemplateResponse();

        apiResponse.setCode(errorCode.getCode());
        apiResponse.setMessage(errorCode.getMessage());

        return ResponseEntity.badRequest().body(apiResponse);
    }
    @ExceptionHandler(value = UserAlreadyExistsException.class)
    public ResponseEntity<TemplateResponse> UserAlreadyExistsExceptionHandler(UserAlreadyExistsException exception) {
        return ResponseEntity
                .status(HttpStatus.CONFLICT)
                .body(
                        TemplateResponse.builder()
                                .code(ErrorCode.USER_ALREADY_EXISTS.getCode())
                                .message(ErrorCode.USER_ALREADY_EXISTS.getMessage())
                                .build()
                );
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    ResponseEntity<TemplateResponse> handlingValidation(MethodArgumentNotValidException exception) {
        String errorMessage = exception.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getField() + ": " + fieldError.getDefaultMessage())
                .findFirst()
                .orElse("Validation error");

        TemplateResponse apiResponse = TemplateResponse.builder()
                .code(ErrorCode.UNCATEGORIZED_EXCEPTION.getCode())
                .message(errorMessage)
                .build();

        return ResponseEntity.badRequest().body(apiResponse);
    }

    @ExceptionHandler(value = HttpRequestMethodNotSupportedException.class)
    ResponseEntity<TemplateResponse> handlingMethodNotSupported(HttpRequestMethodNotSupportedException exception){
        TemplateResponse apiResponse = TemplateResponse.builder()
                .code(ErrorCode.HTTP_METHOD_NOT_SUPPORTED.getCode())
                .message(ErrorCode.HTTP_METHOD_NOT_SUPPORTED.getMessage())
                .build();

        return ResponseEntity.status(ErrorCode.HTTP_METHOD_NOT_SUPPORTED.getHttpStatusCode()).body(apiResponse);
    }

    @ExceptionHandler(value = AccessDeniedException.class)
    ResponseEntity<TemplateResponse> handlingAccessDenied(AccessDeniedException exception){
        log.info("Access Denied Exception: {}", exception.getMessage());
        TemplateResponse apiResponse = TemplateResponse.builder()
                .code(ErrorCode.UNAUTHORIZED.getCode())
                .message(ErrorCode.UNAUTHORIZED.getMessage())
                .build();

        return ResponseEntity.status(ErrorCode.UNAUTHORIZED.getHttpStatusCode()).body(apiResponse);
    }

    @ExceptionHandler(value = AuthenticationException.class)
    ResponseEntity<TemplateResponse> handlingAuthenticationException(AuthenticationException exception){
        TemplateResponse apiResponse = TemplateResponse.builder()
                .code(ErrorCode.UNAUTHENTICATED.getCode())
                .message(ErrorCode.UNAUTHENTICATED.getMessage())
                .build();

        return ResponseEntity.status(ErrorCode.UNAUTHENTICATED.getHttpStatusCode()).body(apiResponse);
    }

    private String mapAtribute(String message, Map<String, Object> attributes){
        for (Map.Entry<String, Object> entry : attributes.entrySet()){
            message = message.replace("{" + entry.getKey() + "}", Objects.toString(entry.getValue()));
        }
        return message;

    }

}
