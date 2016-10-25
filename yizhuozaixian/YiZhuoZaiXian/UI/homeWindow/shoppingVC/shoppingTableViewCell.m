//
//  shoppingTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/14.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "shoppingTableViewCell.h"



@interface shoppingTableViewCell()


@property (weak, nonatomic) IBOutlet UIImageView *shoppingImage;
@property (weak, nonatomic) IBOutlet UILabel *shoppingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingCiMaLabel;
@property (weak, nonatomic) IBOutlet UILabel *shoppingPrice;


@property (weak, nonatomic) IBOutlet UILabel *suliangLabel;
@property (weak, nonatomic) IBOutlet UIButton *gouxuanButton;

- (IBAction)gouxuanButton:(UIButton *)sender;
- (IBAction)reduceButton:(UIButton *)sender;
- (IBAction)addButton:(UIButton *)sender;

@property(nonatomic,assign)int  suliangInt;

@end


@implementation shoppingTableViewCell

-(void)setCellWithShoppingModel:(shoppingModel *)shoppingModel{
    
//    _shoppingNameLabel.text = shoppingModel.goo
    NSString * str1 = shoppingModel.size;
    if (str1.length <= 0) {
        str1 = @"";
    }
    NSString * str2 = shoppingModel.color;
    if (str2.length <= 0) {
        str2 = @"";
    }
    
    [_shoppingImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,shoppingModel.goods_small_img]] placeholderImage:[UIImage imageNamed:@"shopcar_img.png"]];
    _shoppingNameLabel.text = shoppingModel.goods_name;
    _shoppingCiMaLabel.text = [NSString stringWithFormat:@"%@  %@",str1,str2];
    _shoppingPrice.text = shoppingModel.goods_price;
    _suliangLabel.text = shoppingModel.num;
    _suliangInt = [shoppingModel.num intValue];
    _gouxuanButton.selected = shoppingModel.gouxuanSelected;
    
}



- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    self.shoppingCellBlock();
    // Configure the view for the selected state
}

- (IBAction)gouxuanButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    sender.tag = 100;
    self.shoppingCellBlock(sender,_suliangLabel.text);
}

- (IBAction)reduceButton:(UIButton *)sender {
    
    if (_suliangInt > 1) {
        _suliangInt--;
        
        _suliangLabel.text = [NSString stringWithFormat:@"%d",_suliangInt];
        self.shoppingCellBlock(nil,_suliangLabel.text);
    }
    
}

- (IBAction)addButton:(UIButton *)sender {
    if (_suliangInt == 0) {
        _suliangInt ++;
    }
    if (_suliangInt <= 100) {
        _suliangInt++;
    }
    _suliangLabel.text = [NSString stringWithFormat:@"%d",_suliangInt];
    self.shoppingCellBlock(nil,_suliangLabel.text);
}

@end
