//
//  meViewController.m
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import "meViewController.h"
#import "settingViewController.h"
#import "profileViewController.h"
#import "ServiceViewController.h"
#import "RefundViewController.h"
#import "NopayViewController.h"
#import "CheckinViewController.h"
#import "VipViewController.h"
#import "CardsViewController.h"
#import "OrderViewController.h"
#import "profileViewController.h"
#import "UserInfoModel.h"
#import "UIButton+WebCache.h"
#import "headerView.h"
#import "NogoodsController.h"
#import "PaidViewController.h"

@interface meViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *personTableView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *viewControllerNameArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UserData *userInfo;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *checkinButton;
@property (nonatomic, strong) UIButton *nopayButton;
@property (nonatomic, strong) UIButton *refundButton;
@property (nonatomic, strong) NSArray *imageNameArray;
@end

@implementation meViewController

-(NSArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = @[@[@"personal_icon_order_n",@"personal_icon_vip_n",@"personal_icon_coupon_n"],@[@"personal_icon_service_n",@"personal_icon_set_n"]];
    }
    return _imageNameArray;
}

-(UserData *)userInfo{
    if (!_userInfo) {
        _userInfo = [UserData sharkedUser];
    }
    return _userInfo;
}


- (NSArray *)viewControllerNameArray{
    if (!_viewControllerNameArray) {
        _viewControllerNameArray = @[@[@"OrderViewController",@"VipViewController",@"CardsViewController"],@[@"ServiceViewController",@"settingViewController"]];
    }
    return _viewControllerNameArray;
}



- (NSArray *)nameArray{
    if (!_nameArray) {
        _nameArray = @[@[@"我的订单",@"会员中心",@"我的卡券"],@[@"客服中心",@"设置"]];
    }
    return _nameArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[[UIDevice currentDevice].identifierForVendor UUIDString]);

    self.navigationItem.title = @"个人中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadNewData];
    [self setTableView];
    
    //self.personTableView.tableHeaderView = self.headerView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"USER_UID" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changename) name:@"CHANGENAME" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkout) name:@"CHECKOUT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sexDidChange) name:@"sexDidChange" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icondidchange) name:@"icondidchange" object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USER_UID" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHANGENAME" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHECKOUT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sexDidChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"icondidchange" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.userInfo.uid == nil) {
        [self.iconButton setBackgroundImage:[UIImage imageNamed:@"personal_icon_head_n"] forState:UIControlStateNormal];
        [self.checkinButton setTitle:@"登录／注册" forState:UIControlStateNormal];
        [self.personTableView reloadData];
    }
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)checkout{
    [self.iconButton setBackgroundImage:[UIImage imageNamed:@"personal_icon_head_n"] forState:UIControlStateNormal];
    [self.checkinButton setTitle:@"登录／注册" forState:UIControlStateNormal];
    [self.personTableView reloadData];
}

- (void)login:(NSNotification*)notification{
    NSLog(@"%@",notification.userInfo[@"uid"]);
    //登录后获取用户信息  更新界面
    NSLog(@"++++++%@++++++",[UserData sharkedUser].uid);
    [self loadNewData];
}



- (void)icondidchange{
    
    [self loadNewData];
}
- (void)changename{
    
    [self loadNewData];
}

- (void)sexDidChange{
    
    [self loadNewData];
}


