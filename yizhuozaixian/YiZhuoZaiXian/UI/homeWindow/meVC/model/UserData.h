//
//  UserData.h
//  YiZhuoZaiXian
//
//  Created by yeyuban on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString * iconValer;
@property (nonatomic,copy)NSString * token;


+ (UserData*)sharkedUser;
+ (void)setupData:(NSDictionary*)data;

+ (void)saveData;
+ (void)loadData;

@end
