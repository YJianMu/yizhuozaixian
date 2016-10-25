//
//  VipTableViewCell.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/14.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPModel.h"

@interface VipTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) memberGoods *model;

@end