- (void)loadNewData{
    
    if ([UserData sharkedUser].uid == nil) {
        
    }else{
    
        
        __weak meViewController *weakself = self;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        NSLog(@"%@",time);
        NSString * sign = [NSString stringWithFormat:@"user%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;

        NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
        [mdic setObject:[UserData sharkedUser].uid forKey:@"uid"];
        [mdic setObject:sign forKey:@"sign"];
        [mdic setObject:time forKey:@"time"];
        
        [manager POST:UserDataURLString parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",json);
            NSLog(@"%@",self.userInfo.uid);
            
            if ([json[@"info"] isEqualToString:@"u019"]) {
                [UserData sharkedUser].uid = nil;
                [UserData saveData];
                [weakself presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
            }
            
            UserInfoModel *userinfo = [UserInfoModel objectWithKeyValues:json];
            
            weakself.userInfo.imgUrl = userinfo.userData[@"avatar"];
            if ([userinfo.userData[@"sex"] isEqualToString:@"0"]) {
                weakself.userInfo.gender = @"男";
                [UserData saveData];
            }else if([userinfo.userData[@"sex"] isEqualToString:@"1"]){
                weakself.userInfo.gender = @"女";
                [UserData saveData];
            }
            
            weakself.userInfo.nickname = userinfo.userData[@"nickname"];
            
            [UserData saveData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakself.iconButton sd_setBackgroundImageWithURL:userinfo.userData[@"avatar"] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [[EGOCache globalCache] setImage:image forKey:@"iconImage"];
                    
                }];
                
                [weakself.checkinButton setTitle:userinfo.userData[@"nickname"] forState:UIControlStateNormal];
                [weakself.personTableView reloadData];
                
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
            NSLog(@"%@",error);
        }];

    
    }
}




- (UIView *)headerView{
   
    UIView *headerview = [[headerView alloc] initWithFrame:CGRectMake(0, -200, ScreenWidth, 200)];
   
    
    UIButton *iconButton = [UIButton new];
    iconButton.frame = CGRectMake((ScreenWidth - 80)/2 , 30, 80, 80);
    
    iconButton.layer.cornerRadius = 40.0;
    if (self.userInfo.uid == nil) {
        [iconButton setBackgroundImage:[UIImage imageNamed:@"personal_icon_head_n"] forState:UIControlStateNormal];
    }else{
        [iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.userInfo.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"personal_icon_head_n"]];
    }

    iconButton.layer.masksToBounds = YES;
    self.iconButton = iconButton;
    
    [iconButton addTarget:self action:@selector(clickiconButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkinButton.frame = CGRectMake((ScreenWidth - 200)/2 , 30 + 80 + 5, 200, 30);
    checkinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //checkinButton.titleLabel.textColor = [UIColor whiteColor];
    //[checkinButton setBackgroundImage:[UIImage  imageNamed:@"personal_but_login_n"] forState:UIControlStateNormal];
    checkinButton.layer.cornerRadius = 15.0;
    checkinButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [checkinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.userInfo.uid == nil) {
        [checkinButton setTitle:@"登录／注册" forState:UIControlStateNormal];
    }else{
       [checkinButton setTitle:self.userInfo.nickname forState:UIControlStateNormal];
    }
    
    self.checkinButton = checkinButton;
    
    [checkinButton addTarget:self action:@selector(clickcheckinButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3 *2 - 1, 170, 2, 20)];
    redView.backgroundColor = [UIColor whiteColor];
    redView.alpha = 0.6;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3-1, 170, 2, 20)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.6;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, ScreenWidth, 40)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.2;
    
    
    UIButton *nopayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nopayButton.frame = CGRectMake(0, 160, ScreenWidth / 3, 40);
    nopayButton.backgroundColor = [UIColor clearColor];
    [nopayButton setTitle:@"待付款" forState:UIControlStateNormal];

    nopayButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [nopayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nopayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [nopayButton setImage:[UIImage imageNamed:@"personal_icon_payment_n"] forState:UIControlStateNormal];
    [nopayButton addTarget:self action:@selector(clicknopayButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nogoods = [UIButton buttonWithType:UIButtonTypeCustom];
    nogoods.frame = CGRectMake(ScreenWidth / 3, 160, ScreenWidth / 3, 40);
    nogoods.backgroundColor = [UIColor clearColor];
    [nogoods setTitle:@"待收货" forState:UIControlStateNormal];
    nogoods.titleLabel.font = [UIFont systemFontOfSize:16.0];
    nogoods.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [nogoods setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nogoods setImage:[UIImage imageNamed:@"personal_icon_stay_n"] forState:UIControlStateNormal];
    [nogoods addTarget:self action:@selector(clicknogoods) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refundButton.frame = CGRectMake(ScreenWidth / 3 * 2, 160, ScreenWidth / 3, 40);
    refundButton.backgroundColor = [UIColor clearColor];
    [refundButton setTitle:@"退款" forState:UIControlStateNormal];
    refundButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    refundButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [refundButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refundButton setImage:[UIImage imageNamed:@"personal_icon_refund_n"] forState:UIControlStateNormal];
    [refundButton addTarget:self action:@selector(clickrefundButton) forControlEvents:UIControlEventTouchUpInside];
    [headerview addSubview:blackView];
    [headerview addSubview:nopayButton];
    [headerview addSubview:refundButton];
    [headerview addSubview:redView];
    [headerview addSubview:whiteView];
    [headerview addSubview:nogoods];
    [headerview addSubview:iconButton];
    [headerview addSubview:checkinButton];
    
    return headerview;
}

//点击了头像按钮
- (void)clickiconButton{
    if (self.userInfo.uid == nil) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:[profileViewController new] animated:YES];
}
}

//点击了登录按钮
- (void)clickcheckinButton{
    if (self.userInfo.uid == nil) {
        
       
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
    }else{
        [self.navigationController pushViewController:[profileViewController new] animated:YES];
    }
    NSLog(@"点击了登录按钮");
}

-(void)clicknogoods{
    if (self.userInfo.uid == nil) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
        
        NSLog(@"点击了待付款按钮");
    }else{
        
        NogoodsController *nopay = [NogoodsController new];
        
        [self.navigationController pushViewController:nopay animated:YES];
        nopay.title = @"待收货";
        
    }
}


