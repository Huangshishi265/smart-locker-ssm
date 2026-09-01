package com.smartlocker.controller;

import com.smartlocker.dto.BoxDetail;
import com.smartlocker.dto.PackageDetail;
import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;
import com.smartlocker.entity.Package;
import com.smartlocker.service.BoxService;
import com.smartlocker.service.LockerService;
import com.smartlocker.service.PackageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 快递控制器
 * 体现三层架构：Controller调用Service
 * 包含完整的CRUD操作
 */
@Controller
public class PackageController {

    @Autowired  // IOC：依赖注入
    private PackageService packageService;

    @Autowired
    private BoxService boxService;

    @Autowired
    private LockerService lockerService;

    @Autowired
    private com.smartlocker.service.UserService userService;  // ✅ 新增：注入 UserService

    /**
     * 查询：查询所有快递（使用多表关联查询）
     */
    @RequestMapping("/packages")
    public String list(Model model) {
        List<PackageDetail> packages = packageService.getPackageDetails();
        model.addAttribute("packages", packages);
        return "package_list";
    }

    /**
     * 新增：跳转到新增快递页面
     */
    @RequestMapping("/packages/add")
    public String toAdd(Model model) {
        model.addAttribute("lockers", lockerService.getAllLockers());
        model.addAttribute("boxes", boxService.getAllBoxes());
        model.addAttribute("users", userService.getAllUsers());  // ✅ 新增：传递用户列表
        return "package_form";
    }

    /**
     * 新增/修改：保存快递
     */
    @RequestMapping(value = "/packages/save", method = RequestMethod.POST)
    public String save(Package pkg) {
        if (pkg.getId() == null) {
            // 新增
            packageService.createPackage(pkg);
        } else {
            // 修改
            packageService.updatePackage(pkg);
        }
        return "redirect:/packages";
    }

    /**
     * 修改：跳转到编辑快递页面
     */
    @RequestMapping("/packages/edit/{id}")
    public String toEdit(@PathVariable Long id, Model model) {
        Package pkg = packageService.getPackageById(id);
        model.addAttribute("pkg", pkg);
        model.addAttribute("lockers", lockerService.getAllLockers());
        model.addAttribute("boxes", boxService.getAllBoxes());
        model.addAttribute("users", userService.getAllUsers());  // ✅ 新增：传递用户列表
        return "package_form";
    }

    /**
     * 删除：删除快递
     */
    @RequestMapping("/packages/delete/{id}")
    public String delete(@PathVariable Long id) {
        packageService.deletePackage(id);
        return "redirect:/packages";
    }
}