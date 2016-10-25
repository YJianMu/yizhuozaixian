//
//  ChangeAddressController.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/5.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeAddressController : UIViewController

/**收货人*/
@property (nonatomic, strong) NSString *consignee;
/**联系方式*/
@property (nonatomic, strong) NSString *phone;
/**省市区*/
@property (nonatomic, strong) NSString *address;
/**详细地址*/
@property (nonatomic, strong) NSString *detailAddress;
/**开关*/
@property (nonatomic, strong) NSString *defaultNumber;
/**地址编号*/
@property (nonatomic, strong) NSString *address_id;

@end
