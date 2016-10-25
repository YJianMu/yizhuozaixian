//
//  NogoodsController.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/13.
//  Copyright © 2016年 xincedong. All rights reserved.
//   待收货

#import "NogoodsController.h"
#import "OrderTableViewCell.h"
#import "HasPayController.h"
#import "NoGoodsModel.h"

@interface NogoodsController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
/** 所有订单数据*/
@property (nonatomic,strong) NSMutableArray *nogoodsArray;
@property (nonatomic,strong) NoGoodsModel *model;
@end


@implementation NogoodsController
- (NSMutableArray *)nogoodsArray{
    if (!_nogoodsArray) {
        _nogoodsArray = [[NSMutableArray alloc]init];
    }
    return _nogoodsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadNewData];
    
    [self setTableView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"sureorder" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"refundroder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleatOrder) name:@"detailsureorder" object:nil];
    
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
    _myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    //添加下拉刷新
    __weak NogoodsController * weakSelf = self;
    [_myTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        [weakSelf loadNewData];
        
    }];
    [self.view addSubview:self.myTableView];
}

//- (void)gopay:(NSString *)order_sn{
//    NSLog(@"%@",order_sn);
//}


- (void)loadNewData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    if ([[EGOCache globalCache] hasCacheForKey:@"nogoodsListData"]) {
        
        id objc = [[EGOCache globalCache] plistForKey:@"nogoodsListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            
            NSArray *array = [NoGoodsModel setlist:json];
            [self.nogoodsArray removeAllObjects];
            [self.nogoodsArray addObjectsFromArray:array];
            NSLog(@"%@",self.nogoodsArray);
        }
        [self.myTableView reloadData];
        
}
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    
    
    [param setObject:[UserData sharkedUser].uid forKey:@"uid"];
    param[@"time"] = time;
    param[@"sign"] = [NSString stringWithFormat:@"orderList%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
    
    
    
    __weak NogoodsController * weakself = self;
    [manager POST:OrderListData parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakself.myTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
        [[EGOCache globalCache] setPlist:responseObject forKey:@"nogoodsListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",json);
        if ([json isKindOfClass:[NSArray class]]) {
            
            NSArray *array = [NoGoodsModel setlist:json];
            [weakself.nogoodsArray removeAllObjects];
            [weakself.nogoodsArray addObjectsFromArray:array];
            NSLog(@"%@",self.nogoodsArray);
        }
        if (weakself.nogoodsArray.count == 0) {
            [weakself.nogoodsArray removeAllObjects];
            UIView *red = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight *0.5, ScreenWidth, 20)];
            textlabel.textAlignment = 1;
            textlabel.text = @"您暂时还没有待收货订单～～";
            textlabel.font = [UIFont systemFontOfSize:14.0];
            [red addSubview:textlabel];
            [weakself.view addSubview:red];
        }
        [self.myTableView reloadData];
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
    return self.nogoodsArray.count;
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
        cell.nogoodsmodel = self.nogoodsArray[indexPath.section];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.model = self.nogoodsArray[indexPath.section];
    HasPayController *vc = [HasPayController new];
    vc.order_sn = self.model.order_sn;
    vc.add_time = self.model.add_time;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
