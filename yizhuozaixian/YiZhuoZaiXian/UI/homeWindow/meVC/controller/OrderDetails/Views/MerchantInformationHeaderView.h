//
//  MerchantInformationHeaderView.h
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTest.h"

@protocol MerchantInformationHeaderViewDelegate <NSObject>

@optional
#warning TODO:
- (void)phoneToMerchant;

@end


@interface MerchantInformationHeaderView : UIView

+ (instancetype)headerView;

@property (nonatomic,strong) BFTest *model;

@property (nonatomic,weak) id<MerchantInformationHeaderViewDelegate> delegate;

@end
