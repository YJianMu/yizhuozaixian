//
//  OrderStatusCell.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "OrderStatusCell.h"

@interface OrderStatusCell ()
@property (weak, nonatomic) IBOutlet UILabel *order_sn;
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation OrderStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"OrderStatusCell";
    OrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


-(void)setModel:(BFTest *)model{
    _model = model;
    self.order_sn.text = model.order_sn;
    self.time.text = self.add_time;

    if ([model.order_status isEqualToString:@"0"]) {
        self.order_status.text = @"未支付";
    }else if ([model.order_status isEqualToString:@"1"]) {
        self.order_status.text = @"已支付";
    }else if ([model.order_status isEqualToString:@"2"]) {
        self.order_status.text = @"交易关闭";
    }else if ([model.order_status isEqualToString:@"4"]) {
        self.order_status.text = @"退款中";
    }else if ([model.order_status isEqualToString:@"5"]) {
        self.order_status.text = @"退款完成";
    }else if([model.order_status isEqualToString:@"3"]){
        self.order_status.text = @"交易完成";
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
