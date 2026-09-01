package com.smartlocker.dao;

import com.smartlocker.dto.PackageDetail;
import com.smartlocker.entity.Package;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 快递DAO接口
 */
public interface PackageDao {

    /**
     * 查询所有快递
     */
    List<Package> selectAll();

    /**
     * 根据ID查询快递
     */
    Package selectById(@Param("id") Long id);

    /**
     * 根据快递单号查询快递
     */
    Package selectByPackageNo(@Param("packageNo") String packageNo);

    /**
     * 根据收件人ID查询快递
     */
    List<Package> selectByReceiverId(@Param("receiverId") Long receiverId);

    /**
     * 插入快递
     */
    int insert(Package pkg);

    /**
     * 更新快递
     */
    int update(Package pkg);

    /**
     * 删除快递
     */
    int deleteById(@Param("id") Long id);

    /**
     * 查询快递详细信息（多表关联查询：t_package, t_locker, t_box）
     */
    List<PackageDetail> selectPackageDetails();

    /**
     * 根据ID查询快递详细信息
     */
    PackageDetail selectPackageDetailById(@Param("id") Long id);
}
