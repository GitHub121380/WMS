<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>
    <meta http-equiv="X-UA-Compatible" content="edge"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>出货管理</title>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
<div data-options="region:'center',border:true,title:'出货单列表'">
    <table id="dataGrid" data-options="fit:true,border:false"></table>
</div>
<script src="${path }/static/js/formatTime.js"></script>
<script>
    var dataGrid;
    $(function () {
        dataGrid = $('#dataGrid').datagrid({
            url: '${path }/shipment/dataGrid',
            fit: true,
            striped: true,
            rownumbers: true,
            pagination: true,
            singleSelect: true,
            height: '25',
            idField: 'id',
            sortName: 'shTime',
            sortOrder: 'asc',
            pageSize: 20,
            pageList: [10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
            columns: [[{
                width: '70',
                title: '出货单编号',
                field: 'shId',
                sortable: true
            }, {
                width: '80',
                title: '货主',
                field: 'shStoreid',
                sortable: true
            }, {
                width: '80',
                title: '实际出货时间',
                field: 'shTime',
                sortable: true,
                formatter: formatDatebox
            }, {
                width: '100',
                title: '号码',
                field: 'shPhone',
                sortable: true
            }, {
                width: '100',
                title: '客户托单号',
                field: 'shSippingno',
                sortable: true
            }, {
                width: '80',
                title: '仓库编码',
                field: 'shWhid',
                sortable: true
            }, {
                width: '60',
                title: '损坏数量',
                field: 'shDamage',
                sortable: true
            }, {
                width: '115',
                title: '损坏原因',
                field: 'shCause',
                sortable: true
            }, {
                width: '79',
                title: '型号',
                field: 'shSkumodel',
                sortable: true
            }, {
                width: '79',
                title: '实际出货数量',
                field: 'shShnum',
                sortable: true
            }, {
                width: '79',
                title: '发货毛重',
                field: 'shTotalweigh',
                sortable: true
            }, {
                width: '79',
                title: '发货体积',
                field: 'shTotalvolume',
                sortable: true
            }, {
                field: 'action',
                title: '操作',
                width: 130,
                formatter: function (value, row, index) {
                    var str = '';
                    <shiro:hasPermission name="/shipment/update">
                    str += $.formatString('<a href="javascript:void(0)" class="user-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\');" >编辑</a>', row.shId);
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/shipment/delete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="user-easyui-linkbutton-del" data-options="plain:true,iconCls:\'icon-del\'" onclick="deleteFun(\'{0}\');" >删除</a>', row.shId);
                    </shiro:hasPermission>
                    return str;
                }
            }]],
            onLoadSuccess: function (data) {
                $('.user-easyui-linkbutton-edit').linkbutton({text: '编辑', plain: true, iconCls: 'icon-edit'});
                $('.user-easyui-linkbutton-del').linkbutton({text: '删除', plain: true, iconCls: 'icon-del'});
            },
            toolbar: '#toolbar'
        });
    });

    <!-- \\\\\\\\\\ 删除操作 \\\\\\\\\\ -->
    function deleteFun(id) {
        if (id == undefined) {//点击右键菜单才会触发这个
            var rows = dataGrid.datagrid('getSelections');
            id = rows[0].id;
        } else {//点击操作里面的删除图标会触发这个
            dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
        }
        parent.$.messager.confirm('询问', '您是否要删除当前用户？', function (b) {
            if (b) {
                progressLoad();
                $.post('${path }/shipment/shipment/delete', {
                    id: id
                }, function (result) {
                    if (result.success) {
                        parent.$.messager.alert('提示', result.msg, 'info');
                        dataGrid.datagrid('reload');
                    }
                    progressClose();
                }, 'JSON');
            }
        });
    }

    <!-- \\\\\\\\\\ 编辑操作 \\\\\\\\\\ -->
    function editFun(id) {
        if (id == undefined) {
            var rows = dataGrid.datagrid('getSelections');
            id = rows[0].id;
        } else {
            dataGrid.datagrid('unselectAll').datagrid('uncheckAll');
        }
        parent.$.modalDialog({
            title: '编辑',
            width: 500,
            height: 390,
            href: '${path }/shipment/getEditPage?id=' + id,
            buttons: [{
                text: '确定',
                handler: function () {
                    parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#shipmentEditForm');
                    f.submit();
                }
            }]
        });
    }
</script>
</body>
</html>