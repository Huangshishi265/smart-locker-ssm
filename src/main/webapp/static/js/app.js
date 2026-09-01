// 快递编辑相关
function editPackage(id) {
    // 这里应该调用后端API获取快递详情
    // 暂时使用alert提示
    alert('编辑快递ID: ' + id + '\n（此功能需要实现对应的Controller）');

    // 显示模态框
    document.getElementById('packageModal').style.display = 'block';
    document.getElementById('packageId').value = id;
}

function savePackage() {
    // 获取表单数据
    const packageId = document.getElementById('packageId').value;
    const packageNo = document.getElementById('packageNo').value;
    const senderName = document.getElementById('senderName').value;
    const senderPhone = document.getElementById('senderPhone').value;
    const receiverName = document.getElementById('receiverName').value;
    const receiverPhone = document.getElementById('receiverPhone').value;
    const status = document.getElementById('packageStatus').value;

    // 表单验证
    if (!packageNo || !senderName || !senderPhone || !receiverName || !receiverPhone) {
        alert('请填写所有必填字段！');
        return;
    }

    // 构建请求URL
    const url = packageId ? '/packages/update/' + packageId : '/packages/add';

    // 发送AJAX请求
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            packageNo: packageNo,
            senderName: senderName,
            senderPhone: senderPhone,
            receiverName: receiverName,
            receiverPhone: receiverPhone,
            status: status
        })
    })
    .then(response => response.text())
    .then(data => {
        alert('保存成功！');
        closeModal('packageModal');
        location.reload();
    })
    .catch(error => {
        console.error('Error:', error);
        alert('保存失败！');
    });
}

function deletePackage(id) {
    if (confirm('确定要删除该快递吗？')) {
        // 发送删除请求
        fetch('/packages/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.text())
        .then(data => {
            alert('删除成功！');
            location.reload();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('删除失败！');
        });
    }
}

// 储物格编辑相关
function editBox(id) {
    alert('编辑储物格ID: ' + id + '\n（此功能需要实现对应的Controller）');

    // 显示模态框
    document.getElementById('boxModal').style.display = 'block';
    document.getElementById('boxId').value = id;
}

function saveBox() {
    // 获取表单数据
    const boxId = document.getElementById('boxId').value;
    const boxNumber = document.getElementById('boxNumber').value;
    const boxSize = document.getElementById('boxSize').value;
    const status = document.getElementById('boxStatus').value;

    // 表单验证
    if (!boxNumber) {
        alert('请填写储物格编号！');
        return;
    }

    // 构建请求URL
    const url = boxId ? '/boxes/update/' + boxId : '/boxes/add';

    // 发送AJAX请求
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            boxNumber: boxNumber,
            boxSize: boxSize,
            status: status
        })
    })
    .then(response => response.text())
    .then(data => {
        alert('保存成功！');
        closeModal('boxModal');
        location.reload();
    })
    .catch(error => {
        console.error('Error:', error);
        alert('保存失败！');
    });
}

function deleteBox(id) {
    if (confirm('确定要删除该储物格吗？')) {
        // 发送删除请求
        fetch('/boxes/delete/' + id, {
            method: 'POST'
        })
        .then(response => response.text())
        .then(data => {
            alert('删除成功！');
            location.reload();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('删除失败！');
        });
    }
}

// 模态框相关
function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
}

// 点击模态框外部关闭
window.onclick = function(event) {
    if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
    }
}

// 页面导航
document.querySelectorAll('.sidebar .nav a').forEach(function(link) {
    link.addEventListener('click', function(e) {
        e.preventDefault();

        // 移除所有active类
        document.querySelectorAll('.sidebar .nav li').forEach(function(li) {
            li.classList.remove('active');
        });

        // 添加active类到当前项
        this.parentElement.classList.add('active');
    });
});
