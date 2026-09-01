package com.smartlocker.controller;

import com.smartlocker.dto.BoxDetail;
import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;
import com.smartlocker.service.BoxService;
import com.smartlocker.service.LockerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 储物格控制器
 * 体现三层架构：Controller调用Service
 * 包含完整的CRUD操作
 */
@Controller
public class BoxController {

    @Autowired  // IOC：依赖注入
    private BoxService boxService;

    @Autowired
    private LockerService lockerService;

    /**
     * 查询：查询所有储物格（使用多表关联查询）
     */
    @RequestMapping("/boxes")
    public String list(Model model) {
        List<BoxDetail> boxes = boxService.getBoxDetails();
        model.addAttribute("boxes", boxes);
        return "box_list";
    }

    /**
     * 新增：跳转到新增储物格页面
     */
    @RequestMapping("/boxes/add")
    public String toAdd(Model model) {
        model.addAttribute("lockers", lockerService.getAllLockers());
        return "box_form";
    }

    /**
     * 新增/修改：保存储物格
     */
    @RequestMapping(value = "/boxes/save", method = RequestMethod.POST)
    public String save(Box box) {
        if (box.getId() == null) {
            // 新增
            boxService.createBox(box);
        } else {
            // 修改
            boxService.updateBox(box);
        }
        return "redirect:/boxes";
    }

    /**
     * 修改：跳转到编辑储物格页面
     */
    @RequestMapping("/boxes/edit/{id}")
    public String toEdit(@PathVariable Long id, Model model) {
        Box box = boxService.getBoxById(id);
        model.addAttribute("box", box);
        model.addAttribute("lockers", lockerService.getAllLockers());
        return "box_form";
    }

    /**
     * 删除：删除储物格
     */
    @RequestMapping("/boxes/delete/{id}")
    public String delete(@PathVariable Long id) {
        boxService.deleteBox(id);
        return "redirect:/boxes";
    }
}
