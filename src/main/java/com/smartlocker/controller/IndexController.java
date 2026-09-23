package com.smartlocker.controller;

import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;
import com.smartlocker.entity.Package;
import com.smartlocker.entity.User;
import com.smartlocker.service.BoxService;
import com.smartlocker.service.LockerService;
import com.smartlocker.service.PackageService;
import com.smartlocker.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 首页控制器
 * 体现三层架构：Controller调用Service
 * 首页所有统计数字均基于真实数据计算，不使用任何假数据
 */
@Controller
public class IndexController {

    @Autowired
    private PackageService packageService;

    @Autowired
    private BoxService boxService;

    @Autowired
    private LockerService lockerService;

    @Autowired
    private UserService userService;

    /**
     * 首页
     */
    @RequestMapping("/")
    public String index(Model model) {
        model.addAttribute("stats", computeStats());
        return "index";
    }

    /**
     * 后台管理主页
     */
    @RequestMapping("/main")
    public String main() {
        return "main";
    }

    /**
     * 首页统计：基于真实数据计算
     */
    private Map<String, Object> computeStats() {
        Map<String, Object> stats = new HashMap<>();

        List<Package> packages = packageService.getAllPackages();
        List<Box> boxes = boxService.getAllBoxes();
        List<Locker> lockers = lockerService.getAllLockers();
        List<User> users = userService.getAllUsers();

        // 储物格统计
        int totalBoxes = boxes.size();
        int availableBoxes = 0;
        int occupiedBoxes = 0;
        for (Box box : boxes) {
            if (box.getStatus() == null) continue;
            if (box.getStatus() == 1) availableBoxes++;
            else if (box.getStatus() == 2) occupiedBoxes++;
        }

        // 快递柜统计
        int onlineLockers = 0;
        for (Locker locker : lockers) {
            if (locker.getStatus() != null && locker.getStatus() == 1) onlineLockers++;
        }

        // 快递统计
        int pendingPackages = 0;
        int todayPackages = 0;
        for (Package pkg : packages) {
            if (pkg.getStatus() != null && pkg.getStatus() == 1) pendingPackages++;
            java.util.Date d = pkg.getPutInTime() != null ? pkg.getPutInTime() : pkg.getCreateTime();
            if (isToday(d)) todayPackages++;
        }

        // 用户统计
        int activeUsers = 0;
        for (User user : users) {
            if (user.getStatus() != null && user.getStatus() == 1) activeUsers++;
        }

        int usageRate = totalBoxes == 0 ? 0 : (int) Math.round(occupiedBoxes * 100.0 / totalBoxes);

        stats.put("packageCount", packages.size());
        stats.put("pendingPackages", pendingPackages);
        stats.put("todayPackages", todayPackages);
        stats.put("boxCount", totalBoxes);
        stats.put("availableBoxes", availableBoxes);
        stats.put("occupiedBoxes", occupiedBoxes);
        stats.put("boxUsageRate", usageRate);
        stats.put("lockerCount", lockers.size());
        stats.put("onlineLockers", onlineLockers);
        stats.put("userCount", users.size());
        stats.put("activeUsers", activeUsers);

        return stats;
    }

    /**
     * 判断日期是否为今天
     */
    private boolean isToday(java.util.Date date) {
        if (date == null) return false;
        java.util.Calendar now = java.util.Calendar.getInstance();
        java.util.Calendar target = java.util.Calendar.getInstance();
        target.setTime(date);
        return now.get(java.util.Calendar.YEAR) == target.get(java.util.Calendar.YEAR)
                && now.get(java.util.Calendar.DAY_OF_YEAR) == target.get(java.util.Calendar.DAY_OF_YEAR);
    }
}
