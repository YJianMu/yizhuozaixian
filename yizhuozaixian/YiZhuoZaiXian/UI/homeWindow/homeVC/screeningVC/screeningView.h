//
//  screeningView.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/5/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScreeningViewBlock)(NSDictionary * );

@interface screeningView : UIScrollView

@property (nonatomic,copy)ScreeningViewBlock screeningViewReturnBlock;

- (UIScrollView *)initWithFrame:(CGRect)frame andWithDataModelArr:(NSArray *)dataModelArr;

//dataModelArr
/*

 @[@[@"上装",@[@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"POLO",@"T恤"]],@[@"下装",@[@"牛仔裤",@"休闲裤",@"西裤",@"短裤",@"POLO",@"T恤"]],@[@"女装",@[@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"短袖衬衫"]]]
 
 */

@end
