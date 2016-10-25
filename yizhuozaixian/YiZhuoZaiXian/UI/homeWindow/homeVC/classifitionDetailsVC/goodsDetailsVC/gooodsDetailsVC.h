//
//  gooodsDetailsVC.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gooodsDetailsVC : UIViewController

@property(nonatomic,strong)NSString * goodsID;
@property(nonatomic,strong)NSString * goodsName;
@property(nonatomic,strong)NSString * goodImage;
@property(nonatomic,strong)NSString * goodsSizeURLstring;
@property(nonatomic,strong)NSString * goodBrief;

//区分是否是由会员专区进入；
@property(nonatomic,assign)BOOL membersBool;

//区分是从购物车或其他界面进入Yes，还是从二级目录进入NO
@property(nonatomic,assign)BOOL shoppingCarInto;
@end
