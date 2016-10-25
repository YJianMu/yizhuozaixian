//
//  classCollectionViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "classCollectionViewCell.h"

@implementation classCollectionViewCell

//小图
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
        
        UIView * vi =  [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        vi.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:vi];
        
        UIView * vii =  [[UIView alloc] initWithFrame:CGRectMake(8, 8,self.frame.size.width-16, self.frame.size.height-16)];
        [vi addSubview:vii];
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, vii.frame.size.width, 0.85*vii.frame.size.width)];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        [vii addSubview:_goodsImageView];
        
        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.85*vii.frame.size.width + 5 , vii.frame.size.width, 20)];
        _goodsNameLabel.backgroundColor = [UIColor clearColor];
        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        _goodsNameLabel.font = [UIFont systemFontOfSize:13];
        [vii addSubview:_goodsNameLabel];
        
        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.85*vii.frame.size.width + 5 + 20 + 5, vii.frame.size.width, 20)];
        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:15];
        _goodsPriceLabel.textColor = [UIColor orangeColor];
        
        [vii addSubview:_goodsPriceLabel];
        
        
        
        
//        self.contentView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
////        UIView * vii =  [UIView alloc] initWithFrame:
////        self.contentView.backgroundColor = [UIColor grayColor];
//        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.85*self.frame.size.width)];
//        _goodsImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_goodsImageView];
//        
//        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.85*self.frame.size.width + 5 , self.frame.size.width, 20)];
//        _goodsNameLabel.backgroundColor = [UIColor clearColor];
//        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsNameLabel.font = [UIFont systemFontOfSize:15];
//        [self.contentView addSubview:_goodsNameLabel];
//        
//        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.85*self.frame.size.width + 5 + 20 + 5, self.frame.size.width, 20)];
//        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
//        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:17];
//        _goodsPriceLabel.textColor = [UIColor orangeColor];
//        
//        [self.contentView addSubview:_goodsPriceLabel];
        
        
        
        
        
        
////        self.contentView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
//        //        UIView * vii =  [UIView alloc] initWithFrame:
//        self.contentView.backgroundColor = [UIColor grayColor];
//        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, 0.5*0.85*(ScreenWidth-20))];
//        _goodsImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_goodsImageView];
//        
//        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + 0.5*0.85*(ScreenWidth-20) + 5 , (ScreenWidth-20)*0.5, 20)];
//        _goodsNameLabel.backgroundColor = [UIColor greenColor];
//        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsNameLabel.font = [UIFont systemFontOfSize:15];
//        [self.contentView addSubview:_goodsNameLabel];
//        
//        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 + 0.5*0.85*(ScreenWidth-20) + 5 + 20, (ScreenWidth-20)*0.5, 20)];
//        _goodsPriceLabel.backgroundColor = [UIColor greenColor];
//        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:17];
//        _goodsPriceLabel.textColor = [UIColor orangeColor];
//        
//        [self.contentView addSubview:_goodsPriceLabel];
    }
    return self;
}
@end
