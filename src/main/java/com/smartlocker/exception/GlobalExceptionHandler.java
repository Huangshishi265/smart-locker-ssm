package com.smartlocker.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;

/**
 * 全局异常处理器
 * 体现Spring MVC的统一异常处理机制
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 处理业务异常
     * 返回JSON格式数据
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public ModelAndView handleBusinessException(BusinessException e, HttpServletRequest request) {
        logger.warn("业务异常：{} - URI: {}", e.getMessage(), request.getRequestURI());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("error", e.getMessage());
        modelAndView.addObject("errorCode", 500);
        modelAndView.setViewName("error");

        return modelAndView;
    }

    /**
     * 处理参数绑定异常
     */
    @ExceptionHandler(org.springframework.validation.BindException.class)
    public ModelAndView handleBindException(org.springframework.validation.BindException e, HttpServletRequest request) {
        StringBuilder errorMsg = new StringBuilder();
        e.getBindingResult().getFieldErrors().forEach(error -> {
            errorMsg.append(error.getDefaultMessage()).append("; ");
        });

        logger.warn("参数校验异常：{} - URI: {}", errorMsg, request.getRequestURI());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("error", "参数校验失败：" + errorMsg);
        modelAndView.addObject("errorCode", 400);
        modelAndView.setViewName("error");

        return modelAndView;
    }

    /**
     * 处理非法参数异常
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ModelAndView handleIllegalArgumentException(IllegalArgumentException e, HttpServletRequest request) {
        logger.warn("非法参数异常：{} - URI: {}", e.getMessage(), request.getRequestURI());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("error", "非法参数：" + e.getMessage());
        modelAndView.addObject("errorCode", 400);
        modelAndView.setViewName("error");

        return modelAndView;
    }

    /**
     * 处理空指针异常
     */
    @ExceptionHandler(NullPointerException.class)
    public ModelAndView handleNullPointerException(NullPointerException e, HttpServletRequest request) {
        logger.error("空指针异常 - URI: {}", request.getRequestURI(), e);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("error", "系统内部错误：空指针异常");
        modelAndView.addObject("errorCode", 500);
        modelAndView.setViewName("error");

        return modelAndView;
    }

    /**
     * 处理其他未知异常
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception e, HttpServletRequest request) {
        logger.error("系统异常 - URI: {}", request.getRequestURI(), e);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("error", "系统异常，请联系管理员：" + e.getMessage());
        modelAndView.addObject("errorCode", 500);
        modelAndView.setViewName("error");

        return modelAndView;
    }
}
