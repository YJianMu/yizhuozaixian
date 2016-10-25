

#import "PayHelper.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
#import "DataSigner.h"
#import "PartnerConfig.h"
#import <AlipaySDK/AlipaySDK.h>


@implementation PayHelper

+(void)sendWechatPay:(WxProduct *)product{
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID privateKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo:product];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
//        [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
    
    
}


/*
 *****************拷贝此方法放入到AppDelegate当中************
 
 //微信支付完成后的回调
 -(void) onResp:(BaseResp*)resp
 {
 NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
 NSString *strTitle;
 
 if([resp isKindOfClass:[SendMessageToWXResp class]])
 {
 strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
 }
 if([resp isKindOfClass:[PayResp class]]){
 //支付返回结果，实际支付结果需要去微信服务器端查询
 strTitle = [NSString stringWithFormat:@"支付结果"];
 
 switch (resp.errCode) {
 case WXSuccess:
 strMsg = @"支付结果：成功！";
 NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
 break;
 
 default:
 strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
 NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
 break;
 }
 }
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 }
 
 */



+(void)sendAlipay:(Order *)product{
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    //商户的ID
    order.partner = PartnerID;
    //商户的账号
    order.seller = SellerID;
    order.tradeNO = product.tradeNO;       //订单ID（由商家自行制定）
    order.productName = product.productName;          //商品标题
    order.productDescription = product.productDescription;      //商品描述
    order.amount = product.amount; //商品价格
    
    order.notifyURL =  @"http://www.baidu.com";     //我们服务器的回调地址,支付宝服务器会通过post请求，给我们服务器发送支付信息
    
    order.service = @"mobile.securitypay.pay";    //支付宝服务器的地址
    order.paymentType = @"1";                     // 商品支付填“1”
    order.inputCharset = @"utf-8";                // utf-8 （%1A%2f  NSUTF8encodeXXXX 边个格式
    order.itBPay = @"30m";                        // 30分钟内支付
    order.showUrl = @"m.alipay.com";              // 没有支付宝钱包时跳出的页面
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"YiZhuoZaiXianAppScheme";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        NSLog(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
        
    }
    
}

/*

*****************拷贝此方法放入到AppDelegate当中************

//支付宝客户端支付回调
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:resultDic[@"memo"] message:resultDic[@"resultStatus"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:resultDic[@"memo"] message:resultDic[@"resultStatus"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    
    //如果包含微信支付使用如下返回函数
    // return [WXApi handleOpenURL:url delegate:self];
    //否则
    return YES;
}

*/

@end
