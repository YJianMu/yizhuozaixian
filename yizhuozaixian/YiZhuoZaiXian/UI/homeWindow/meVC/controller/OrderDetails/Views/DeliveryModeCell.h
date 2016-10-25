//
//  DeliveryModeCell.h
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTest.h"

@interface DeliveryModeCell : UITableViewCell

@property (nonatomic,strong) BFTest *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
