//
//  LogonView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LogonDelegate;

typedef NS_ENUM(NSInteger,logonButtonModel){
    modelhuoqu,
    modeldenglu
};

@interface LogonView : UIImageView <UITextFieldDelegate>

@property (nonatomic,assign) id <LogonDelegate> delegate;

@end

@protocol LogonDelegate <NSObject>

- (void)LogonView:(LogonView *)logonview LogonViewButton:(UIButton *)sender model:(logonButtonModel *)model numbertext:(NSString *)numbertext password:(NSString *)password;

- (void)LogonView:(LogonView *)logonview LogonViewButton:(UIButton *)sender model:(logonButtonModel *)model numbertext:(NSString *)numbertext codetext:(NSString *)codetext;

@end