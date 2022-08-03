<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Enroll List</title>
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
	        title:'Enroll List', 
	        iconCls:'icon-more', 
	        border: true, 
	        collapsible: false, 
	        fit: true, 
	        method: "post",
	        url:"SelectedCourseServlet?method=SelectedCourseList&t="+new Date().getTime(),
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
		//Preload student and course info 
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
	    
	  //Edit
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("System alert", "Please select one item!", "warning");
            } else{
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
            	$.messager.confirm("System alert", "All data related to the course will be deleted, confirm to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "SelectedCourseServlet?method=DeleteSelectedCourse",
							data: {id: id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("System alert","Delete successfully!","info");
									//Reload datagrid
									$("#dataList").datagrid("reload");
								}else if(msg == "not found"){
									$.messager.alert("System alert","This course doesn't exist!","info");
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
	    	title: "Add new enrollment",
	    	width: 450,
	    	height: 200,
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
								url: "SelectedCourseServlet?method=AddSelectedCourse",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Added successfully!","info");
										//Close window
										$("#addDialog").dialog("close");
										//Clear window
										$("#add_name").textbox('setValue', "");
										//Reload
										$('#dataList').datagrid("reload");
									} else if(msg == "courseFull"){
										$.messager.alert("System alert","Course is full!","warning");
										return;
									} else if(msg == "courseSelected"){
										$.messager.alert("System alert","You have enrolled in this course!","warning");
										return;
									}else{
										$.messager.alert("System alert","An error occurred in the system, please contact the administrator!","warning");
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
						$("#add_name").textbox('setValue', "");
					}
				},
			]
	    });
	  	
	  //Drop-down box
	  	$("#add_studentList, #add_courseList,#studentList,#courseList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	//Add student drop-down box
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//Default 1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  //Add course drop-down box
	    $("#add_courseList").combobox({
	  		url: "CourseServlet?method=CourseList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//Default 1st
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	    //Search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentid: $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue'),
	  			courseid: $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue')
	  		});
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
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Drop</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="margin-top: 3px;">
			Student：<input id="studentList" class="easyui-textbox" name="studentList" />
			Course：<input id="courseList" class="easyui-textbox" name="courseList" />
			<a id="search-btn" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true">Search</a>
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
	    				<input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>