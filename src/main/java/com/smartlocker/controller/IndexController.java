package com.smartlocker.controller;

import com.smartlocker.dto.BoxDetail;
import com.smartlocker.dto.PackageDetail;
import com.smartlocker.service.BoxService;
import com.smartlocker.service.PackageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

/**
 * 首页控制器
 * 体现三层架构：Controller调用Service
 */
@Controller
public class IndexController {

    @Autowired  // IOC：依赖注入
    private PackageService packageService;

    @Autowired
    private BoxService boxService;

    /**
     * 首页
     * 只显示统计信息，不显示详细数据
     */
    @RequestMapping("/")
    public String index(Model model) {
        // 查询快递详情（用于统计）
        List<PackageDetail> packages = packageService.getPackageDetails();
        model.addAttribute("packages", packages);

        // 查询储物格详情（用于统计）
        List<BoxDetail> boxes = boxService.getBoxDetails();
        model.addAttribute("boxes", boxes);

        return "index";
    }

    /**
     * 后台管理主页
     * 显示后台管理框架页面
     */
    @RequestMapping("/main")
    public String main() {
        return "main";
    }
}