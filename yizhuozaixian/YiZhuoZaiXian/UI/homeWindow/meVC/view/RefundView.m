//
//  RefundView.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/11.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "RefundView.h"
#import "UIView+Frame.h"

@interface RefundView () <UITextViewDelegate>
@property(nonatomic,strong)NSString * order_sn;
@end

@implementation RefundView



+(instancetype)creatRefundView:(NSString *)ordername{
    
    RefundView *view = [[RefundView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [view setView:ordername];
    return view;
    
}


- (void)setView:(NSString *)ordername{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 260)];
    [self addSubview:bottomView];
    
    UILabel *order_sn_label = [UILabel new];
    order_sn_label.text = @"订单编号:";
    order_sn_label.frame = CGRectMake(10, 0, 80, 44);
    [bottomView addSubview:order_sn_label];
    
    UIView *firstLine = [self setUpLine];
    firstLine.frame = CGRectMake(10, order_sn_label.height - 0.5, ScreenWidth - 20, 0.5);
    [bottomView addSubview:firstLine];
    
    
    UILabel *contactInformationLabel = [UILabel new];
    contactInformationLabel.text = @"退款说明:";
    contactInformationLabel.frame = CGRectMake(order_sn_label.x, CGRectGetMaxY(order_sn_label.frame), order_sn_label.width, order_sn_label.height);;
    [bottomView addSubview:contactInformationLabel];
    

    UILabel *order = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 44)];
    self.order = order;
    order.text = ordername;
    order.font = [UIFont systemFontOfSize:13];
    order.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:order];
    
    
    UITextView *reason = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(contactInformationLabel.frame), ScreenWidth - 20, 80)];
    self.reason = reason;
    reason.delegate = self;
    reason.font = [UIFont systemFontOfSize:13];
    reason.returnKeyType = UIReturnKeyDone;
    //reason.backgroundColor = [UIColor blueColor];
    reason.layer.borderColor = UIColor.lightGrayColor.CGColor;
    reason.layer.borderWidth = 1;
    reason.layer.cornerRadius = 6;
    reason.layer.masksToBounds = YES;
    [bottomView addSubview:reason];
    
    self.order_sn = ordername;
    
    UIButton *saveButton = [UIButton buttonWithType:0];
    saveButton.frame = CGRectMake(0.1 * ScreenWidth, CGRectGetMaxY(reason.frame) + 40, ScreenWidth - 0.2 *ScreenWidth, 0.1 * ScreenWidth);
    [saveButton setTitle:@"提交申请" forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor redColor];
    saveButton.layer.cornerRadius = 15;
    [saveButton addTarget:self action:@selector(clicksave:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
    
    
}


- (void)clicksave:(UIButton *)sender{
    [self.delegate goback:self.order_sn and:self.reason.text];
    NSLog(@"提交申请");
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.frame.size.height - (textField.frame.origin.y + textField.frame.size.height +216 +10);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = offset;
            self.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 64;
        self.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat offset = self.frame.size.height - (textView.frame.origin.y + textView.frame.size.height +216 +10);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = offset;
            self.frame = frame;
        }];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 64;
        self.frame = frame;
    }];
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [self.reason resignFirstResponder];
}


- (UIView *)setUpLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    return line;
}

@end
