//
//  ChangePassWordView.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changepasswordDelegate;

@class ChangePassWordView;
@protocol changepasswordDelegate <NSObject>

- (void)changepasswordView:(ChangePassWordView *)changepasswordView andoldPassword:(ZCtextField *)oldPassword andFirstPassword:(ZCtextField *)FirstPassword andSecondPassword:(ZCtextField*)SecondPassword andbutton:(UIButton *)sender;
@end

@interface ChangePassWordView : UIView

@property (nonatomic,assign) id <changepasswordDelegate>delegate;

@end


