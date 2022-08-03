<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Leave List</title>
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
	        title:'Sick Leave', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible: false,
	        fit: true,
	        method: "post",
	        url:"LeaveServlet?method=LeaveList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true,
	        pagination: true, 
	        rownumbers: true,
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50, sortable: true},    
 		       	{field:'studentID',title:'Student',width:200,
 		        	formatter: function(value,row,index){
 						if (row.studentId){
 							var studentList = $("#studentList").combobox("getData");
 							for(var i=0;i<studentList.length;i++ ){
 								//console.log(clazzList[i]);
 								if(row.studentId == studentList[i].id)return studentList[i].name;
 							}
 							return row.studentId;
 						} else {
 							return 'not found';
 						}
 					}	
 		       	},
 		       	{field:'info',title:'Reason',width:400},
 		        {field:'status',title:'Status',width:80,
 		       	formatter: function(value,row,index){
						switch(row.status){
							case 0:{
								return 'Pending';
							}
							case 1:{
								return 'Approved';
							}
							case -1:{
								return 'Rejected';
							}
						}
					}	
 		        },
 		        {field:'remark',title:'Remark',width:400},
	 		]], 
	        toolbar: "#toolbar",
	        onBeforeLoad : function(){
	        	try{
	        		$("#studentList").combobox("getData")
	        	}catch(err){
	        		preLoadClazz();
	        	}
	        }
	    }); 
		//Preload student data
	    function preLoadClazz(){
	  		$("#studentList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false,
		  		editable: false,
		  		method: "post",
		  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
		  		onChange: function(newValue, oldValue){
		  		}
		  	});
	  	}
		
	  //Set up pagination controls 
	    var p = $('#dataList').datagrid('getPager'); 
	    $(p).pagination({ 
	        pageSize: 10,
	        pageList: [10,20,30,50,100],
	        beforePageText: 'Page',
	        afterPageText: '    Total {pages} page', 
	        displayMsg: 'Current {from} - {to} item   Total {total} item',  
	    });
	   	
	    //Feature button
	    //Add
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	  //Edit
	    $("#edit").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("System alert", "Please select one item!", "warning");
            } else{
            	if(selectRows[0].status != 0){
            		$.messager.alert("System alert", "The information has been reviewed and cannot be modified!", "warning");
            		return;
            	}
		    	$("#editDialog").dialog("open");
            }
	    });
	  
	  //Review
	    $("#check").click(function(){
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("System alert", "Please select one item!", "warning");
            } else{
            	if(selectRows[0].status != 0){
            		$.messager.alert("System alert", "The information has been reviewed, please do not do it again!", "warning");
            		return;
            	}
		    	$("#checkDialog").dialog("open");
            }
	    });
	    
	  //Edit
	  	$("#editDialog").dialog({
	  		title: "Edit sick leave information",
	    	width: 450,
	    	height: 350,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Submit',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							var studentid = $("#edit_studentList").combobox("getValue");
							var id = $("#dataList").datagrid("getSelected").id;
							var info = $("#edit_info").textbox("getValue");
							var data = {id:id, studentid:studentid, info:info};
							
							$.ajax({
								type: "post",
								url: "LeaveServlet?method=EditLeave",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Edit successfully!","info");
										//Close window
										$("#editDialog").dialog("close");
										//Clear window
										$("#edit_info").textbox('setValue',"");
										
										//Reload
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
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
						$("#edit_info").val("");
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//Setting value
				$("#edit_info").textbox('setValue',selectRow.info);
				var studentId = selectRow.studentId;
				setTimeout(function(){
					$("#edit_studentList").combobox('setValue', studentId);
				}, 100);
			},
			onClose: function(){
				$("#edit_info").val("");
			}
	    });
	  
	  
	  //Review window
	  	$("#checkDialog").dialog({
	  		title: "Review sick leave information",
	    	width: 450,
	    	height: 350,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Submit',
					plain: true,
					iconCls:'icon-add',
					handler:function(){
						var validate = $("#checkForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							
							var studentid = $("#dataList").datagrid("getSelected").studentId;
							var id = $("#dataList").datagrid("getSelected").id;
							var info = $("#dataList").datagrid("getSelected").info;
							var remark = $("#check_remark").textbox("getValue");
							var status = $("#check_statusList").combobox("getValue");
							var data = {id:id, studentid:studentid, info:info,remark:remark,status:status};
							
							$.ajax({
								type: "post",
								url: "LeaveServlet?method=CheckLeave",
								data: data,
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Review successfully!","info");
										//Close
										$("#checkDialog").dialog("close");
										//Clear
										$("#check_remark").textbox('setValue',"");
										
										//Reload
							  			$('#dataList').datagrid("reload");
							  			$('#dataList').datagrid("uncheckAll");
										
									} else{
										$.messager.alert("System alert","Review failed!","warning");
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
						$("#check_remark").val("");
						$("#check_statusList").combox('clear');
					}
				},
			],
			onBeforeOpen: function(){
				/*
				var selectRow = $("#dataList").datagrid("getSelected");
				//设置值
				$("#edit_info").textbox('setValue',selectRow.info);
				//$("#edit-id").val(selectRow.id);
				var studentId = selectRow.studentId;
				setTimeout(function(){
					$("#edit_studentList").combobox('setValue', studentId);
				}, 100);*/
			},
			onClose: function(){
				$("#edit_info").val("");
			}
	    });
	    
	    //Delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("System alert", "Please select an item to delete!", "warning");
            } else{
            	$.messager.confirm("System alert", "Confirm to continue", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "LeaveServlet?method=DeleteLeave",
							data: {id: selectRow.id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("System alert","Deleted successfully!","info");
									//Reload
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
	  	
	  	//Add window
	    $("#addDialog").dialog({
	    	title: "Add new sick leave",
	    	width: 450,
	    	height: 350,
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
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#addForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "LeaveServlet?method=AddLeave",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Added successfully!","info");
										//Close
										$("#addDialog").dialog("close");
										//Clear
										//$("#add_name").textbox('setValue', "");
										//Reload
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
					text:'Resey',
					plain: true,
					iconCls:'icon-book-reset',
					handler:function(){
						$("#add_name").textbox('setValue', "");
					}
				},
			]
	    });
	  	
	  	//Drop-down box
	  	$("#add_studentList, #edit_studentList,#studentList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	//Add
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  //Edit
	    $("#edit_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	    //Search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentid: $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue')
	  		});
	  	});
	    
	    //Clear
	  	$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$("#studentList").combobox('clear');
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
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<c:if test="${userType == 2}">
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		</c:if>
		<c:if test="${userType == 1 || userType == 3}">
		<div style="float: left;"><a id="check" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Review</a></div>
		</c:if>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="margin-top: 3px;">
			Student：<input id="studentList" class="easyui-textbox" name="studentid" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Clear</a>
		</div>
	</div>
	
	<!-- Add window -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:60px">Student:</td>
	    			<td colspan="3">
	    				<input id="add_studentList" style="width: 300px; height: 30px;" class="easyui-textbox" name="studentid" data-options="required:true, missingMessage:'Please select a student!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Reason:</td>
	    			<td>
	    				<textarea id="info" name="info" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true,required:true, missingMessage:'Cannot empty'" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Edit window -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:60px">Student:</td>
	    			<td colspan="3">
	    				<input id="edit_studentList" style="width: 300px; height: 30px;" class="easyui-textbox" name="studentid" data-options="required:true, missingMessage:'Please select a student!'" />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Reason:</td>
	    			<td>
	    				<textarea id="edit_info" name="info" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true,required:true, missingMessage:'Cannot empty'" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Review window -->
	<div id="checkDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:60px">Student:</td>
	    			<td colspan="3">
	    				<select id="check_statusList" style="width: 300px; height: 30px;" class="easyui-combobox" name="status" data-options="required:true, missingMessage:'Please select status'" >
	    					<option value="1">Review approved</option>
	    					<option value="-1">Review rejected</option>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td>Review info:</td>
	    			<td>
	    				<textarea id="check_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
</body>
</html>