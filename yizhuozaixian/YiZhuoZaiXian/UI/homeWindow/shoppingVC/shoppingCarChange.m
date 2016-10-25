//
//  shoppingCarChange.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/31.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "shoppingCarChange.h"

@implementation shoppingCarChange


//修改购物车中商品数量
-(void)changeShoppingCarNumRequestWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr{
    [self requestPostWithURLstr:URLstr andDic:dic];
}
//删除购物车中某条商品数据
-(void)deleteShoppingCarGoodsWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr{
    
    [self requestPostWithURLstr:URLstr andDic:dic];
}
//添加商品到购物车
-(void)addGoodsShoppingCarGoodsWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr{
    [self requestPostWithURLstr:URLstr andDic:dic];
}
-(void)requestPostWithURLstr:(NSString *)URLstr andDic:(NSDictionary *)dic{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:URLstr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"修改或删除或添加购物车上传完成：%@",objc);
        if ([objc[@"info"]isEqualToString:@"u019"]) {
            [UserData sharkedUser].uid = nil;
            
            [SVProgressHUD showErrorWithStatus:@"登录已失效！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        NSLog(@"修改或删除或添加购物车上传出错 error = %@",error);
        
    }];
}

@end
