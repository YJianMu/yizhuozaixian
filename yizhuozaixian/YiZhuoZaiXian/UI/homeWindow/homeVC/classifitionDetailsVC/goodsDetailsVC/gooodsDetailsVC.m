//
//  gooodsDetailsVC.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "gooodsDetailsVC.h"
#import "addShoppingView.h"
#import "goodsSizeModel.h"
#import "getOrderViewController.h"
#import "shoppingCarChange.h"

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

#import "BFShareView.h"


@interface gooodsDetailsVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView * activityIndicator;
}

@property (nonatomic, strong) MPMoviePlayerViewController * moviePlayerViewController;


@property(nonatomic,strong)UIWebView * myWebView;
@property(nonatomic,strong)addShoppingView * addView;
//@property(nonatomic,strong)NSMutableArray * DataArray;
@property(nonatomic,strong)goodsSizeModel * goodsModel;

// 购物车角标
@property(nonatomic,strong)UILabel * iconLabel;

@end

@implementation gooodsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    

    
    [self setData];
    
    [self setNavigation];
    
    [self setWebView];
    
    [self setFooterView];
}
-(void)setData{
    
    AFHTTPRequestOperationManager * goodsManager = [AFHTTPRequestOperationManager manager];
    goodsManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    __weak gooodsDetailsVC * weakSelf = self;
//    NSLog(@"%@",_goodsSizeURLstring);
    [goodsManager GET:_goodsSizeURLstring parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
//        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        weakSelf.goodsModel = [goodsSizeModel setModelWithDictionary:responseObject];
//        NSLog(@"%@",obj);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        
    }];
    
}

-(void)leftItemBttnnClick{
    
    if (_shoppingCarInto) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)rightItemBttnnClick{
    
   UIImageView * imagVii = [[UIImageView alloc]init];
    [imagVii sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_goodsModel.goods_thumb]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@\n下载链接http://www.baidu.com",_goodsModel.brand_name,_goodsModel.goods_name]
                                                 images:image
                                                    url:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",goodsDetailsWebURLstrng,_goodsID]]
                                                  title:@"衣着在线"
                                                   type:SSDKContentTypeAuto];
                //2、分享（可以弹出我们的分享菜单和编辑界面）
                [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                         items:nil
                                   shareParams:shareParams
                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               
                               switch (state) {
                                   case SSDKResponseStateSuccess:
                                   {
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                           message:nil
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"确定"
                                                                                 otherButtonTitles:nil];
                                       [alertView show];
                                       break;
                                   }
                                   case SSDKResponseStateFail:
                                   {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil, nil];
                                       [alert show];
                                       break;
                                   }
                                   default:
                                       break;
                               }
                           }
                 ];}
        
    }];
    
//    BFShareView *share = [BFShareView shareView];
//    NSURL *goodsimage = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_goodsModel.goods_thumb]];
//    
//    share.goodsimage = goodsimage;
//    
//    share.goodsname = [NSString stringWithFormat:@"%@ %@\n下载链接http://www.baidu.com",_goodsModel.brand_name,_goodsModel.goods_name];
//    
//    share.goodsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",goodsDetailsWebURLstrng,_goodsID]];
//    
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    [window addSubview:share];
   
}



