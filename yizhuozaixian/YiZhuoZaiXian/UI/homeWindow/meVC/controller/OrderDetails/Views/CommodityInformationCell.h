//
//  CommodityInformationCell.h
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTest.h"

@interface CommodityInformationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) GoodsList *model;
@end