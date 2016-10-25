//
//  RefundView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/11.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refoundViewDelegate <NSObject>

- (void)goback:(NSString *)order_sn and:(NSString *)reason;

@end

@interface RefundView : UIView

/**订单编号*/
@property (nonatomic, strong) UILabel *order;
/**退款说明*/
@property (nonatomic, strong) UILabel *show;
/**退款理由*/
@property (nonatomic, strong) UITextView *reason;

@property (nonatomic , weak) id <refoundViewDelegate> delegate;

+(instancetype)creatRefundView:(NSString *)ordername;

@end
