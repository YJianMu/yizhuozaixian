//
//  CommodityTotalPriceCell.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "CommodityTotalPriceCell.h"

@interface CommodityTotalPriceCell()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceTitle;

@end

@implementation CommodityTotalPriceCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CommodityTotalPriceCell";
    CommodityTotalPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(BFTest *)model{
    _model = model;
    self.totalPriceTitle.text = [NSString stringWithFormat:@"¥%@",model.total_prices];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
