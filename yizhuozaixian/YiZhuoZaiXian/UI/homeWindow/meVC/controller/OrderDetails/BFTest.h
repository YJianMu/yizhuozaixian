//
//  BFTest.h
//  缤微纷购
//
//  Created by 程召华 on 16/4/8.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GoodsList;
@interface BFTest : NSObject
/**  */
@property (nonatomic, strong) NSString *order_id;
/**  */
@property (nonatomic, strong) NSString *brand_id;
/**订单号  */
@property (nonatomic, strong) NSString *order_sn;
/**  */
@property (nonatomic, strong) NSString *consignee;
/**手机号  */
@property (nonatomic, strong) NSString *mobile;
/**收获地址  */
@property (nonatomic, strong) NSString *address;
/**  */
@property (nonatomic, strong) NSString *express_id;
/** 品牌名称 */
@property (nonatomic, strong) NSString *brand_name;
/** 客服电话 */
@property (nonatomic, strong) NSString *brand_tel;
/** 总价 */
@property (nonatomic, strong) NSString *total_prices;
/** 订单状态 */
@property (nonatomic, strong) NSString *leave_message;
/** 留言 */
@property (nonatomic, strong) NSString *order_status;
/**快递方式*/
@property (nonatomic, strong) NSString *express_name;
/**货运号*/
@property (nonatomic, strong) NSString *express_sn;
/**  */
@property (nonatomic, strong) NSArray<GoodsList *> *orderGoods;
@end

@interface GoodsList : NSObject
/**  */
@property (nonatomic, strong) NSString *order_goods_id;
/**  */
@property (nonatomic, strong) NSString *order_id;
/**  */
@property (nonatomic, strong) NSString *goods_id;
/**  */
@property (nonatomic, strong) NSString *goods_name;
/**  */
@property (nonatomic, strong) NSString *num;
/**  */
@property (nonatomic, strong) NSString *goods_price;
/**  */
@property (nonatomic, strong) NSString *goods_attr;
/**  */
@property (nonatomic, strong) NSString *goods_small_img;
@end