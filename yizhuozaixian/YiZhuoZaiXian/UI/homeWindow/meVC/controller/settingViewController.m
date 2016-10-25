//
//  settingViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/15.
//  Copyright © 2016年 xincedong. All rights reserved.
//  设置点击后的控制器

#import "settingViewController.h"
#import "profileViewController.h"
#import "suggestionViewController.h"
#import "changepasswordViewController.h"
#import "ClearCache.h"
#import "CheckinViewController.h"
#import "SDImageCache.h"
#import "ServiceDelegateViewController.h"
#import "AboutusViewController.h"


@class CheckinViewController;

@interface settingViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView *settingTableView;
    
    NSArray *topLable;
    
}
@property (nonatomic,strong) NSArray *viewControllerNameArray;
@property (nonatomic,strong) NSArray *labledata;
@property (nonatomic,strong) UIView *getoutView;
@property (nonatomic,strong) UIButton *checkoutButton;
@property (nonatomic,strong) UserData *userInfo;
@property (nonatomic,strong) NSArray *imageNameArray;

@end


@implementation settingViewController

-(NSArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = @[@[@"set_icon_person_n",@"set_icon_password_n"],@[@"set_icon_opinion_n",@"set_icon_us_n",@"set_icon_deal_n",@"set_icon_clear_n"]];
        
    }
    return _imageNameArray;
}

- (UserData *)userInfo{
    if (!_userInfo) {
        _userInfo = [UserData sharkedUser];
    }
    return _userInfo;
}


-(NSArray *)labledata{
    if (!_labledata) {
        _labledata = @[@[@"个人资料",@"修改密码"],@[@"意见反馈",@"关于我们",@"服务协议",@"清除缓存"]];
    }
    return _labledata;
}


-(NSArray *)viewControllerNameArray{
    if (!_viewControllerNameArray) {
        _viewControllerNameArray = @[@[@"profileViewController",@"changepasswordViewController"],@[@"suggestionViewController",@"AboutusViewController",@"ServiceDelegateViewController",@"profileViewController"]];
    }
    return _viewControllerNameArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:settingTableView];
    settingTableView.delegate= self;
    settingTableView.dataSource = self;
    settingTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    settingTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    topLable = @[@"个人设置",@"系统设置"];

    
    
    _getoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    _checkoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkoutButton.frame = CGRectMake((ScreenWidth - 200)/2 , 20, 200, 40);
    _checkoutButton.backgroundColor = [UIColor redColor];
    _checkoutButton.layer.cornerRadius = 10.0;
//    _checkoutButton.layer.borderWidth = 2.0;
    [_checkoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_checkoutButton addTarget:self action:@selector(clickcheckoutButton:) forControlEvents:UIControlEventTouchUpInside];
    [_getoutView addSubview:_checkoutButton];
    settingTableView.tableFooterView = self.getoutView;
    
    
    
    
    
    
    
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
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(dismissLeft)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


- (void)clickcheckoutButton:(UIButton *)sender{
    
    NSLog(@"%@",[UserData sharkedUser].uid);
    
    if ([UserData sharkedUser].uid != nil) {
        __weak settingViewController *weakself = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil     message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *phone = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakself.navigationController popToRootViewControllerAnimated:NO];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            long long int data = (long long int)a;
            NSString * time = [NSString stringWithFormat:@"%lld", data];
            NSString * sign = [NSString stringWithFormat:@"cancel%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
            NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
            [mdic setObject:[UserData sharkedUser].uid forKey:@"uid"];
            [mdic setObject:time forKey:@"time"];
            [mdic setObject:sign forKey:@"sign"];
            NSLog(@"%@",mdic);
            [manager POST:canceluidurl parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if ([json[@"info"] isEqualToString:@"u019"]) {
                    [UserData sharkedUser].uid = nil;
                    [UserData saveData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHECKOUT" object:nil userInfo:nil];
                }
                NSLog(@"%@",json);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];

  }];
        
        [alertC addAction:cancleAction];
        [alertC addAction:phone];
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        sender.selected = NO;
        NSLog(@"1111111111");
    }
    
    NSLog(@"点击了退出按钮");
}



#pragma --------tableViewDelegate-------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return self.labledata.count;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.labledata[section];
    return array.count;
}

//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 34;
}


//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}
//每一个分组下对应的tableview 高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *lable = [[UILabel alloc] init];
//    lable.text = topLable[section];
//    return lable;
//    
//    
//}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //我们设分区标题，不设分区标尾
    return topLable[section];
}


//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    
    if ([self.labledata[indexPath.section][indexPath.row] isEqualToString:@"清除缓存"]) {

     CGFloat size =[SDImageCache sharedImageCache].getSize / 1000.0 / 1000;
        
//        CGFloat size = [ClearCache folderSizeAtPath:[ClearCache getCachesPath]];
        cell.textLabel.text = self.labledata[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMB",size];
        
    }else{
        cell.textLabel.text = self.labledata[indexPath.section][indexPath.row];
    }

    cell.imageView.image = [UIImage imageNamed:self.imageNameArray[indexPath.section][indexPath.row]];
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *className = self.viewControllerNameArray[indexPath.section][indexPath.row];
    Class someClass = NSClassFromString(className);
    UIViewController *viewController = [[someClass alloc]init];
    viewController.title = self.labledata[indexPath.section][indexPath.row];
    if ([self.labledata[indexPath.section][indexPath.row] isEqualToString:@"个人资料"]) {
        if (self.userInfo.uid == nil) {
           [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];        }else{
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else if ([self.labledata[indexPath.section][indexPath.row] isEqualToString:@"修改密码"]) {
        if (self.userInfo.uid == nil) {
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
        }else{
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    
   else if ([self.labledata[indexPath.section][indexPath.row] isEqualToString:@"清除缓存"]) {
       
       
       [[SDImageCache sharedImageCache] clearDisk];
       
//        [ClearCache clear:[ClearCache getCachesPath]];
//         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
       
        //[settingTableView reloadData];

//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSLog(@"%@",paths);
   }
   else{
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
