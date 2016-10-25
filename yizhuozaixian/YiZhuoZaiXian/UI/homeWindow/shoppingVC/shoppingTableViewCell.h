//
//  shoppingTableViewCell.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/14.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingModel.h"
typedef void(^ShoppingCellBlock)(UIButton *,NSString *);

@interface shoppingTableViewCell : UITableViewCell

@property(nonatomic,copy)ShoppingCellBlock shoppingCellBlock;
//@property(nonatomic,copy)ShoppingCellBlock goodsNumberBlock;

-(void)setCellWithShoppingModel:(shoppingModel *)shoppingModel;
@end
