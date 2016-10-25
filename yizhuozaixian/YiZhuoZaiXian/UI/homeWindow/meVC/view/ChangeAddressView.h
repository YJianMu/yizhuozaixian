//
//  ChangeAddressView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/11.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeAddressViewDelegate <NSObject>

- (void)goBackToAddressView;

@end

@interface ChangeAddressView : UIView

/**收货人*/
@property (nonatomic, strong) UITextField *name;
/**详细地址*/
@property (nonatomic, strong) UITextField *detailAddress;
/**联系方式*/
@property (nonatomic, strong) UITextField *phone;
/**分区*/
@property (nonatomic, strong) UILabel *address;
/**开关*/
@property (nonatomic, strong) NSString *defaultNumber;
/**省*/
@property (nonatomic, strong) NSString *province;
/**市*/
@property (nonatomic, strong) NSString *city;
/**区*/
@property (nonatomic, strong) NSString *area;
/**地址ID*/
@property (nonatomic, strong) NSString *address_id;

/**代理*/
@property (nonatomic, weak) id <ChangeAddressViewDelegate>delegate;

+ (instancetype)creatView:(NSString *)consignee andaddress:(NSString *)address anddetailaddress:(NSString *)detailaddress andmobile:(NSString *)mobile anddefault:(NSString *)isdefault andaddress_id:(NSString *)address_id;
@end
