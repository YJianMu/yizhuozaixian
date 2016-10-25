//
//  ConsigneeMessageCell.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "ConsigneeMessageCell.h"

@interface ConsigneeMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation ConsigneeMessageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ConsigneeMessageCell";
    ConsigneeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

- (void)setModel:(BFTest *)model{
    _model = model;
    self.address.text = model.address;
    self.consignee.text = model.consignee;
    self.mobile.text = model.mobile;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