//点击了待付款按钮
- (void)clicknopayButton{
    if (self.userInfo.uid == nil) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
        
        NSLog(@"点击了待付款按钮");
    }else{
        
        NopayViewController *nopay = [NopayViewController new];
        
    [self.navigationController pushViewController:nopay animated:YES];
        nopay.title = @"待付款";

    }
}

//点击了退款按钮
- (void)clickrefundButton{
    if (self.userInfo.uid == nil) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
    }else{
        
      PaidViewController *paid = [PaidViewController new];
    [self.navigationController pushViewController:paid animated:YES];
    paid.title = @"退款";
    }
}


- (void)setTableView{
    self.personTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    
    self.personTableView.dataSource = self;
    self.personTableView.delegate = self;
    self.personTableView.showsVerticalScrollIndicator = NO;
    self.personTableView.tableHeaderView = [self headerView];

    
    
    [self.view addSubview:self.personTableView];
    
}

#pragma ---tableView协议---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewControllerNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.viewControllerNameArray[section];
    return array.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }

    cell.imageView.image = [UIImage imageNamed:self.imageNameArray[indexPath.section][indexPath.row]];
    cell.textLabel.text = self.nameArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className = self.viewControllerNameArray[indexPath.section][indexPath.row];
    Class someClass = NSClassFromString(className);
    UIViewController *viewController = [[someClass alloc]init];
    viewController.title = self.nameArray[indexPath.section][indexPath.row];
    
    
    
    if ([self.nameArray[indexPath.section][indexPath.row] isEqualToString:@"我的订单"])
    {
        if (self.userInfo.uid == nil) {
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
        }else{
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else if ([self.nameArray[indexPath.section][indexPath.row] isEqualToString:@"会员中心"])
        {
            if (self.userInfo.uid == nil) {
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
            }else{
                [self.navigationController pushViewController:viewController animated:YES];
            }
    }
    else if ([self.nameArray[indexPath.section][indexPath.row] isEqualToString:@"我的卡券"])
    {
        if (self.userInfo.uid == nil) {
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
        }else{
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else if ([self.nameArray[indexPath.section][indexPath.row] isEqualToString:@"客服中心"]){
        __weak meViewController *weakself = self;
        self.view.backgroundColor = [UIColor whiteColor];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"客服电话:\n020-84386606" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *phone = [UIAlertAction actionWithTitle:@"拨号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *str = [NSString stringWithFormat:@"tel:%@",@"//020-84386606"];
            
            UIWebView *callWebView = [[UIWebView alloc]init];
            
            [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [weakself.view addSubview:callWebView];
        }];
        
        [alertC addAction:cancleAction];
        [alertC addAction:phone];
        
        [self presentViewController:alertC animated:YES completion:nil];
    }
    else{
       [self.navigationController pushViewController:viewController animated:YES];
    }
    
 }




@end
