package com.smartlocker.service.impl;

import com.smartlocker.dao.BoxDao;
import com.smartlocker.dao.LockerDao;
import com.smartlocker.entity.Box;
import com.smartlocker.entity.Locker;
import com.smartlocker.exception.BusinessException;
import com.smartlocker.service.LockerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 快递柜Service实现类
 */
@Service
public class LockerServiceImpl implements LockerService {

    @Autowired
    private LockerDao lockerDao;

    @Autowired
    private BoxDao boxDao;

    @Override
    public List<Locker> getAllLockers() {
        return lockerDao.selectAll();
    }

    @Override
    public List<Locker> getLockersByCondition(String lockerName, String location,
                                              Integer status, Integer lockerStatus, Integer repairStatus) {
        return lockerDao.selectByCondition(lockerName, location, status, lockerStatus, repairStatus);
    }

    @Override
    public Locker getLockerById(Long id) {
        if (id == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        Locker locker = lockerDao.selectById(id);
        if (locker == null) {
            throw new BusinessException("快递柜不存在");
        }

        return locker;
    }

    @Override
    public List<Box> getLockerBoxes(Long lockerId) {
        return boxDao.selectByLockerId(lockerId);
    }

    @Override
    public Map<String, Object> getBoxStats(Long lockerId) {
        return boxDao.selectBoxStats(lockerId);
    }

    @Override
    @Transactional
    public void createLocker(Locker locker) {
        createLocker(locker, 0, 0, 0);
    }

    @Override
    @Transactional
    public void createLocker(Locker locker, Integer smallCount, Integer mediumCount, Integer largeCount) {
        if (locker == null) {
            throw new BusinessException("快递柜信息不能为空");
        }
        if (locker.getLockerName() == null || locker.getLockerName().trim().isEmpty()) {
            throw new BusinessException("快递柜名称不能为空");
        }

        // 设置默认状态
        if (locker.getStatus() == null) {
            locker.setStatus(1);
        }
        if (locker.getRepairStatus() == null) {
            locker.setRepairStatus(0);
        }

        // 插入快递柜
        lockerDao.insert(locker);

        // 初始化柜格（小/中/大），柜格编号 A1.. / B1.. / C1..
        int s = smallCount == null ? 0 : smallCount;
        int m = mediumCount == null ? 0 : mediumCount;
        int l = largeCount == null ? 0 : largeCount;

        for (int i = 1; i <= s; i++) {
            boxDao.insert(buildBox(locker.getId(), "A" + i, "SMALL"));
        }
        for (int i = 1; i <= m; i++) {
            boxDao.insert(buildBox(locker.getId(), "B" + i, "MEDIUM"));
        }
        for (int i = 1; i <= l; i++) {
            boxDao.insert(buildBox(locker.getId(), "C" + i, "LARGE"));
        }
    }

    private Box buildBox(Long lockerId, String boxNumber, String boxSize) {
        Box box = new Box();
        box.setLockerId(lockerId);
        box.setBoxNumber(boxNumber);
        box.setBoxSize(boxSize);
        box.setStatus(1); // 空闲
        return box;
    }

    @Override
    @Transactional
    public void updateLocker(Locker locker) {
        if (locker == null || locker.getId() == null) {
            throw new BusinessException("快递柜ID不能为空");
        }

        Locker existLocker = lockerDao.selectById(locker.getId());
        if (existLocker == null) {
            throw new BusinessException("快递柜不存在");
        }

        // 更新快递柜信息
        lockerDao.update(locker);
    }

    @Override
    @Transactional
    public void updateLockerStatus(Long id, Integer status) {
        if (id == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        if (status == null || (status != 0 && status != 1)) {
            throw new BusinessException("状态参数无效");
        }

        Locker locker = lockerDao.selectById(id);
        if (locker == null) {
            throw new BusinessException("快递柜不存在");
        }

        lockerDao.updateStatus(id, status);
    }

    @Override
    @Transactional
    public void deleteLocker(Long id) {
        if (id == null) {
            throw new BusinessException("快递柜ID不能为空");
        }

        Locker locker = lockerDao.selectById(id);
        if (locker == null) {
            throw new BusinessException("快递柜不存在");
        }

        // 删除快递柜
        lockerDao.deleteById(id);
    }

    @Override
    @Transactional
    public void submitRepair(Long id, String repairDesc, Long operatorId) {
        if (id == null) {
            throw new BusinessException("快递柜ID不能为空");
        }

        Locker locker = lockerDao.selectById(id);
        if (locker == null) {
            throw new BusinessException("快递柜不存在");
        }

        locker.setRepairStatus(1);   // 待维修
        locker.setRepairDesc(repairDesc);
        locker.setRepairTime(new Date());
        locker.setOperatorId(operatorId);
        lockerDao.update(locker);
    }

    @Override
    @Transactional
    public void completeRepair(Long id, Long operatorId) {
        if (id == null) {
            throw new BusinessException("快递柜ID不能为空");
        }

        Locker locker = lockerDao.selectById(id);
        if (locker == null) {
            throw new BusinessException("快递柜不存在");
        }

        locker.setRepairStatus(3);   // 已维修
        locker.setRepairTime(new Date());
        locker.setOperatorId(operatorId);
        lockerDao.update(locker);
    }

    @Override
    public List<Locker> getBrokenLockers() {
        return lockerDao.selectBroken();
    }

    @Override
    public Map<String, Integer> getLockerStats() {
        Map<String, Integer> stats = new HashMap<>();

        stats.put("totalCount", lockerDao.countByStatus(null));
        stats.put("normalCount", lockerDao.countByStatus(1));
        stats.put("disabledCount", lockerDao.countByStatus(0));

        return stats;
    }
}