-(void)setNavigation{
    
    self.navigationItem.title = _goodsName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttnnClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton * rightItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"details_btn_share_n.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(rightItemBttnnClick)];
    rightItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemBttn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
   
    
     if (_shoppingCarInto) {
         
         UISwipeGestureRecognizer * fanhuiSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(fanhuiSwipe:)];
         [self.view addGestureRecognizer:fanhuiSwipe];
         fanhuiSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        
    }else{
        //全屏右划手势
        //需要获取系统自带滑动手势的target对象
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        //创建全屏滑动手势~调用系统自带滑动手势的target的action方法
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
        //设置手势代理~拦截手势触发
        pan.delegate = self;
        //给导航控制器的view添加全屏滑动手势
        [self.view addGestureRecognizer:pan];
        //将系统自带的滑动手势禁用
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    }


}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
   
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(void)fanhuiSwipe:(UISwipeGestureRecognizer *)swipe{
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


-(void)setFooterView{
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-44, ScreenWidth, 44)];
    footerView.backgroundColor = [UIColor whiteColor];
    footerView.tag = 3000;
    [self.view addSubview:footerView];
    
    footerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:footerView.layer.bounds].CGPath;
    footerView.layer.shadowColor = [UIColor grayColor].CGColor;
    footerView.layer.shadowOpacity = 1.6f;
    footerView.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    footerView.layer.shadowRadius = 1.0;
    
    //购物车
    UIButton * shoppingButton = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 0.25 * ScreenWidth , 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"tab_car_n.png"] andBackgroundImage:[UIImage imageNamed:@"border_gray.png"] andTarget:self andSelector:@selector(shoppingButtonClick)];
    shoppingButton.adjustsImageWhenHighlighted = NO;
    shoppingButton.tag = 4000;
//    shoppingButton.layer.borderColor = UIColor.grayColor.CGColor;
//    shoppingButton.layer.borderWidth = 1;
//    shoppingButton.layer.cornerRadius = 6;
//    shoppingButton.layer.masksToBounds = YES;

    [footerView addSubview:shoppingButton];
    
    //购物车角标
    _iconLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(0.25 * 0.5 * ScreenWidth+10, -8, 26, 18) andBackgroundColor:[UIColor redColor] andText:[NSString stringWithFormat:@"%@",[UserData sharkedUser].iconValer] andTextFont:14 andTextAlignment:NSTextAlignmentCenter];
    _iconLabel.textColor = [UIColor whiteColor];
    _iconLabel.layer.cornerRadius = 9.0;
    _iconLabel.layer.masksToBounds = YES;
    if ([UserData sharkedUser].iconValer == nil||[[UserData sharkedUser].iconValer isEqualToString:@"0"]) {
        [UserData sharkedUser].iconValer = @"0";
        _iconLabel.hidden = YES;
    }else{
        _iconLabel.hidden = NO;
    }

    
    [shoppingButton addSubview:_iconLabel];

    
    
    //加入购物车
    UIButton * addShoppingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addShoppingButton.frame = CGRectMake(10+0.25*ScreenWidth+10, 5, 0.5 * (ScreenWidth-(10+0.25*ScreenWidth+10)-10-10), 34);
    
    addShoppingButton.layer.masksToBounds = YES;
    
    addShoppingButton.layer.cornerRadius = 5.0;
    
    addShoppingButton.layer.borderWidth = 1.0;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    [addShoppingButton.layer setBorderColor:colorref];//边框颜色
    
    [addShoppingButton setTitle:@"加入购物车" forState:UIControlStateNormal];
   
    addShoppingButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [addShoppingButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    addShoppingButton.adjustsImageWhenHighlighted = NO;
    
    [addShoppingButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    addShoppingButton.backgroundColor = [UIColor clearColor];
    
    [addShoppingButton addTarget:self action:@selector(addShoppingButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addShoppingButton];
    
    
    
    //立即购买
    UIButton * nowShoppingButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(10+0.25*ScreenWidth+10+0.5 * (ScreenWidth-(10+0.25*ScreenWidth+10)-10-10)+10, 5, 0.5 * (ScreenWidth-(10+0.25*ScreenWidth+10)-10-10), 34) andBackgroundColor:[UIColor redColor] andText:@"立即购买" andTextColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:18] andTarget:self andSelector:@selector(nowShoppingButtonClick)];
    nowShoppingButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nowShoppingButton.adjustsImageWhenHighlighted = NO;
    nowShoppingButton.layer.cornerRadius = 5.0;
    [nowShoppingButton setBackgroundImage:[UIImage imageNamed:@"border_red.png"] forState:UIControlStateNormal];
    [footerView addSubview:nowShoppingButton];
}

