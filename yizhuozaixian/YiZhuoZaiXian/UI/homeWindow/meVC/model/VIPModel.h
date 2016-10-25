//
//  VIPModel.h
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/15.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class memberGoods;

@interface VIPModel : NSObject
/** 状态码  */
@property (nonatomic ,copy) NSString *info;
/**  */
@property (nonatomic ,copy) NSString *uid;
/** 积分 */
@property (nonatomic ,copy) NSString *integral;
/** 会员等级 */
@property (nonatomic ,copy) NSString *grade;
/** 升级积分 */
@property (nonatomic ,copy) NSString *grade_scale;
/**  昵称*/
@property (nonatomic ,copy) NSString *nickname;
/** 头像*/
@property (nonatomic ,copy) NSString *avatar;
/**  连续签到天数*/
@property (nonatomic ,copy) NSString *continuous;
/**  签到天数*/
@property (nonatomic ,copy) NSString *days;
/**  签到状态*/
@property (nonatomic ,copy) NSString *sign_status;

/**  */
@property (nonatomic ,strong) NSArray <memberGoods *> *memberGoods;


@end

@interface memberGoods : NSObject

/**  */
@property (nonatomic ,copy) NSString *fileName;
/**  */
@property (nonatomic ,copy) NSString *goods_id;
/**  */
@property (nonatomic ,copy) NSString *goods_name;
/**  */
@property (nonatomic ,copy) NSString *goods_thumb;
/**  */
@property (nonatomic ,copy) NSString *grade;
/**  */
@property (nonatomic ,copy) NSString *member_price;
/**  */
@property (nonatomic ,copy) NSString *shop_price;

@end

