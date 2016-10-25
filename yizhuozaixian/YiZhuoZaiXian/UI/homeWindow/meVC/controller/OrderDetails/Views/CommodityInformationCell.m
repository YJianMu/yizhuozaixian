//
//  CommodityInformationCell.m
//  会员中心
//
//  Created by WLZouyiqin on 16/4/7.
//  Copyright © 2016年 wlstock. All rights reserved.
//

#import "CommodityInformationCell.h"

@interface CommodityInformationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goods_small_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_p;

@property (weak, nonatomic) IBOutlet UILabel *goods_attr;
@end

@implementation CommodityInformationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"CommodityInformationCell";
    CommodityInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setModel:(GoodsList *)model{
    _model = model;
    [self.goods_small_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_small_img]] placeholderImage:nil];
    
    NSString *str = [NSString stringWithFormat:@"¥%@x%@",model.goods_price,model.num];
    self.goods_p.text = str;
    self.goods_name.text = model.goods_name;

    self.goods_attr.text = model.goods_attr;
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
