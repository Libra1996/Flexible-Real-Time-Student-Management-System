<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Major List</title>
	<link rel="stylesheet" type="text/css" href="easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="easyui/css/demo.css">
	<script type="text/javascript" src="easyui/jquery.min.js"></script>
	<script type="text/javascript" src="easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="easyui/js/validateExtends.js"></script>
	<script type="text/javascript">
	$(function() {	
		//datagrid initialization
	    $('#dataList').datagrid({ 
	        title:'Major List', 
	        iconCls:'icon-more',
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"ClazzServlet?method=getClazzList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,
	        pagination: true,
	        rownumbers: true,
	        sortName: 'id',
	        sortOrder: 'ASC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		        {field:'name',title:'Major name',width:200},
 		        {field:'info',title:'Information',width:750, 
 		        },
	 		]], 
	        toolbar: "#toolbar"
	    }); 
	  	//Set up pagination controls 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,//The number of item displayed per page. (Default: 10)
	        pageList: [10,20,30,50,100],//Change page size
	        beforePageText: 'Page',
	        afterPageText: '    Total {pages} page', 
	        displayMsg: 'Current {from} - {to} item   Total {total} item', 
	    });
	    //Feature Button
	    //Add
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    //Delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("System alert", "Please pick one item to delete!", "warning");
            } else{
            	var clazzid = selectRow.id;
            	$.messager.confirm("System alert", "The class information will be deleted (it cannot be deleted if there are students or teachers under the class), are you sure to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "ClazzServlet?method=DeleteClazz",
							data: {clazzid: clazzid},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("System alert","Deleted successfully!","info");
									//Reload datagrid
									$("#dataList").datagrid("reload");
								} else{
									$.messager.alert("System alert","Delete failed!","warning");
									return;
								}
							}
						});
            		}
            	});
            }
	    });
	    
	    
	  	
	  	//Add new class window
	    $("#addDialog").dialog({
	    	title: "Add new class",
	    	width: 500,
	    	height: 400,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Add',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "ClazzServlet?method=AddClazz",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Add successfully!","info");
										//Close window
										$("#addDialog").dialog("close");
										//Clear window
										$("#add_name").textbox('setValue', "");
										$("#info").val("");
										//Reload datagrid
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("System alert","Add failed!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#add_name").textbox('setValue', "");
						//Reload class
						$("#info").val("");
					}
				},
			]
	    });
	  	
	  	
	  	//Search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			clazzName: $('#clazzName').val()
	  		});
	  	});
	  	
	  //Edit button
	  	$("#edit-btn").click(function(){
	  		var selectRow = $("#dataList").datagrid("getSelected");
	    	//console.log(selectRow);
        	if(selectRow == null){
            	$.messager.alert("System alert", "Please select one item to edit!", "warning");
            	return;
            }
        	$("#editDialog").dialog("open");
	  	});
	  
	  //Edit window
	    $("#editDialog").dialog({
	    	title: "Edit class",
	    	width: 500,
	    	height: 400,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Save changes',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							//var gradeid = $("#add_gradeList").combobox("getValue");
							$.ajax({
								type: "post",
								url: "ClazzServlet?method=EditClazz",
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","EDit successfully!","info");
										//CLose window
										$("#editDialog").dialog("close");
										//Clear window
										$("#edit_name").textbox('setValue', "");
										$("#edit_info").val("");
										//Reload datagrid
							  			$('#dataList').datagrid("reload");
										
									} else{
										$.messager.alert("System alert","Edit failed!","warning");
										return;
									}
								}
							});
						}
					}
				},
				{
					text:'Reset',
					plain: true,
					iconCls:'icon-reload',
					handler:function(){
						$("#edit_name").textbox('setValue', "");
						//Reload Class
						$("#edit_info").val("");
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//Setting value
				$("#edit_name").textbox('setValue', selectRow.name);
				$("#edit_info").val(selectRow.info);
				$("#edit-id").val(selectRow.id);
			}
	    });
	  
	});
	</script>
</head>
<body>
	<!-- Data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	</table> 
	
	<!-- Menu Tab -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left; margin-right: 10px;"><a id="edit-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="margin-top: 3px;">Major：<input id="clazzName" class="easyui-textbox" name="clazzName" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
		</div>
	</div>
	
	<!-- Add window -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Major:</td>
	    			<td><input id="add_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name"  data-options="required:true, missingMessage:'Cannot empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Detail:</td>
	    			<td>
	    				<textarea id="info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Edit window -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
    	<input type="hidden" id="edit-id" name="id">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Major:</td>
	    			<td><input id="edit_name" style="width: 200px; height: 30px;" class="easyui-textbox" type="text" name="name"  data-options="required:true, missingMessage:'Cannot empty'" /></td>
	    		</tr>
	    		<tr>
	    			<td>Detail:</td>
	    			<td>
	    				<textarea id="edit_info" name="info" style="width: 200px; height: 60px;" class="" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>