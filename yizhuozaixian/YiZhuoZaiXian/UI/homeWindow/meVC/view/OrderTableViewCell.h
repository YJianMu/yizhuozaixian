//
//  OrderTableViewCell.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
#import "NoPayModel.h"
#import "NoGoodsModel.h"
#import "paidmodel.h"



@interface OrderTableViewCell : UITableViewCell

@property (nonatomic,weak)UINavigationController *navigationController;

//+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) NoPayModel *model;

@property (nonatomic,strong) OrderListModel *ordersModel;

@property (nonatomic,strong) NoGoodsModel *nogoodsmodel;

@property (nonatomic,strong) paidmodel *paidmodel;

//-(void)setCellWithOrdersModel:(OrderListModel *)ordersModel;

@end
