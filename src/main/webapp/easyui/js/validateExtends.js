$.extend($.fn.validatebox.defaults.rules, {
/*    //验证汉字
    CHS: {
        validator: function (value) {
            return /^[\u0391-\uFFE5]+$/.test(value);
        },
        message: '只能输入汉字'
    },*/
    //Phone number validation
    mobile: {
		//Value is the value in the text box
        validator: function (value) {
            var reg = /^[1-9]\d{9}$/;
            return reg.test(value);
        },
        message: 'Please input 10 digits only!'
    },
    
/*  	//Number validation
    number: {
		//Value is the value in the text box
        validator: function (value) {
            var reg = /^[0-9]*$/;
            return reg.test(value);
        },
        message: 'Only input number type!'
    }, */
    
  	//Email validation
    email: {
		//Value is the value in the text box
        validator: function (value) {
            var reg = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            return reg.test(value);
        },
        message: 'Please input correct email Ex: ****@sjsu.edu'
    },
    
	//Account duplicate validation
	repeat: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "SystemServlet?method=AllAccount&t="+new Date().getTime(),
				success: function(data){
					//Load the data from the validation function, and compare with the input value after loading
					var account = $.parseJSON(data);
		            for(var i=0;i < account.length;i++){
		            	if(value == account[i]){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'User existed!'
	},
	
	//Course duplication validation
	repeat_course: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "CourseServlet?method=CourseList&t="+new Date().getTime(),
				success: function(data){
					//Load the data from the validation function, and compare with the input value after loading
					var course = $.parseJSON(data);
		            for(var i=0;i < course.length;i++){
		            	if(value == course[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'Course existed!'
	},
	
	//Grade duplicate validation
	repeat_grade: {
		validator: function (value) {
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				url: "GradeServlet?method=GradeList&t="+new Date().getTime(),
				success: function(data){
					//Load the data from the validation function, and compare with the input value after loading
					var grade = $.parseJSON(data);
		            for(var i=0;i < grade.length;i++){
		            	if(value == grade[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'Duplicated grade'
	},
	
	//Major duplicate validation
	repeat_clazz: {
		validator: function (value, param) {
			var gradeid = $(param[0]).combobox("getValue");
			var flag = true;
			$.ajax({
				type: "post",
				async: false,
				data: {gradeid: gradeid},
				url: "ClazzServlet?method=ClazzList&t="+new Date().getTime(),
				success: function(data){
					//Load the data from the validation function, and compare with the input value after loading
					var clazz = $.parseJSON(data);
		            for(var i=0;i < clazz.length;i++){
		            	if(value == clazz[i].name){
		            		flag = false;
		            		break;
		            	}
		            }
				}
			});
			return flag;
	    },
	    message: 'Duplicated major!'
	},
	
	//Two values comparation validation
	equals: {
		//The value of param is the middle value of []
        validator: function (value, param) {
        	if($(param[0]).val() != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Passwords not match.'
    },
    
    //Password requirement
    password: {
        validator: function (value) {
        	var reg = /^[a-zA-Z0-9]{6,16}$/;
        	return reg.test(value);
            
        }, message: 'Password must contain 6-16 characters and only include english & number.'
    },
    
    //Input password validation
    oldPassword: {
        validator: function (value, param) {
        	if(param != value){
        		return false;
        	} else{
        		return true;
        	}
            
        }, message: 'Password incorrect!'
    },
    
/*    //国内邮编验证
    zipcode: {
        validator: function (value) {
            var reg = /^[1-9]\d{5}$/;
            return reg.test(value);
        },
        message: '邮编必须是非0开始的6位数字.'
    },*/
    
    //User account validation (only include _ number character) 
    account: {
        validator: function (value, param) {
            if (value.length < param[0] || value.length > param[1]) {
                $.fn.validatebox.defaults.rules.account.message = 'User name must in the length of' + param[0] + 'to' + param[1];
                return false;
            } else {
                if (!/^[\w]+$/.test(value)) {
                    $.fn.validatebox.defaults.rules.account.message = 'User name can only use numbers, characters, and underline.';
                    return false;
                } else {
                    return true;
                }
            }
        }, message: ''
    }
}) 
