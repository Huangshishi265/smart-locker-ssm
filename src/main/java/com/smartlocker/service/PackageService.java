package com.smartlocker.service;

import com.smartlocker.dto.PackageDetail;
import com.smartlocker.entity.Package;

import java.util.List;

/**
 * 快递Service接口
 */
public interface PackageService {

    /**
     * 查询所有快递
     */
    List<Package> getAllPackages();

    /**
     * 查询快递详细信息（多表关联）
     */
    List<PackageDetail> getPackageDetails();

    /**
     * 根据ID查询快递
     */
    Package getPackageById(Long id);

    /**
     * 创建快递（自动分配储物格）
     */
    void createPackage(Package pkg);

    /**
     * 更新快递
     */
    void updatePackage(Package pkg);

    /**
     * 删除快递
     */
    void deletePackage(Long id);

    /**
     * 取件
     */
    void takePackage(Long id);
}
