//
//  CheckPhoneNumber.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckPhoneNumber : NSObject
//手机号码格式验证
+ (BOOL)isMobileNumber:(NSString *)aString;

@end
