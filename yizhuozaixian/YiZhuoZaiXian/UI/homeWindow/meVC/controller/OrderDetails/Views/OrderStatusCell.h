//
//  OrderStatusCell.h
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#pragma mark - ******** 订单状态cell ********

#import <UIKit/UIKit.h>
#import "BFTest.h"

@interface OrderStatusCell : UITableViewCell
@property (nonatomic,strong) BFTest *model;
@property (nonatomic,strong) NSString *add_time;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
