<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Score List</title>
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
	        title:'Score List', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible: false, 
	        fit: true, 
	        method: "post",
	        url:"ScoreServlet?method=ScoreList&t="+new Date().getTime(),
	        idField:'id', 
	        singleSelect: true, 
	        pagination: true, 
	        rownumbers: true, 
	        sortName:'id',
	        sortOrder:'DESC', 
	        remoteSort: false,
	        columns: [[  
				{field:'chk',checkbox: true,width:50},
 		        {field:'id',title:'ID',width:50},    
 		        {field:'studentId',title:'Student',width:200,
 		        	formatter: function(value,row,index){
 						if (row.studentId){
 							var studentList = $("#studentList").combobox("getData");
 							for(var i=0;i<studentList.length;i++ ){
 								if(row.studentId == studentList[i].id)return studentList[i].name;
 							}
 							return row.studentId;
 						} else {
 							return 'not found';
 						}
 					}	
 		        },
 		       	{field:'courseId',title:'Course',width:200,
 		        	formatter: function(value,row,index){
 						if (row.courseId){
 							var courseList = $("#courseList").combobox("getData");
 							for(var i=0;i<courseList.length;i++ ){
 								if(row.courseId == courseList[i].id)return courseList[i].name;
 							}
 							return row.courseId;
 						} else {
 							return 'not found';
 						}
 					}		
 		       	},
 		       {field:'score',title:'Grade',width:200},
 		       {field:'remark',title:'Remark',width:200}
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
		//Preload student and course information
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
		  		
		  	});
	  		$("#courseList").combobox({
		  		width: "150",
		  		height: "25",
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false,
		  		editable: false,
		  		method: "post",
		  		url: "CourseServlet?method=CourseList&t="+new Date().getTime()+"&from=combox",
		  		
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
	    
	    //Import
	    $("#import").click(function(){
	    	$("#importDialog").dialog("open");
	    });
	    
	  //Edit
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("System alert", "Please select one item!", "warning");
            } else{
            	$("#edit_id").val(selectRows[0].id);
		    	$("#editDialog").dialog("open");
            }
	    });
	    
	    
	    //Delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("System alert", "Please select an item to delete!", "warning");
            } else{
            	var id = selectRow.id;
            	$.messager.confirm("System alert", "Are you sure you want to delete the grade?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "ScoreServlet?method=DeleteScore",
							data: {id: id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("System alert","Deleted successfully!","info");
									//Reload
									$("#dataList").datagrid("reload");
								}else if(msg == "not found"){
									$.messager.alert("System alert","This data doesn't exist!","info");
								}else{
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
	    	title: "Add new grade letter",
	    	width: 450,
	    	height: 450,
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
								url: "ScoreServlet?method=AddScore",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Added successfully!","info");
										//Close
										$("#addDialog").dialog("close");
										//Clear
										$("#add_remark").textbox('setValue', "");
										//Reload
										$('#dataList').datagrid("reload");
									} else if(msg == "added"){
										$.messager.alert("System alert","The grades for this course have already been entered and cannot be entered again!","warning");
										return;
									} else{
										$.messager.alert("System alert","There is an internal error in the system, please contact the administrator!","warning");
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
					iconCls:'icon-book-reset',
					handler:function(){
						$("#add_remark").textbox('setValue', "");
					}
				},
			]
	    });
	  	
	  //Edit
	    $("#editDialog").dialog({
	    	title: "Edit grade",
	    	width: 450,
	    	height: 450,
	    	iconCls: "icon-edit",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Update',
					plain: true,
					iconCls:'icon-book-edit',
					handler:function(){
						var validate = $("#editForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please check your input!","warning");
							return;
						} else{
							$.ajax({
								type: "post",
								url: "ScoreServlet?method=EditScore",
								data: $("#editForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Edit successfully!","info");
										//Close
										$("#editDialog").dialog("close");
										//Clear
										$("#edit_remark").textbox('setValue', "");
										//Reload
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("System alert","There is an internal error in the system, please contact the administrator!","warning");
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
					iconCls:'icon-book-reset',
					handler:function(){
						$("#edit_remark").textbox('setValue', "");
					}
				},
			],
			onBeforeOpen: function(){
				var selectRow = $("#dataList").datagrid("getSelected");
				//Setting value
				$("#edit_studentList").combobox('setValue', selectRow.studentId);
				$("#edit_score").numberbox('setValue', selectRow.score);
				$("#edit_remark").textbox('setValue', selectRow.remark);
				setTimeout(function(){
					$("#edit_courseList").combobox('setValue', selectRow.courseId);
				}, 100);
				
			}
	    });
	  	
	  //Import
	    $("#importDialog").dialog({
	    	title: "Import grading data",
	    	width: 450,
	    	height: 150,
	    	iconCls: "icon-add",
	    	modal: true,
	    	collapsible: false,
	    	minimizable: false,
	    	maximizable: false,
	    	draggable: true,
	    	closed: true,
	    	buttons: [
	    		{
					text:'Import',
					plain: true,
					iconCls:'icon-book-add',
					handler:function(){
						var validate = $("#importForm").form("validate");
						if(!validate){
							$.messager.alert("System alert","Please choose a file!","warning");
							return;
						} else{
							importScore();
							$("#importDialog").dialog("close");
						}
					}
				}
			]
	    });
	  
	  //Drop-down box properties
	  	$("#add_studentList, #add_courseList,#studentList,#courseList,#edit_studentList, #edit_courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	//Student
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//Default 1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getStudentSelectedCourseList(data[0].id);
	  		},
	  		onChange:function(id,o){
	  			getStudentSelectedCourseList(id);
	  		}
	  	});
	  	
	  //Course
	    function getStudentSelectedCourseList(studentId){
			    $("#add_courseList").combobox({
			  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
			  		onLoadSuccess: function(){
						//Default
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
			  		}
			  	});
		  	}	
	  
	  //Student
	    $("#edit_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//Default 1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getEditStudentSelectedCourseList(data[0].id);
	  		},
	  		onChange:function(id,o){
	  			getEditStudentSelectedCourseList(id);
	  		}
	  	});
	    function getEditStudentSelectedCourseList(studentId){
		  	//Course
			    $("#edit_courseList").combobox({
			  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
			  		onLoadSuccess: function(){
						//Default 1st
						var data = $(this).combobox("getData");
						$(this).combobox("setValue", data[0].id);
			  		}
			  	});
		  	}
	  
	    //Search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentid: $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue'),
	  			courseid: $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue')
	  		});
	  	});
	    
	  //Export
	  	$("#export").click(function(){
	  		studentid = $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue');
	  		courseid = $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue');
	  		url = 'ScoreServlet?method=ExportScoreList&studentid='+studentid+"&courseid="+courseid;
	  		window.location.href = url;
	  	});
	    
	    //Clear search
	  	$("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$("#studentList").combobox('clear');
	    	$("#courseList").combobox('clear');
	    });
	    
	  	function importScore(){
			$("#importForm").submit();
			$.messager.progress({text:'Importing...'});
			var interval = setInterval(function(){
				var message =  $(window.frames["import_target"].document).find("#message").text();
				if(message != null && message != ''){
					$.messager.progress('close');
					$.messager.alert("System alert",message,"info");
					$('#dataList').datagrid("reload");
					clearInterval(interval);
				}
			}, 1000)
		}
	});
	</script>
