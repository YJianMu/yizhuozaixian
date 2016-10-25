//
//  PaidViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "PaidViewController.h"
#import "paidmodel.h"
#import "TransactionClosedOrderDetailsViewController.h"
#import "OrderTableViewCell.h"

@interface PaidViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
/** 所有订单数据*/
@property (nonatomic,strong) NSMutableArray *paidsArray;
@property (nonatomic,strong) paidmodel *model;
@end


@implementation PaidViewController
- (NSMutableArray *)paidsArray{
    if (!_paidsArray) {
        _paidsArray = [[NSMutableArray alloc]init];
    }
    return _paidsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
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



- (void)setTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.rowHeight = 120;
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];

    _myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //添加下拉刷新
    __weak PaidViewController * weakSelf = self;
    [_myTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        [weakSelf loadNewData];
        
    }];
    [self.view addSubview:self.myTableView];
}


- (void)loadNewData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    if ([[EGOCache globalCache] hasCacheForKey:@"paidsListData"]) {
        
        id objc = [[EGOCache globalCache] plistForKey:@"paidsListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            
            NSArray *array = [paidmodel setlist:json];
            [self.paidsArray removeAllObjects];
            [self.paidsArray addObjectsFromArray:array];
            NSLog(@"%@",self.paidsArray);
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
    
    
    __weak PaidViewController * weakself = self;
    [manager POST:OrderListData parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakself.myTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
        [[EGOCache globalCache] setPlist:responseObject forKey:@"paidsListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *array = [paidmodel setlist:json];
            [weakself.paidsArray removeAllObjects];
            [weakself.paidsArray addObjectsFromArray:array];
            
        }
        if (weakself.paidsArray.count == 0) {
            [weakself.paidsArray removeAllObjects];
            UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight *0.5, ScreenWidth, 20)];
            textlabel.textAlignment = 1;
            textlabel.text = @"您暂时还没有退款订单～～";
            textlabel.font = [UIFont systemFontOfSize:14.0];
            [red addSubview:textlabel];
            [weakself.view addSubview:red];
        }
        
        
       [weakself.myTableView reloadData];
        [hud hideAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideAnimated:YES];
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        [weakself.myTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        NSLog(@"%@",error);
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.paidsArray.count;
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
        cell.paidmodel = self.paidsArray[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.model = self.paidsArray[indexPath.section];
    TransactionClosedOrderDetailsViewController *vc = [TransactionClosedOrderDetailsViewController new];
    vc.order_sn = self.model.order_sn;
    vc.add_time = self.model.add_time;
    [self.navigationController pushViewController:vc animated:YES];
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
