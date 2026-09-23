package com.smartlocker.interceptor;

import com.smartlocker.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 登录拦截器
 * 未登录用户访问后台页面时重定向到登录页
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Object user = request.getSession().getAttribute("user");
        if (user == null) {
            // 未登录：重定向到登录页
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
