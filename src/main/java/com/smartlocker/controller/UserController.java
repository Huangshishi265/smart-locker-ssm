package com.smartlocker.controller;

import com.smartlocker.entity.User;
import com.smartlocker.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * 用户控制器
 * 体现三层架构：Controller调用Service
 * 包含完整的CRUD操作
 */
@Controller
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 用户注册页面
     */
    @RequestMapping("/register")
    public String toRegister() {
        return "user_register";
    }

    /**
     * 查询：查询所有用户
     */
    @RequestMapping(method = RequestMethod.GET)
    public String list(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "user_list";
    }

    /**
     * 查询：根据ID查询用户
     */
    @RequestMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "user_detail";
    }

    /**
     * 新增：跳转到新增用户页面
     */
    @RequestMapping("/add")
    public String toAdd() {
        return "user_form";
    }

    /**
     * 新增：创建用户
     */
    @RequestMapping(method = RequestMethod.POST)
    public String add(User user, @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                      HttpServletRequest request) {
        try {
            // 处理头像上传
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String avatarPath = handleAvatarUpload(avatarFile, request);
                user.setAvatar(avatarPath);
            }

            userService.createUser(user);
        } catch (IOException e) {
            e.printStackTrace();
            // 文件上传失败，但用户信息仍然保存
            userService.createUser(user);
        }
        return "redirect:/users";
    }

    /**
     * 修改：跳转到编辑用户页面
     */
    @RequestMapping("/edit/{id}")
    public String toEdit(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "user_form";
    }

    /**
     * 修改：更新用户
     */
    @RequestMapping(value = "/update/{id}", method = RequestMethod.POST)
    public String update(@PathVariable Long id, User user,
                         @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                         @RequestParam(value = "existingAvatar", required = false) String existingAvatar,
                         HttpServletRequest request) {
        try {
            // 处理头像上传
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String avatarPath = handleAvatarUpload(avatarFile, request);
                user.setAvatar(avatarPath);
            } else {
                // 没有上传新头像，保持原头像
                user.setAvatar(existingAvatar);
            }

            user.setId(id);
            userService.updateUser(user);
        } catch (IOException e) {
            e.printStackTrace();
            // 文件上传失败，但用户信息仍然更新
            user.setAvatar(existingAvatar);
            user.setId(id);
            userService.updateUser(user);
        }
        return "redirect:/users";
    }

    /**
     * 删除：删除用户
     */
    @RequestMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        userService.deleteUser(id);
        return "redirect:/users";
    }

    /**
     * 处理头像上传
     */
    private String handleAvatarUpload(MultipartFile file, HttpServletRequest request) throws IOException {
        // 获取上传目录的绝对路径
        String uploadPath = request.getServletContext().getRealPath("/static/uploads/avatars/");

        // 如果目录不存在，创建目录
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 生成唯一的文件名
        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String newFilename = UUID.randomUUID().toString() + fileExtension;

        // 保存文件
        File targetFile = new File(uploadPath + File.separator + newFilename);
        file.transferTo(targetFile);

        // 返回相对路径
        return "/static/uploads/avatars/" + newFilename;
    }
}