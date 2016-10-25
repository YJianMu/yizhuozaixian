//
//  MerchantInformationHeaderView.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "MerchantInformationHeaderView.h"

@interface MerchantInformationHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *brand_name;
@property (weak, nonatomic) IBOutlet UILabel *brand_tel;

@end

@implementation MerchantInformationHeaderView

+ (instancetype)headerView{
    MerchantInformationHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    return headerView;
}


//- (instancetype)init{
//    if (self = [super init]) {
//        self.brand_name.text = self.model.brand_name;
//        self.brand_tel.text = self.model.brand_tel;
//    }
//    return self;
//}

-(void)setModel:(BFTest *)model{
    _model = model;
    self.brand_name.text = model.brand_name;
    self.brand_tel.text = model.brand_tel;
    
}


- (IBAction)phone:(id)sender {

#warning TODO:
    if ([_delegate respondsToSelector:@selector(phoneToMerchant)]) {
        [_delegate phoneToMerchant];
    }
    
}

@end
