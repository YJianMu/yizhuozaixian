//
//  DetailOrderFooterView.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/8.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "DetailOrderFooterView.h"

@interface DetailOrderFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *leave_message;

@end

@implementation DetailOrderFooterView


+ (instancetype)footerView{
    DetailOrderFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    return footerView;
}
-(void)setModel:(BFTest *)model{
    _model = model;

    self.leave_message.text = model.leave_message;
    
}

@end
