//
//  getOrderTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/1.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "getOrderTableViewCellAddress.h"
@interface getOrderTableViewCellAddress()

@property (weak, nonatomic) IBOutlet UILabel *buyGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *buyGoodsTP;
@property (weak, nonatomic) IBOutlet UILabel *buyGoodsAddress;

@end


@implementation getOrderTableViewCellAddress


-(void)setTableViewCellWithAddress:(NSDictionary *)dic{
    if (dic[@"mobile"]!=nil) {
        _buyGoodsName.text = [NSString stringWithFormat:@"收货人：%@",dic[@"consignee"]];
        _buyGoodsTP.text = dic[@"mobile"];
        _buyGoodsAddress.text = [NSString stringWithFormat:@"%@%@",dic[@"address"],dic[@"detailAddress"]];
    }else{
        _buyGoodsAddress.text = @"嗨~   请填写默认收货地址！！！";
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
