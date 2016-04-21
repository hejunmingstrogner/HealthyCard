//
//  Employee.h
//  HealthyCertificate
//
//  Created by 乄若醉灬 on 16/4/21.
//  Copyright © 2016年 JIANGXU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject

/**
 * 编号
 */
@property(nonatomic, strong) NSString * id;
/**
 * 工作人员编号
 */
@property(nonatomic, strong) NSString * workCode;
/**
 * 姓名
 */
@property(nonatomic, strong) NSString * name;
/**
 *
 */
@property(nonatomic, strong) NSString * hosID;
/**
 * 性别
 */
@property(nonatomic, strong) NSString * sex;
/**
 * 出生日期
 */
@property(nonatomic, strong) NSString * birthday;
/**
 * 机构名称
 */
@property(nonatomic, strong) NSString * hosName;
/**
 * 机构编号
 */
@property(nonatomic, strong) NSString * hosCode;
/**
 * 家庭住址
 */
@property(nonatomic, strong) NSString * homeAddress;
/**
 * 联系电话
 */
@property(nonatomic, strong) NSString * linkPhone;
/**
 * 登录账号
 */
@property(nonatomic, strong) NSString * logAccount;
/**
 * 工作职务
 */
@property(nonatomic, strong) NSString * workTitle;
/**
 * 工作角色
 */
@property(nonatomic, strong) NSString * workRole;
/**
 * 年龄 非数据库字段
 */
@property(nonatomic, assign) int age;

@property(nonatomic, strong) NSString * printPage;

//public EmployeeType toEnum() {
//    if (workRole.equals("护士")) {
//        return EmployeeType.Nurse;
//    } else if (workRole.equals("医生")) {
//        return EmployeeType.Doctor;
//    } else if (workRole.equals("内勤人员")) {
//        return EmployeeType.IndoorStaff;
//    } else if (workRole.equals("管理人员")) {
//        return EmployeeType.Manager;
//    } else if (workRole.equals("业务人员")) {
//        return EmployeeType.Business;
//    } else {
//        return EmployeeType.Other;
//    }
//}
//
//public enum EmployeeType {
//    /**
//     * 护士
//     */
//    Nurse(0),
//    /**
//     * 医生
//     */
//    Doctor(1),
//    /**
//     * 内勤人员
//     */
//    IndoorStaff(2),
//    /**
//     * 管理人员
//     */
//    Manager(3),
//    /**
//     * 业务人员
//     */
//    Business(4),
//    /**
//     * 其它人员
//     */
//    Other(99);
//    private int value;
//
//    private EmployeeType(int value) {
//        this.value = value;
//    }
//
//    public String toString() {
//        switch (value) {
//            case 0:
//                return "护士";
//            case 1:
//                return "医生";
//            case 2:
//                return "内勤人员";
//            case 3:
//                return "管理人员";
//            case 4:
//                return "业务人员";
//            default:
//                return "其它人员";
//        }
//    }
//}

@end
