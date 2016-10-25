//
//  DeliveryModeCell.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "DeliveryModeCell.h"

@interface DeliveryModeCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *nameid;
@end

@implementation DeliveryModeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DeliveryModeCell";
    DeliveryModeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(BFTest *)model{
    _model = model;
    if (model.express_name.length == 0) {
        self.name.text = @"暂无";
    }else{
        self.name.text = model.express_name;
    }
    if (model.express_sn.length == 0) {
        self.nameid.text = @"暂无";
        
    }else{
        self.nameid.text = model.express_sn;
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
