//
//  getOrderTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/1.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "getOrderTableViewCellGoods.h"
@interface getOrderTableViewCellGoods()




@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsAttribute;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;


@end


@implementation getOrderTableViewCellGoods

-(void)setTableViewCellWithShoppModel:(shoppingModel *)model{
    
    NSLog(@"%@",model);
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_small_img]] placeholderImage:[UIImage imageNamed:@"icon_register_pic.png"]];
    _goodsName.text = model.goods_name;
    _goodsAttribute.text = [NSString stringWithFormat:@"%@ %@",model.color,model.size];
    _goodsPrice.text = model.goods_price;
    _goodsNumber.text = [NSString stringWithFormat:@"x %@",model.num];
    
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
