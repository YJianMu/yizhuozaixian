//
//  BFShareView.h
//  缤微纷购
//
//  Created by 程召华 on 16/3/12.
//  Copyright © 2016年 xinxincao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BFShareButtonTypeMoments,//微信朋友圈
    BFShareButtonTypeQQZone,//QQ空间
    BFShareButtonTypeQQFriends,//QQ好友
    BFShareButtonTypeWeChatCollect,//微信收藏
    BFShareButtonTypeWechatFriends//微信好友
}BFShareButtonType;




@interface BFShareView : UIView

@property (nonatomic,strong) NSURL *goodsimage;
@property (nonatomic,strong) NSURL *goodsurl;
@property (nonatomic,strong) NSString *goodsname;
+ (instancetype)shareView;

@end


