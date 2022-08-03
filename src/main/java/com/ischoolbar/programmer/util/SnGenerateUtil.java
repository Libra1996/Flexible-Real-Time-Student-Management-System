package com.ischoolbar.programmer.util;

import java.util.Date;

public class SnGenerateUtil {
	public static String generateSn(int clazzId){
		String sn = "";
		sn = "S" + System.currentTimeMillis();
		return sn;
	}
	public static String generateTeacherSn(int clazzId){
		String sn = "";
		sn = "T" + System.currentTimeMillis();
		return sn;
	}
}
