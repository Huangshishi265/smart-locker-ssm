package com.smartlocker.service.impl;

import com.smartlocker.dao.BoxDao;
import com.smartlocker.dto.BoxDetail;
import com.smartlocker.entity.Box;
import com.smartlocker.exception.BusinessException;
import com.smartlocker.service.BoxService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 储物格Service实现类
 */
@Service
public class BoxServiceImpl implements BoxService {

    @Autowired
    private BoxDao boxDao;

    @Override
    public List<Box> getAllBoxes() {
        return boxDao.selectAll();
    }

    @Override
    public List<BoxDetail> getBoxDetails() {
        return boxDao.selectBoxDetails();
    }

    @Override
    public List<BoxDetail> getAvailableBoxes() {
        return boxDao.selectAvailableBoxes();
    }

    @Override
    public Box getBoxById(Long id) {
        if (id == null) {
            throw new BusinessException("储物格ID不能为空");
        }
        Box box = boxDao.selectById(id);
        if (box == null) {
            throw new BusinessException("储物格不存在");
        }
        return box;
    }

    @Override
    @Transactional
    public void createBox(Box box) {
        if (box == null) {
            throw new BusinessException("储物格信息不能为空");
        }
        if (box.getLockerId() == null) {
            throw new BusinessException("快递柜ID不能为空");
        }
        if (box.getBoxNumber() == null || box.getBoxNumber().trim().isEmpty()) {
            throw new BusinessException("储物格编号不能为空");
        }

        // 设置默认状态
        if (box.getStatus() == null) {
            box.setStatus(1);
        }

        boxDao.insert(box);
    }

    @Override
    @Transactional
    public void updateBox(Box box) {
        if (box == null || box.getId() == null) {
            throw new BusinessException("储物格ID不能为空");
        }

        Box existBox = boxDao.selectById(box.getId());
        if (existBox == null) {
            throw new BusinessException("储物格不存在");
        }

        boxDao.update(box);
    }

    @Override
    @Transactional
    public void deleteBox(Long id) {
        if (id == null) {
            throw new BusinessException("储物格ID不能为空");
        }

        Box box = boxDao.selectById(id);
        if (box == null) {
            throw new BusinessException("储物格不存在");
        }

        boxDao.deleteById(id);
    }
}