package com.smartlocker.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;

/**
 * 日志切面类
 * 体现AOP（面向切面编程）的核心应用
 */
@Aspect
@Component
public class LogAspect {

    /**
     * 定义切点：拦截所有Controller层的方法
     */
    @Pointcut("execution(* com.smartlocker.controller.*.*(..))")
    public void controllerPointcut() {}

    /**
     * 前置通知：在目标方法执行之前执行
     * 用途：记录方法开始执行的日志
     */
    @Before("controllerPointcut()")
    public void beforeMethod(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        String className = joinPoint.getTarget().getClass().getSimpleName();
        System.out.println("【AOP前置通知】" + className + "." + methodName + "() 方法开始执行");
    }

    /**
     * 后置通知：在目标方法执行之后执行（无论成功或失败）
     * 用途：记录方法执行完成的日志
     */
    @After("controllerPointcut()")
    public void afterMethod(JoinPoint joinPoint) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("【AOP后置通知】" + methodName + "() 方法执行结束");
    }

    /**
     * 返回通知：在目标方法成功返回结果之后执行
     * 用途：记录方法返回值
     */
    @AfterReturning(pointcut = "controllerPointcut()", returning = "result")
    public void afterReturningMethod(JoinPoint joinPoint, Object result) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("【AOP返回通知】" + methodName + "() 方法执行成功，返回值：" + result);
    }

    /**
     * 异常通知：在目标方法抛出异常时执行
     * 用途：记录异常信息
     */
    @AfterThrowing(pointcut = "controllerPointcut()", throwing = "exception")
    public void afterThrowingMethod(JoinPoint joinPoint, Exception exception) {
        String methodName = joinPoint.getSignature().getName();
        System.out.println("【AOP异常通知】" + methodName + "() 方法执行异常：" + exception.getMessage());
    }

    /**
     * 环绕通知：包围目标方法的执行
     * 用途：统计方法执行时间，控制方法执行
     */
    @Around("controllerPointcut()")
    public Object aroundMethod(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        String methodName = joinPoint.getSignature().getName();

        try {
            // 执行目标方法
            Object result = joinPoint.proceed();
            long endTime = System.currentTimeMillis();
            long executeTime = endTime - startTime;

            System.out.println("【AOP环绕通知】" + methodName + "() 方法执行时间：" + executeTime + "ms");

            return result;
        } catch (Throwable e) {
            long endTime = System.currentTimeMillis();
            long executeTime = endTime - startTime;

            System.out.println("【AOP环绕通知】" + methodName + "() 方法执行失败，耗时：" + executeTime + "ms");

            throw e;
        }
    }
}
