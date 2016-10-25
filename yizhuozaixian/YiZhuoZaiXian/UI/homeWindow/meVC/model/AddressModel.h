//
//  AddressModel.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/9.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class addrData;

@interface AddressModel : NSObject

@property (nonatomic,copy)NSString *info;
@property (nonatomic,strong) NSArray<addrData *> *addrData;

@end


@interface addrData : NSObject

/**地址编号*/
@property (nonatomic,copy)NSString *address_id;

/**  地址*/
@property (nonatomic,copy)NSString *address;
/** 收货人*/
@property (nonatomic,copy)NSString *consignee;
/** 详细地址*/
@property (nonatomic,copy)NSString *detailAddress;
/** 是否为默认地址*/
@property (nonatomic,copy)NSString *isDefault;
/** 电话号码*/
@property (nonatomic,copy)NSString *mobile;



@end