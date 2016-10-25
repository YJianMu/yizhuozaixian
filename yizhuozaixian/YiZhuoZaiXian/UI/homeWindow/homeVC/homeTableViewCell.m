 //
//  homeTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/15.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "homeTableViewCell.h"

@interface homeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *homeImagView;
@property (weak, nonatomic) IBOutlet UILabel *erjimuluLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation homeTableViewCell

-(void)setCellWithHomeVCModel:(homeModel *)homeVCModel{
    
    [self.homeImagView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,homeVCModel.goods_img]] placeholderImage:[UIImage imageNamed:@"hone_img_detail.png"]];
    

    
    self.erjimuluLabel.text = homeVCModel.cat_name;
    NSString * str = homeVCModel.shop_price;
    
    self.priceLabel.text = [str substringToIndex:[str length]];
    
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
