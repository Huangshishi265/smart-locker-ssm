package com.smartlocker.service.impl;

import com.smartlocker.dao.LockerBoxDao;
import com.smartlocker.entity.LockerBox;
import com.smartlocker.exception.BusinessException;
import com.smartlocker.service.LockerBoxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 快递柜柜格Service实现类
 */
@Service
public class LockerBoxServiceImpl implements LockerBoxService {

    @Autowired
    private LockerBoxDao lockerBoxDao;

    @Override
    public List<LockerBox> getBoxesByLockerId(Long lockerId) {
        if (lockerId == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        return lockerBoxDao.selectByLockerId(lockerId);
    }

    @Override
    public LockerBox getBoxById(Long id) {
        if (id == null) {
            throw new BusinessException("柜格ID不能为空");
        }
        return lockerBoxDao.selectById(id);
    }

    @Override
    public List<LockerBox> getAvailableBoxes(Long lockerId, Integer boxSize) {
        if (lockerId == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        return lockerBoxDao.selectAvailableBoxes(lockerId, boxSize);
    }

    /**
     * 智能柜格分配策略
     * 策略：优先分配相同大小的柜格，如果没有则选择更大的柜格
     */
    @Override
    @Transactional
    public LockerBox allocateBox(Long lockerId, Integer boxSize) {
        if (lockerId == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        if (boxSize == null || boxSize < 1 || boxSize > 3) {
            throw new BusinessException("柜格大小参数无效");
        }

        // 1. 首先尝试分配相同大小的柜格
        List<LockerBox> sameSizeBoxes = lockerBoxDao.selectAvailableBoxes(lockerId, boxSize);
        if (sameSizeBoxes != null && !sameSizeBoxes.isEmpty()) {
            LockerBox box = sameSizeBoxes.get(0); // 取第一个可用的
            // 更新柜格状态为占用
            lockerBoxDao.updateStatus(box.getId(), 1, null);
            return box;
        }

        // 2. 如果没有相同大小的，尝试分配更大的柜格
        if (boxSize < 3) {
            for (int size = boxSize + 1; size <= 3; size++) {
                List<LockerBox> largerBoxes = lockerBoxDao.selectAvailableBoxes(lockerId, size);
                if (largerBoxes != null && !largerBoxes.isEmpty()) {
                    LockerBox box = largerBoxes.get(0);
                    lockerBoxDao.updateStatus(box.getId(), 1, null);
                    return box;
                }
            }
        }

        throw new BusinessException("没有可用的柜格，请选择其他快递柜");
    }

    @Override
    @Transactional
    public void releaseBox(Long boxId) {
        if (boxId == null) {
            throw new BusinessException("柜格ID不能为空");
        }

        LockerBox box = lockerBoxDao.selectById(boxId);
        if (box == null) {
            throw new BusinessException("柜格不存在");
        }

        // 更新柜格状态为空闲，清空关联的快递ID
        lockerBoxDao.updateStatus(boxId, 0, null);
    }

    @Override
    @Transactional
    public void createBox(LockerBox lockerBox) {
        if (lockerBox == null) {
            throw new BusinessException("柜格信息不能为空");
        }
        if (lockerBox.getLockerId() == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        if (lockerBox.getBoxCode() == null || lockerBox.getBoxCode().trim().isEmpty()) {
            throw new BusinessException("柜格编号不能为空");
        }

        // 设置默认状态为空闲
        if (lockerBox.getStatus() == null) {
            lockerBox.setStatus(0);
        }

        lockerBoxDao.insert(lockerBox);
    }

    @Override
    @Transactional
    public void batchCreateBoxes(Long lockerId, Integer smallCount, Integer mediumCount, Integer largeCount) {
        if (lockerId == null) {
            throw new BusinessException("快递柜ID不能为空");
        }

        // 生成柜格编号序列：A1, A2, B1, B2, C1, C2...
        int total = smallCount + mediumCount + largeCount;
        int index = 1;
        char row = 'A';

        List<LockerBox> boxes = new java.util.ArrayList<>();

        // 创建小柜格
        for (int i = 0; i < smallCount; i++) {
            String boxCode = String.valueOf(row) + index;
            LockerBox box = new LockerBox();
            box.setLockerId(lockerId);
            box.setBoxCode(boxCode);
            box.setBoxSize(1); // 小
            box.setStatus(0); // 空闲
            boxes.add(box);
            index++;
            if (index > 9) {
                index = 1;
                row++;
            }
        }

        // 创建中柜格
        row = 'A';
        index = smallCount + 1;
        for (int i = 0; i < mediumCount; i++) {
            String boxCode = String.valueOf(row) + index;
            LockerBox box = new LockerBox();
            box.setLockerId(lockerId);
            box.setBoxCode(boxCode);
            box.setBoxSize(2); // 中
            box.setStatus(0); // 空闲
            boxes.add(box);
            index++;
            if (index > 9) {
                index = 1;
                row++;
            }
        }

        // 创建大柜格
        row = 'A';
        index = smallCount + mediumCount + 1;
        for (int i = 0; i < largeCount; i++) {
            String boxCode = String.valueOf(row) + index;
            LockerBox box = new LockerBox();
            box.setLockerId(lockerId);
            box.setBoxCode(boxCode);
            box.setBoxSize(3); // 大
            box.setStatus(0); // 空闲
            boxes.add(box);
            index++;
            if (index > 9) {
                index = 1;
                row++;
            }
        }

        // 批量插入
        lockerBoxDao.batchInsert(boxes);
    }

    @Override
    @Transactional
    public void deleteBox(Long id) {
        if (id == null) {
            throw new BusinessException("柜格ID不能为空");
        }

        LockerBox box = lockerBoxDao.selectById(id);
        if (box == null) {
            throw new BusinessException("柜格不存在");
        }

        // 如果柜格被占用，不允许删除
        if (box.getStatus() != null && box.getStatus() == 1) {
            throw new BusinessException("柜格被占用，无法删除");
        }

        lockerBoxDao.deleteById(id);
    }

    @Override
    @Transactional
    public void deleteBoxesByLockerId(Long lockerId) {
        if (lockerId == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        lockerBoxDao.deleteByLockerId(lockerId);
    }
}