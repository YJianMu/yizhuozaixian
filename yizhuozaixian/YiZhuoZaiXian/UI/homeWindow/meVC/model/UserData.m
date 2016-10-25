//
//  UserData.m
//  YiZhuoZaiXian
//
//  Created by yeyuban on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (UserData*)sharkedUser {
    static UserData *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [self new];
    });
    return user;
}

+ (void)setupData:(NSDictionary*)data {
    UserData *user = [UserData sharkedUser];
    user.imgUrl = data[@"imgUrl"];
    user.uid = data[@"uid"];
    
}

+ (void)saveData {
    UserData *user = [UserData sharkedUser];
    [[NSUserDefaults standardUserDefaults] setObject:user.imgUrl forKey:@"USER_PHOTO"];
    [[NSUserDefaults standardUserDefaults] setObject:user.gender forKey:@"USER_GENDER"];
    [[NSUserDefaults standardUserDefaults] setObject:user.nickname forKey:@"USER_NICKNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:@"USER_UID"];
    [[NSUserDefaults standardUserDefaults] setObject:user.iconValer forKey:@"USER_ICONVALER"];
    [[NSUserDefaults standardUserDefaults] setObject:user.token forKey:@"USER_TOKEN"];

    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)loadData {
    UserData *user = [UserData sharkedUser];
    user.imgUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_PHOTO"];
    user.uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_UID"];
    user.nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_NICKNAME"];
    user.gender = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_GENDER"];
    user.iconValer = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ICONVALER"];
    user.token = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_TOKEN"];

}

@end
