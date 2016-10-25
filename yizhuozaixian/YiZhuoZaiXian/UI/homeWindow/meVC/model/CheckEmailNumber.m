//
//  CheckEmailNumber.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "CheckEmailNumber.h"

@implementation CheckEmailNumber

+(BOOL)isEmailNumber:(NSString *)aString{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    if ([emailTest evaluateWithObject:aString]) {
        return YES;
    }else{
        return NO;
    }
}
@end