</head>
<body>
	<!-- Data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- Menu Tab -->
	<div id="toolbar">
		<c:if test="${userType != 2}">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="import" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Import</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="export" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Export</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left;"><a id="edit" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true">Edit</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		</c:if>
		<div style="margin-top: 3px;">
			Student：<input id="studentList" class="easyui-textbox" name="studentList" />
			Course：<input id="courseList" class="easyui-textbox" name="courseList" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
			<a id="clear-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Clear search</a>
		</div>
	</div>
	
	<!-- Add window -->
	<div id="addDialog" style="padding: 10px">  
    	<form id="addForm" method="post">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:40px">Student:</td>
	    			<td colspan="3">
	    				<input id="add_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Course:</td>
	    			<td colspan="3">
	    				<input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'Please select a course'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td style="width:40px">Grade:</td>
	    			<td colspan="3">
	    				<input id="add_score" style="width: 200px; height: 30px;" class="easyui-numberbox" data-options="required:true,min:0,precision:2, missingMessage:'Please fill in the correct grade'" name="score" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>Remark:</td>
	    			<td>
	    				<textarea id="add_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Edit window -->
	<div id="editDialog" style="padding: 10px">  
    	<form id="editForm" method="post">
	    	
	    	<input type="hidden" id="edit_id" name="id">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td style="width:40px">Student:</td>
	    			<td colspan="3">
	    				<input id="edit_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Course:</td>
	    			<td colspan="3">
	    				<input id="edit_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'Please select a course!'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td style="width:40px">Grade:</td>
	    			<td colspan="3">
	    				<input id="edit_score" style="width: 200px; height: 30px;" class="easyui-numberbox" data-options="required:true,min:0,precision:2, missingMessage:'Please input the correct grade!'" name="score" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		
	    		<tr>
	    			<td>Remark:</td>
	    			<td>
	    				<textarea id="edit_remark" name="remark" style="width: 300px; height: 160px;" class="easyui-textbox" data-options="multiline:true" ></textarea>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
	<!-- Import window -->
	<div id="importDialog" style="padding: 10px">  
    	<form id="importForm" method="post" enctype="multipart/form-data" action="ScoreServlet?method=ImportScore" target="import_target">
	    	<table cellpadding="8" >
	    		<tr>
	    			<td>Choose file:</td>
	    			<td>
	    				<input class="easyui-filebox" name="importScore" data-options="required:true,min:0,precision:2, missingMessage:'Please select a file!',prompt:'Choose file'" style="width:200px;">
	    			</td>
	    		</tr>
	    		
	    	</table>
	    </form>
	</div>
<!-- submit form iframe framework -->
	<iframe id="import_target" name="import_target"></iframe>	
</body>
</html>