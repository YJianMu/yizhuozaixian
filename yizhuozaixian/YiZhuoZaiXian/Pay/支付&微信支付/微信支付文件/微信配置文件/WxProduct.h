//
//  zxProduct.h
//  payDemo
//
//  Created by gorson on 4/26/15.
//  Copyright (c) 2015 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义
//
@interface WxProduct : NSObject


@property (nonatomic, copy) NSString * price;     // 价格
@property (nonatomic, copy) NSString * subject; // 标题
@property (nonatomic, copy) NSString * body;    // 描述
@property (nonatomic, copy) NSString * orderId; // （我们的服务器）订单号

@end
