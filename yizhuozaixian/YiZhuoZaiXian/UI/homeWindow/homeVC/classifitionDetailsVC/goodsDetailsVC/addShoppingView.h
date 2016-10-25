//
//  addShoppingView.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shoppingModel.h"
#import "goodsSizeModel.h"
#import "gooodsDetailsVC.h"
typedef void (^addShoppingBlck)(shoppingModel *,NSString *);

@interface addShoppingView : UIView

@property(nonatomic,copy)addShoppingBlck SizeSelectionBlock;
@property(nonatomic,assign)BOOL addOrNowbuy;

- (UIView *)initWithFrame:(CGRect)frame andWithDataModel:(goodsSizeModel *)goodsModel andImageURL:(NSString *)imageURL andAddshoppingOrNowbuy:(BOOL)addOrNowbuy andDic:(NSDictionary *)dic andMembersBool:(BOOL)membersBool andVC:(gooodsDetailsVC *)goodsVC;
@end
