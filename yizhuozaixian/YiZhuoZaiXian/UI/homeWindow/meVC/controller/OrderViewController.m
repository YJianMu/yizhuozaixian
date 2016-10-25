//
//  OrderViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//  订单

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderListModel.h"
#import "PendingPaymentOrderDetailsViewController.h"
#import "TransactionClosedOrderDetailsViewController.h"
#import "HasPayController.h"
#import "HasSureOrderController.h"



@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UIActivityIndicatorView * activityIndicator;
}
@property (nonatomic,strong) UITableView *myTableView;

/** 所有订单数据*/
@property (nonatomic,strong) NSMutableArray *orderArray;
@property (nonatomic,strong) OrderListModel *model;
@end

@implementation OrderViewController


-(NSMutableArray *)orderArray{
    if (!_orderArray) {
        _orderArray = [[NSMutableArray alloc]init];
    }
    return _orderArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"deleatOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"sureorder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"refundroder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"detailsureorder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"payRefresh" object:nil];
    [self loadNewData];
    
    [self setTableView];
    
    
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



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleatOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sureorder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refundroder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"detailsureorder" object:nil];
}

-(void)deleatOrder{
    [self loadNewData];
}

- (void)setTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.rowHeight = 120;
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    _myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //添加下拉刷新
    __weak OrderViewController * weakSelf = self;
    [_myTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        [weakSelf loadNewData];
        
    }];

    [self.view addSubview:self.myTableView];
}


- (void)gopay:(NSString *)order_sn{
    NSLog(@"%@",order_sn);
}



- (void)loadNewData{
    
    //[XCDLoadingView createXCDLoadingViewWithSuperView:self.view];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     hud.removeFromSuperViewOnHide = YES;
    
    if ([[EGOCache globalCache] hasCacheForKey:@"orderListData"]) {
        id objc = [[EGOCache globalCache] plistForKey:@"orderListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *array = [OrderListModel setlist:json];
            self.orderArray = [array mutableCopy];
            NSLog(@"%@",self.orderArray);
        }else{
            
        }
        [self.myTableView reloadData];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //设备号
    //NSString *str = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"orderList%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
    
    
    NSLog(@"%@",[[UIDevice currentDevice].identifierForVendor UUIDString]);
    
    __weak OrderViewController * weakself = self;
    [manager POST:OrderListData parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[EGOCache globalCache] setPlist:responseObject forKey:@"orderListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *array = [OrderListModel setlist:json];
            [weakself.orderArray removeAllObjects];
            [weakself.orderArray addObjectsFromArray:array];
            NSLog(@"%@",self.orderArray);
        }else{
            [weakself.orderArray removeAllObjects];
            UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight *0.5, ScreenWidth, 20)];
            textlabel.textAlignment = 1;
            textlabel.text = @"您暂时还没有订单～～";
            textlabel.font = [UIFont systemFontOfSize:14.0];
            [red addSubview:textlabel];
            [weakself.view addSubview:red];
        }
        [weakself.myTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];

        [weakself.myTableView reloadData];
        
        //[XCDLoadingView cancelXCDLoadingView];
        
        [hud hideAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [hud hideAnimated:YES];
        
        //[XCDLoadingView cancelXCDLoadingView];
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        [weakself.myTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        
        NSLog(@"%@",error);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([self numberOfSectionsInTableView:tableView] == section == 0) {
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        whiteView.backgroundColor = [UIColor whiteColor];
        return whiteView;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   //OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView];
    static NSString * ID = @"myCell";
    OrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] firstObject];
        cell.navigationController = self.navigationController;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.ordersModel = self.orderArray[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%@",self.model);
    self.model = self.orderArray[indexPath.section];
    if ([self.model.order_status isEqualToString:@"0"]) {
        PendingPaymentOrderDetailsViewController *vc = [PendingPaymentOrderDetailsViewController new];
        vc.order_sn = self.model.order_sn;
        vc.add_time = self.model.add_time;
        vc.order_id = self.model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([self.model.order_status isEqualToString:@"1"]){
       HasPayController  *vc = [HasPayController new];
        vc.order_sn = self.model.order_sn;
        vc.add_time = self.model.add_time;
        vc.order_id = self.model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.model.order_status isEqualToString:@"2"] || [self.model.order_status isEqualToString:@"4"]||[self.model.order_status isEqualToString:@"5"]){
        TransactionClosedOrderDetailsViewController *vc = [TransactionClosedOrderDetailsViewController new];
        vc.order_sn = self.model.order_sn;
        vc.add_time = self.model.add_time;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.model.order_status isEqualToString:@"3"]){
        HasSureOrderController *vc = [HasSureOrderController new];
        vc.order_sn = self.model.order_sn;
        vc.add_time = self.model.add_time;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
