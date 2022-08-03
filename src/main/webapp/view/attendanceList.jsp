<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="UTF-8">
	<title>Attendance List</title>
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
	        title:'Attendance List', 
	        iconCls:'icon-more',
	        border: true, 
	        collapsible: false,
	        fit: true, 
	        method: "post",
	        url:"AttendanceServlet?method=AttendanceList&t="+new Date().getTime(),
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
 								//console.log(clazzList[i]);
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
 								//console.log(clazzList[i]);
 								if(row.courseId == courseList[i].id)return courseList[i].name;
 							}
 							return row.courseId;
 						} else {
 							return 'not found';
 						}
 					}		
 		       	},
 		       {field:'type',title:'Session',width:200, sortable: false},
 		      {field:'date',title:'Date',width:200, sortable: false}
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
		  		width: 80,
		  		height: 25,
		  		valueField: "id",
		  		textField: "name",
		  		multiple: false,
		  		editable: false,
		  		method: "post",
		  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
		  		
		  	});
	  		$("#courseList").combobox({
		  		width: 80,
		  		height: 25,
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
	    	pageSize: 10,//The number of item displayed per page. (Default: 10)
	        pageList: [10,20,30,50,100],//Change page size
	        beforePageText: 'Page',
	        afterPageText: '    Total {pages} page', 
	        displayMsg: 'Current {from} - {to} item   Total {total} item', 
	    });
	   	
	    //Add button
	    $("#add").click(function(){
	    	$("#addDialog").dialog("open");
	    });
	    
	  //Edit button
	    $("#edit").click(function(){
	    	table = $("#editTable");
	    	var selectRows = $("#dataList").datagrid("getSelections");
        	if(selectRows.length != 1){
            	$.messager.alert("System alert", "Please pick one item to delete!", "warning");
            } else{
		    	$("#editDialog").dialog("open");
            }
	    });
	    
	    
	    //Delete
	    $("#delete").click(function(){
	    	var selectRow = $("#dataList").datagrid("getSelected");
        	if(selectRow == null){
            	$.messager.alert("System alert", "Please select one to delete!", "warning");
            } else{
            	var id = selectRow.id;
            	$.messager.confirm("System alert", "All data related to the course will be deleted, confirm to continue?", function(r){
            		if(r){
            			$.ajax({
							type: "post",
							url: "AttendanceServlet?method=DeleteAttendance",
							data: {id: id},
							success: function(msg){
								if(msg == "success"){
									$.messager.alert("System alert","Delete successfully!","info");
									//Reload data
									$("#dataList").datagrid("reload");
								}else if(msg == "not found"){
									$.messager.alert("System alert","Not exist!","info");
								}else{
									$.messager.alert("System alert","Deletet failed!","warning");
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
	    	title: "Add new attendance information",
	    	width: 450,
	    	height: 300,
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
								url: "AttendanceServlet?method=AddAttendance",
								data: $("#addForm").serialize(),
								success: function(msg){
									if(msg == "success"){
										$.messager.alert("System alert","Added successfully!","info");
										//Close window
										$("#addDialog").dialog("close");
										//Clear the window
										$("#add_name").textbox('setValue', "");
										//Reload
										$('#dataList').datagrid("reload");
									} else{
										$.messager.alert("System alert",msg,"warning");
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
	  	
	  //Drop-down box properties
	  	$("#add_studentList, #add_courseList,#studentList,#courseList,#add_typeList").combobox({
	  		width: "200",
	  		height: "30",
	  		valueField: "id",
	  		textField: "name",
	  		multiple: false,
	  		editable: false,
	  		method: "post",
	  	});
	  	//Add box
	    $("#add_studentList").combobox({
	  		url: "StudentServlet?method=StudentList&t="+new Date().getTime()+"&from=combox",
	  		onLoadSuccess: function(){
				//1st option
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
				getStudentSelectedCourseList(data[0].id);
	  		},
	  		onChange:function(id,o){
	  			getStudentSelectedCourseList(id);
	  		}
	  	});
	  	
	  	function getStudentSelectedCourseList(studentId){
	  	//Add course box
		    $("#add_courseList").combobox({
		  		url: "AttendanceServlet?method=getStudentSelectedCourseList&t="+new Date().getTime()+"&student_id="+studentId,
		  		onLoadSuccess: function(){
					//1st option
					var data = $(this).combobox("getData");
					$(this).combobox("setValue", data[0].id);
		  		}
		  	});
	  	}
	  	var typeData = [{id:"session 1",text:"session 1"},{id:"session 2",text:"session 2"}];
	  	$("#add_typeList").combobox({
	  		data:typeData,
	  		valueField: 'id',
	  		textField: 'text',
	  		onLoadSuccess: function(){
				//1st option
				var data = $(this).combobox("getData");
				$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	$("#typeList").combobox({
	  		data:typeData,
	  		valueField: 'id',
	  		textField: 'text',
	  		width: "80",
	  		height: "25",
	  		onLoadSuccess: function(){
				//var data = $(this).combobox("getData");
				//$(this).combobox("setValue", data[0].id);
	  		}
	  	});
	  	
	  	
	    //Search
	  	$("#search-btn").click(function(){
	  		$('#dataList').datagrid('load',{
	  			studentid: $("#studentList").combobox('getValue') == '' ? 0 : $("#studentList").combobox('getValue'),
	  			courseid: $("#courseList").combobox('getValue') == '' ? 0 : $("#courseList").combobox('getValue'),
				type: $("#typeList").combobox('getValue') == '' ? '' : $("#typeList").combobox('getValue'),
				date:$("#date").datebox('getValue')
	  		});
	  	});
	    
	    $("#clear-btn").click(function(){
	    	$('#dataList').datagrid("reload",{});
	    	$("#studentList").combobox('clear');
	    	$("#courseList").combobox('clear');
	    });
	    
	    
	});
	</script>
	<script type="text/javascript">
		function myformatter(date){
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
		function myparser(s){
			if (!s) return new Date();
			var ss = (s.split('-'));
			var y = parseInt(ss[0],10);
			var m = parseInt(ss[1],10);
			var d = parseInt(ss[2],10);
			if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
				return new Date(y,m-1,d);
			} else {
				return new Date();
			}
		}
	</script>
</head>
<body>
	<!-- Data List -->
	<table id="dataList" cellspacing="0" cellpadding="0"> 
	    
	</table> 
	<!-- Menu tab -->
	<div id="toolbar">
		<div style="float: left;"><a id="add" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true">Add</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="float: left; margin-right: 10px;"><a id="delete" href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-some-delete',plain:true">Delete</a></div>
		<div style="float: left;" class="datagrid-btn-separator"></div>
		<div style="margin-top: 3px;">
			Student:<input id="studentList" class="easyui-textbox" name="studentList" />
			Course:<input id="courseList" class="easyui-textbox" name="courseList" />
			Session:<input id="typeList" class="easyui-textbox" name="typeList" />
			Date:<input id="date" data-options="formatter:myformatter,parser:myparser" class="easyui-datebox" name="date" />
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
	    				<input id="add_studentList" style="width: 200px; height: 30px;" class="easyui-textbox" name="studentid" data-options="required:true, missingMessage:'Please select a student!'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Course:</td>
	    			<td colspan="3">
	    				<input id="add_courseList" style="width: 200px; height: 30px;" class="easyui-textbox" name="courseid" data-options="required:true, missingMessage:'Please select a course!'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    		<tr>
	    			<td style="width:40px">Session:</td>
	    			<td colspan="3">
	    				<input id="add_typeList" style="width: 200px; height: 30px;" class="easyui-textbox" name="type" data-options="required:true, missingMessage:'Please select one!'" />
	    			</td>
	    			<td style="width:80px"></td>
	    		</tr>
	    	</table>
	    </form>
	</div>
	
</body>
</html>