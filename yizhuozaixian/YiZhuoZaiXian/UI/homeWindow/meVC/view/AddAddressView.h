//
//  AddAddressView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/31.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAddressViewDelegate <NSObject>

- (void)goBackToAddressView;

@end

@interface AddAddressView : UIView
/**收货人*/
@property (nonatomic, strong) UITextField *consignee;
/**详细地址*/
@property (nonatomic, strong) UITextField *detailAddress;
/**联系方式*/
@property (nonatomic, strong) UITextField *phone;
/**分区*/
@property (nonatomic, strong) UILabel *selectArea;
/**省*/
@property (nonatomic, strong) NSString *province;
/**市*/
@property (nonatomic, strong) NSString *city;
/**区*/
@property (nonatomic, strong) NSString *area;
/**开关*/
@property (nonatomic, strong) NSString *defaultNumber;

+ (instancetype)creatView;
/**代理*/
@property (nonatomic, weak) id <AddAddressViewDelegate>delegate;

@end
