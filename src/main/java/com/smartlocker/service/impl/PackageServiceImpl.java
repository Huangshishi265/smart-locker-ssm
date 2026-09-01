package com.smartlocker.service.impl;

import com.smartlocker.dao.BoxDao;
import com.smartlocker.dao.PackageDao;
import com.smartlocker.dto.PackageDetail;
import com.smartlocker.entity.Box;
import com.smartlocker.entity.Package;
import com.smartlocker.exception.BusinessException;
import com.smartlocker.service.PackageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 快递Service实现类
 * 包含完整的CRUD功能
 */
@Service
public class PackageServiceImpl implements PackageService {

    @Autowired
    private PackageDao packageDao;

    @Autowired
    private BoxDao boxDao;

    @Override
    public List<Package> getAllPackages() {
        return packageDao.selectAll();
    }

    @Override
    public List<PackageDetail> getPackageDetails() {
        // 多表关联查询：t_package, t_locker, t_box
        return packageDao.selectPackageDetails();
    }

    @Override
    public Package getPackageById(Long id) {
        if (id == null) {
            throw new BusinessException("快递ID不能为空");
        }
        Package pkg = packageDao.selectById(id);
        if (pkg == null) {
            throw new BusinessException("快递不存在");
        }
        return pkg;
    }

    @Override
    @Transactional
    public void createPackage(Package pkg) {
        // 业务逻辑验证
        if (pkg == null) {
            throw new BusinessException("快递信息不能为空");
        }
        if (pkg.getPackageNo() == null || pkg.getPackageNo().trim().isEmpty()) {
            throw new BusinessException("快递单号不能为空");
        }
        if (pkg.getSenderName() == null || pkg.getSenderName().trim().isEmpty()) {
            throw new BusinessException("寄件人姓名不能为空");
        }

        // 检查快递单号是否已存在
        Package existPackage = packageDao.selectByPackageNo(pkg.getPackageNo());
        if (existPackage != null) {
            throw new BusinessException("快递单号已存在");
        }

        Box box = null;

        // 如果用户已经选择了储物格，使用用户选择的储物格
        if (pkg.getBoxId() != null) {
            box = boxDao.selectById(pkg.getBoxId());
            if (box == null) {
                throw new BusinessException("选择的储物格不存在");
            }
            if (box.getStatus() != 1) {
                throw new BusinessException("选择的储物格不可用，请选择空闲状态的储物格");
            }
        } else {
            // 如果用户没有选择储物格，自动分配储物格（默认分配中型储物格）
            List<Box> availableBoxes = boxDao.selectAvailableByLockerIdAndSize(pkg.getLockerId(), "MEDIUM");
            if (availableBoxes == null || availableBoxes.isEmpty()) {
                throw new BusinessException("没有可用的储物格，请先添加储物格或选择一个储物格");
            }
            box = availableBoxes.get(0);
        }

        // 设置储物格ID
        pkg.setBoxId(box.getId());

        // 更新储物格状态为占用
        box.setStatus(2);
        boxDao.update(box);

        // 设置默认状态和存入时间
        if (pkg.getStatus() == null) {
            pkg.setStatus(1); // 1-待取件
        }
        if (pkg.getPutInTime() == null) {
            pkg.setPutInTime(new Date());
        }

        // 调用DAO层插入快递
        packageDao.insert(pkg);
    }

    @Override
    @Transactional
    public void updatePackage(Package pkg) {
        // 业务逻辑验证
        if (pkg == null || pkg.getId() == null) {
            throw new BusinessException("快递ID不能为空");
        }

        // 检查快递是否存在
        Package existPackage = packageDao.selectById(pkg.getId());
        if (existPackage == null) {
            throw new BusinessException("快递不存在");
        }

        // 如果修改快递单号，检查是否已存在
        if (pkg.getPackageNo() != null && !pkg.getPackageNo().equals(existPackage.getPackageNo())) {
            Package duplicatePackage = packageDao.selectByPackageNo(pkg.getPackageNo());
            if (duplicatePackage != null) {
                throw new BusinessException("快递单号已存在");
            }
        }

        // 调用DAO层更新快递
        packageDao.update(pkg);
    }

    @Override
    @Transactional
    public void deletePackage(Long id) {
        // 业务逻辑验证
        if (id == null) {
            throw new BusinessException("快递ID不能为空");
        }

        // 检查快递是否存在
        Package pkg = packageDao.selectById(id);
        if (pkg == null) {
            throw new BusinessException("快递不存在");
        }

        // 释放储物格（如果快递状态为待取件）
        if (pkg.getStatus() == 1) {
            Box box = boxDao.selectById(pkg.getBoxId());
            if (box != null) {
                box.setStatus(1); // 设置为空闲
                boxDao.update(box);
            }
        }

        // 调用DAO层删除快递
        packageDao.deleteById(id);
    }

    @Override
    @Transactional
    public void takePackage(Long id) {
        // 业务逻辑验证
        if (id == null) {
            throw new BusinessException("快递ID不能为空");
        }

        // 检查快递是否存在
        Package pkg = packageDao.selectById(id);
        if (pkg == null) {
            throw new BusinessException("快递不存在");
        }

        // 检查快递状态
        if (pkg.getStatus() != 1) {
            throw new BusinessException("快递状态不正确，无法取件");
        }

        // 更新快递状态为已取件
        pkg.setStatus(2); // 2-已取件
        pkg.setTakeOutTime(new Date());
        packageDao.update(pkg);

        // 释放储物格
        Box box = boxDao.selectById(pkg.getBoxId());
        if (box != null) {
            box.setStatus(1); // 设置为空闲
            boxDao.update(box);
        }
    }
}