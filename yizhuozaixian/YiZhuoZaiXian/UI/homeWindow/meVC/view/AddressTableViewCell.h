//
//  AddressTableViewCell.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/29.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AddressTableViewCell : UITableViewCell
@property (nonatomic,strong) addrData *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
