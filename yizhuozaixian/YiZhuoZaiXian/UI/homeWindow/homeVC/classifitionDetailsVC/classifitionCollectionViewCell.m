//
//  classifitionCollectionViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "classifitionCollectionViewCell.h"

@implementation classifitionCollectionViewCell

//大图
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
        
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, vii.frame.size.width, 0.6*vii.frame.size.width)];
        _goodsImageView.backgroundColor = [UIColor clearColor];
        [vii addSubview:_goodsImageView];
        
        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6 * vii.frame.size.width + 10 , vii.frame.size.width, 40)];
        _goodsNameLabel.backgroundColor = [UIColor clearColor];
        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        _goodsNameLabel.font = [UIFont boldSystemFontOfSize:18];
        [vii addSubview:_goodsNameLabel];
        
        _goodsDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6*vii.frame.size.width + 40 + 5 , vii.frame.size.width, 35)];
        _goodsDescribeLabel.backgroundColor = [UIColor clearColor];
        _goodsDescribeLabel.textAlignment = NSTextAlignmentCenter;
        _goodsDescribeLabel.textColor = [UIColor lightGrayColor];
        _goodsDescribeLabel.numberOfLines = 2;
        _goodsDescribeLabel.font = [UIFont  systemFontOfSize:12];
        [vii addSubview:_goodsDescribeLabel];
        
        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6*vii.frame.size.width + 40 + 5 + 35 + 10 , vii.frame.size.width, 30)];
        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
        _goodsPriceLabel.textColor = [UIColor orangeColor];
        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:18];
        [vii addSubview:_goodsPriceLabel];
        
        
        
        
        
        
//        self.contentView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
//        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.6*self.frame.size.width)];
//        _goodsImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_goodsImageView];
//        
//        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6 * self.frame.size.width + 10 , self.frame.size.width, 40)];
//        _goodsNameLabel.backgroundColor = [UIColor clearColor];
//        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsNameLabel.font = [UIFont boldSystemFontOfSize:20];
//        [self.contentView addSubview:_goodsNameLabel];
//        
//        _goodsDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6*self.frame.size.width + 40 + 5 , self.frame.size.width, 35)];
//        _goodsDescribeLabel.backgroundColor = [UIColor clearColor];
//        _goodsDescribeLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsDescribeLabel.textColor = [UIColor lightGrayColor];
//        _goodsDescribeLabel.numberOfLines = 2;
//        _goodsDescribeLabel.font = [UIFont  systemFontOfSize:14];
//        [self.contentView addSubview:_goodsDescribeLabel];
//        
//        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.6*self.frame.size.width + 40 + 5 + 35 + 10 , self.frame.size.width, 30)];
//        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
//        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsPriceLabel.textColor = [UIColor orangeColor];
//        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:18];
//        [self.contentView addSubview:_goodsPriceLabel];
        
        
        
        
        
        
        
//        self.contentView.backgroundColor=[UIColor colorWithHexString:@"#ffffff"];
//        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-30, 0.6*(ScreenWidth-20))];
//        _goodsImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_goodsImageView];
//        
//        _goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5 + 0.6*(ScreenWidth-20) + 5 , ScreenWidth-30, 40)];
//        _goodsNameLabel.backgroundColor = [UIColor clearColor];
//        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsNameLabel.font = [UIFont boldSystemFontOfSize:20];
//        [self.contentView addSubview:_goodsNameLabel];
//        
//        _goodsDescribeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5 + 0.6*(ScreenWidth-20) + 40 , ScreenWidth-30, 35)];
//        _goodsDescribeLabel.backgroundColor = [UIColor clearColor];
//        _goodsDescribeLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsDescribeLabel.textColor = [UIColor lightGrayColor];
//        _goodsDescribeLabel.numberOfLines = 2;
//        _goodsDescribeLabel.font = [UIFont  systemFontOfSize:14];
//        [self.contentView addSubview:_goodsDescribeLabel];
//        
//        _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5 + 0.6*(ScreenWidth-20) + 5 + 40 + 35, ScreenWidth-30, 30)];
//        _goodsPriceLabel.backgroundColor = [UIColor clearColor];
//        _goodsPriceLabel.textAlignment = NSTextAlignmentCenter;
//        _goodsPriceLabel.textColor = [UIColor orangeColor];
//        _goodsPriceLabel.font = [UIFont boldSystemFontOfSize:18];
//        [self.contentView addSubview:_goodsPriceLabel];

  
    }
    return self;
}



@end
