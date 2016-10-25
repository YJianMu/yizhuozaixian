

#import <Foundation/Foundation.h>
#import "WxProduct.h"
#import "Order.h"

@interface PayHelper : NSObject

//发起微信支付
+(void)sendWechatPay:(WxProduct *)product;

//发起支付宝支付
+(void)sendAlipay:(Order *)product;
@end