//点击立即购买button方法实现
-(void)nowShoppingButtonClick{
    NSLog(@"333");
    
        if ([_addView class]==nil) {
            
            _addView = [[addShoppingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) andWithDataModel:_goodsModel andImageURL:_goodImage andAddshoppingOrNowbuy:NO andDic:nil andMembersBool:_membersBool andVC:self];
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:0.5];
//            [UIView setAnimationDelegate:self];
//            _addView.frame = CGRectMake(0  ,0, ScreenWidth, ScreenHeight);
//            [UIView commitAnimations];
            
            __weak gooodsDetailsVC * weakSelf = self;
            _addView.SizeSelectionBlock = ^(shoppingModel * shoppModel,NSString * str){
                

                [weakSelf rutureColorAndSizeWithModel:shoppModel andStr:str];
                
            };
            [self.view addSubview:_addView];
        }else{
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:0.5];
//            [UIView setAnimationDelegate:self];
//            _addView.frame = CGRectMake(0  ,2*ScreenHeight, ScreenWidth, ScreenHeight);
//            [UIView commitAnimations];
            _addView.hidden = NO;

            _addView.addOrNowbuy = NO;
        }

    
    
}
//点击加入购物车button方法实现
-(void)addShoppingButtonClick{
    NSLog(@"222");
    NSLog(@"%@",_goodsModel);
    
        if ([_addView class]==nil) {
            
            _addView = [[addShoppingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) andWithDataModel:_goodsModel andImageURL:_goodImage andAddshoppingOrNowbuy:YES andDic:nil andMembersBool:_membersBool andVC:self];
            
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:0.5];
//            [UIView setAnimationDelegate:self];
//            _addView.frame = CGRectMake(0  ,0, ScreenWidth, ScreenHeight);
//            [UIView commitAnimations];
            
            __weak gooodsDetailsVC * weakSelf = self;
            _addView.SizeSelectionBlock = ^(shoppingModel * shoppModel,NSString * str){
                
                
                
                //根据选择完尺码和颜色等返回的数据做出相应处理
                [weakSelf rutureColorAndSizeWithModel:shoppModel andStr:str];
                
            };
            [self.view addSubview:_addView];
        }else{
//            [UIView beginAnimations:@"move" context:nil];
//            [UIView setAnimationDuration:0.5];
//            [UIView setAnimationDelegate:self];
//            _addView.frame = CGRectMake(0 ,2*ScreenHeight, ScreenWidth, ScreenHeight);
//            [UIView commitAnimations];
            _addView.hidden = NO;
            _addView.addOrNowbuy = YES;
        }

    
    

    
    
}
//点击购物车图标方法实现
-(void)shoppingButtonClick{
    NSLog(@"111");
    
    _iconLabel.hidden = YES;
    [UserData sharkedUser].iconValer = @"0";
    
    NSNotification * backshoppingNotification = [NSNotification notificationWithName:@"backshoppingtongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:backshoppingNotification];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}
-(void)setWebView{
    _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-44)];
    _myWebView.backgroundColor = [UIColor lightGrayColor];
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    

    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",goodsDetailsWebURLstrng,_goodsID];
    NSLog(@"%@",urlString);
    NSURLRequest * webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_myWebView loadRequest:webRequest];
    
}
/*
-(void)returnButtonClick{
    
    //    CATransition *animation = [CATransition animation];
    //    animation.duration = 0.25;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    //        animation.type = @"rippleEffect";
    //    animation.type = kCATransitionPush;
    //    animation.subtype = kCATransitionFromLeft;
    //    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    NSLog(@"网页加载失败");
    
    [XCDLoadingView cancelXCDLoadingView];
    
//    [activityIndicator stopAnimating];
//    UIView *view = (UIView*)[self.view viewWithTag:108];
//    [view removeFromSuperview];
}

#pragma mark WebView开始加载
- (void) webViewDidStartLoad:(UIWebView *)webView
{

    [XCDLoadingView createXCDLoadingViewWithSuperView:self.view];
    [self performSelector:@selector(didFinishLoad) withObject:nil afterDelay:4.0];
    
}
#pragma mark WebView加载完成
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [XCDLoadingView cancelXCDLoadingView];
    //延迟执行
//    [self performSelector:@selector(didFinishLoad) withObject:nil afterDelay:0.1];
    
}
-(void)didFinishLoad{
    [XCDLoadingView cancelXCDLoadingView];
//    [activityIndicator stopAnimating];
//    UIView *view = (UIView*)[self.view viewWithTag:108];
//    [view removeFromSuperview];
//    NSLog(@"webViewDidFinishLoad");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


-(void)rutureColorAndSizeWithModel:(shoppingModel *)shoppModel andStr:(NSString *)str{
    
    if ([str isEqualToString:@"shoppingCar"]) {
        
        [self shoppingButtonClick];
        
    }else if ([str isEqualToString:@"nowBuy"]){
        
        getOrderViewController * getOrderVC = [[getOrderViewController alloc]init];
        
        NSMutableArray * marr = [NSMutableArray arrayWithObject:shoppModel];
        NSMutableArray * sectionMarr = [NSMutableArray arrayWithObject:[NSMutableArray arrayWithObjects:_goodsModel.brand_name,@"店铺图标",marr, nil]];
        NSMutableArray * dataMarr = [NSMutableArray arrayWithArray:sectionMarr];
        getOrderVC.goodsOrderMarr = dataMarr;
        getOrderVC.shoppingCarInfo = NO;
        
        [self.navigationController pushViewController:getOrderVC animated:YES];
        
        
    }else{
        
//        //解档购物车模型数组
//        NSData * yuanMarrData = [[NSUserDefaults standardUserDefaults]objectForKey:@"shoppingModelMarrData"];
//        NSMutableArray * yuanMarr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:yuanMarrData]];
//        
//        //追加数组
//        [yuanMarr addObject:shoppModel];
//        
//        //归档
//        NSData * marrData = [NSKeyedArchiver archivedDataWithRootObject:yuanMarr];
//        
//        //存储
//        [[NSUserDefaults standardUserDefaults] setObject:marrData forKey:@"shoppingModelMarrData"];
//        //同步到本地
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
        
        [self performSelector:@selector(yanchi) withObject:nil afterDelay:1.0];
        
        
        //添加商品数据购物车某同步服务

        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            
            NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
            
            [mdic setValue:[UserData sharkedUser].uid forKey:@"uid"];
            [mdic setValue:shoppModel.goods_id forKey:@"goods_id"];
            [mdic setValue:shoppModel.num forKey:@"num"];
            [mdic setValue:shoppModel.color forKey:@"color"];
            [mdic setValue:shoppModel.size forKey:@"size"];
            [mdic setValue:shoppModel.goods_price forKey:@"goods_price"];
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            long long int data = (long long int)a;
            NSString * time = [NSString stringWithFormat:@"%lld", data];
            mdic[@"time"] = time;
            mdic[@"sign"] = [NSString stringWithFormat:@"cart%@%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,shoppModel.color,shoppModel.goods_id,shoppModel.goods_price,shoppModel.num,shoppModel.size].md5String;

            
            
            NSLog(@"%@",mdic);
            
            shoppingCarChange * shoppingChange = [[shoppingCarChange alloc]init];
            
            [shoppingChange addGoodsShoppingCarGoodsWithDic:mdic andURLstr:addGoodsToShoppingCarURLstring];
        });
        

        
        
//        NSLog(@"%@",shoppModel);
//        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:shoppModel,@"shoppModel", nil];
//        
//        NSNotification * addshoppingCarNotification = [NSNotification notificationWithName:@"addshoppingCartongzhi" object:nil userInfo:dic];
//        [[NSNotificationCenter defaultCenter] postNotification:addshoppingCarNotification];
        
    }
    
}
-(void)yanchi{
    
    _iconLabel.text = [UserData sharkedUser].iconValer;
    _iconLabel.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
