//
//  VipTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/14.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "VipTableViewCell.h"

@interface VipTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *member_price;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *shop_price;
@property (weak, nonatomic) IBOutlet UIImageView *goods_thumb;


@end



@implementation VipTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"VipTableViewCell";
    VipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(memberGoods *)model{
    _model  = model;
    self.goods_name.text = model.goods_name;
    self.shop_price.text = [NSString stringWithFormat:@"%@%@",@"市场价： ¥",model.shop_price];
    self.grade.text = [NSString stringWithFormat:@"%@%@",model.grade,@"专享"];
    [self.goods_thumb sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_thumb]] placeholderImage:[UIImage imageNamed:@"member_img.png"]];
    self.member_price.text = [NSString stringWithFormat:@"%@%@",@"¥",model.member_price];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
