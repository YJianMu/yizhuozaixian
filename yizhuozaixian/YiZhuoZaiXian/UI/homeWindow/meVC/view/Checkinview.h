//
//  Checkinview.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/17.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkinViewDelegate;

typedef NS_ENUM(NSInteger,checkinModel){
    XCDCheckinModelLogon,
    XCDCheckinModelWeixin,
    XCDCheckinModelQQ,
    XCDCheckinModelCheckin
};

@interface Checkinview : UIImageView
@property (nonatomic,weak) id<checkinViewDelegate> delegate;
@end
@protocol checkinViewDelegate <NSObject>

/** 点击返回按钮时调用 */
//- (void)checkinView:(Checkinview *)checkinView backButtonClicked:(UIButton *)sender;

/** 根据不同的登录类型进行相应操作 */
- (void)checkinView:(Checkinview *)checkinView checkinButtonClicked:(UIButton *)sender checkinMode:(checkinModel)loginMode;

/** 点击登录按钮*/
- (void)checkinView:(Checkinview *)checkinView checkinButtonClicked:(UIButton *)sender numberText:(NSString *)numberText secretText:(NSString *)secretText;

- (void)clickForgotPassWord;

@end
