//
//  invoiceTableViewCell.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/5.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^invoiceBolk)(NSString *,NSString *);

@interface invoiceTableViewCell : UITableViewCell

@property(nonatomic,copy)invoiceBolk invoiceCellBolk;

@end
