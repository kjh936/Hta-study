package com.naver.myhome.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

//AuthenticationFailureHandler : 로그인 실패 후 처리할 작업을 해야할 때 사용하는 인터페이스
@Component
public class LoginFailHandler implements AuthenticationFailureHandler {

    private static final Logger logger = LoggerFactory.getLogger(LoginFailHandler.class);

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
        HttpSession session = request.getSession();

        logger.info(exception.getMessage());
        logger.info("로그인 실패");
        session.setAttribute("loginfail", "loginFailMsg");
        String url = request.getContextPath() + "/member/login";
        response.sendRedirect(url);
    }
}