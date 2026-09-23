package com.smartlocker.controller;

import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;
import com.smartlocker.entity.User;
import com.smartlocker.service.LockerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 快递柜控制器
 * 体现三层架构：Controller调用Service
 * 包含完整的CRUD操作、状态监控、故障管理
 */
@Controller
@RequestMapping("/lockers")
public class LockerController {

    @Autowired
    private LockerService lockerService;

    /**
     * 查询：查询所有快递柜
     */
    @GetMapping
    public String list(Model model) {
        List<Locker> lockers = lockerService.getAllLockers();
        model.addAttribute("lockers", lockers);

        // 获取统计数据
        Map<String, Integer> stats = lockerService.getLockerStats();
        model.addAttribute("stats", stats);

        return "locker_list";
    }

    /**
     * 查询：多条件查询快递柜
     */
    @GetMapping("/search")
    public String search(@RequestParam(required = false) String lockerName,
                         @RequestParam(required = false) String location,
                         @RequestParam(required = false) Integer status,
                         Model model) {
        List<Locker> lockers = lockerService.getLockersByCondition(
                lockerName, location, status, null, null);
        model.addAttribute("lockers", lockers);

        // 保留查询条件
        Map<String, Object> params = new HashMap<>();
        params.put("lockerName", lockerName);
        params.put("location", location);
        params.put("status", status);
        model.addAttribute("params", params);

        // 获取统计数据
        Map<String, Integer> stats = lockerService.getLockerStats();
        model.addAttribute("stats", stats);

        return "locker_list";
    }

    /**
     * 查询：根据ID查询快递柜详情
     */
    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        Locker locker = lockerService.getLockerById(id);
        model.addAttribute("locker", locker);

        // 获取柜格列表
        List<Box> boxes = lockerService.getLockerBoxes(id);
        model.addAttribute("boxes", boxes);

        // 获取柜格统计
        Map<String, Object> boxStats = lockerService.getBoxStats(id);
        model.addAttribute("boxStats", boxStats);

        return "locker_detail";
    }

    /**
     * 查询：故障快递柜列表
     */
    @GetMapping("/broken")
    public String brokenList(Model model) {
        List<Locker> brokenLockers = lockerService.getBrokenLockers();
        model.addAttribute("lockers", brokenLockers);
        model.addAttribute("isBrokenList", true);
        return "locker_list";
    }

    /**
     * 新增：跳转到新增快递柜页面
     */
    @GetMapping("/add")
    public String toAdd(Model model) {
        model.addAttribute("locker", new Locker());
        return "locker_form";
    }

    /**
     * 新增：创建快递柜
     */
    @PostMapping
    public String add(Locker locker,
                      @RequestParam(required = false) Integer smallCount,
                      @RequestParam(required = false) Integer mediumCount,
                      @RequestParam(required = false) Integer largeCount,
                      RedirectAttributes redirectAttributes) {
        try {
            lockerService.createLocker(locker, smallCount, mediumCount, largeCount);
            redirectAttributes.addFlashAttribute("success", "快递柜创建成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "创建失败：" + e.getMessage());
            return "redirect:/lockers/add";
        }
        return "redirect:/lockers";
    }

    /**
     * 修改：跳转到编辑快递柜页面
     */
    @GetMapping("/edit/{id}")
    public String toEdit(@PathVariable Long id, Model model) {
        Locker locker = lockerService.getLockerById(id);
        model.addAttribute("locker", locker);
        return "locker_form";
    }

    /**
     * 修改：更新快递柜
     */
    @PostMapping("/update/{id}")
    public String update(@PathVariable Long id, Locker locker, RedirectAttributes redirectAttributes) {
        try {
            locker.setId(id);
            lockerService.updateLocker(locker);
            redirectAttributes.addFlashAttribute("success", "快递柜更新成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
        }
        return "redirect:/lockers";
    }

    /**
     * 状态变更：启用/禁用快递柜
     */
    @PostMapping("/status/{id}")
    public String changeStatus(@PathVariable Long id, @RequestParam Integer status, RedirectAttributes redirectAttributes) {
        try {
            lockerService.updateLockerStatus(id, status);
            String statusText = status == 1 ? "启用" : "禁用";
            redirectAttributes.addFlashAttribute("success", "快递柜已" + statusText + "！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "状态变更失败：" + e.getMessage());
        }
        return "redirect:/lockers";
    }

    /**
     * 删除：删除快递柜
     */
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            lockerService.deleteLocker(id);
            redirectAttributes.addFlashAttribute("success", "快递柜删除成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "删除失败：" + e.getMessage());
        }
        return "redirect:/lockers";
    }

    /**
     * 故障报修：跳转到报修页面
     */
    @RequestMapping("/repair/{id}")
    public String toRepair(@PathVariable Long id, Model model) {
        Locker locker = lockerService.getLockerById(id);
        model.addAttribute("locker", locker);
        return "locker_repair";
    }

    /**
     * 故障报修：提交报修
     */
    @RequestMapping(value = "/repair/submit/{id}", method = RequestMethod.POST)
    public String submitRepair(@PathVariable Long id,
                               @RequestParam String repairDesc,
                               @RequestParam(required = false) Long operatorId,
                               RedirectAttributes redirectAttributes) {
        try {
            lockerService.submitRepair(id, repairDesc, operatorId);
            redirectAttributes.addFlashAttribute("success", "故障报修提交成功！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "提交失败：" + e.getMessage());
        }
        return "redirect:/lockers/broken";
    }

    /**
     * 故障维修：完成维修
     * operatorId 可选：未传时默认取当前登录用户作为维修人员
     */
    @RequestMapping("/repair/complete/{id}")
    public String completeRepair(@PathVariable Long id,
                                 @RequestParam(required = false) Long operatorId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        try {
            if (operatorId == null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    operatorId = user.getId();
                }
            }
            lockerService.completeRepair(id, operatorId);
            redirectAttributes.addFlashAttribute("success", "维修完成！");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "维修操作失败：" + e.getMessage());
        }
        return "redirect:/lockers/broken";
    }
}