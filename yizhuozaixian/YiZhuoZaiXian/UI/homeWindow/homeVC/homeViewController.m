//
//  homeViewController.m
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import "homeViewController.h"
#import "ScrollViewDemo.h"
#import "homeTableViewCell.h"
#import "classifitionDetailViewController.h"
#import "homeModel.h"
#import "homeAdModel.h"
#import "screeningViewController.h"

@interface homeViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * DataArrary;
@property(nonatomic,strong)NSString * className;
@property(nonatomic,strong)NSMutableArray * homeScrollViewArr;

@property(nonatomic,strong)NSTimer * timer;
@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNavigation];
    
    
    [self setData];
    
    //判断是否登录有效
    [self JudgeLoginYesAndNo];
    
    [self setTableView];
    
    
    
    [self setFlotationBall];
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)setFlotationBall{
    
    UIButton * flotationBallBut = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(30,ScreenHeight - 64 - 49 - 60 - 30, 60, 60) andBackgroundColor:[UIColor colorWithHexString:@"#ff1800"] andText:@"浮空球" andTextColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:14] andTarget:self andSelector:@selector(flotationBallButClick:)];
    flotationBallBut.tag = 10014;
    
    UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(flotationBallButSliding:)];
    [flotationBallBut addGestureRecognizer:panGes];
    
//    flotationBallBut.layer.borderColor = UIColor.blackColor.CGColor;
//    flotationBallBut.layer.borderWidth = 1;
    flotationBallBut.layer.cornerRadius = 30;
    flotationBallBut.layer.masksToBounds = YES;
    
    flotationBallBut.layer.shadowPath = [UIBezierPath bezierPathWithRect:flotationBallBut.layer.bounds].CGPath;
    flotationBallBut.layer.shadowColor = [UIColor redColor].CGColor;
    flotationBallBut.layer.shadowOpacity = 1.0f;
    flotationBallBut.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    flotationBallBut.layer.shadowRadius = 1.0;

    
    [self.view addSubview: flotationBallBut];
    [self.view bringSubviewToFront:flotationBallBut];
    
    //注册监听button的enabled状态
    [flotationBallBut addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
//    [self performSelector:@selector(flotationBallButAlphaNO) withObject:nil afterDelay:3.0];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flotationBallButAlphaNO) userInfo:nil repeats:NO];
}

//添加监听观察者
/**
 *  监听按钮状态改变的方法
 *
 *  @param keyPath 按钮改变的属性
 *  @param object  按钮
 *  @param change  改变后的数据
 *  @param context 注册监听时context传递过来的值
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIButton *button = (UIButton *)object;
    UIButton * flotationBallBut = [self.view viewWithTag:10014];
//    NSLog(@"%@",change);
    if (flotationBallBut == button && [@"alpha" isEqualToString:keyPath]) {
        
        if ([change[@"new"] floatValue] == 1) {
            
//            [self performSelector:@selector(flotationBallButAlphaNO) withObject:nil afterDelay:3.0];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flotationBallButAlphaNO) userInfo:nil repeats:NO];
            
            
        }else{
            [_timer invalidate];
        }
        
    }
}

-(void)flotationBallButClick:(UIButton *)button{
    NSLog(@"点击了浮空球");
    [UIView animateWithDuration:0.5 animations:^{
        button.alpha = 1.0;
    }];
    
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:[screeningViewController new]];
    
    nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    
    [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:nvc animated:YES completion:nil];
        
    
    
}

-(void)flotationBallButSliding:(UIPanGestureRecognizer *)panGes{
    
    UIButton * flotationBallBut = [self.view viewWithTag:10014];
    
    flotationBallBut.alpha = 1.0;

    CGPoint point = [panGes translationInView:flotationBallBut];
//    NSLog(@"%f,%f",point.x,point.y);
//    NSLog(@"%.1f,%.1f",panGes.view.center.x,panGes.view.center.y);
    CGPoint panGesNew = CGPointMake(panGes.view.center.x + point.x, panGes.view.center.y + point.y);
    if (0 <= panGesNew.x && panGesNew.x <= ScreenWidth-0 && 0 <= panGesNew.y && panGesNew.y <= ScreenHeight - 64 - 49 + 0) {
       
        
    }else{
        
        if ( 0 > panGesNew.x ) {
            
            panGesNew.x = 0;
        }
        
        if (panGesNew.x > ScreenWidth-0) {
           
            panGesNew.x = ScreenWidth-0;
        }
        
        if ( 0 > panGesNew.y ) {
            
            panGesNew.y = 0;
        }
        
        if ( panGesNew.y > ScreenHeight - 64 - 49 + 0 ) {
            
            panGesNew.y = ScreenHeight - 64 - 49 + 0;
        }
    }
    
    
    panGes.view.center = panGesNew;
    
    [panGes setTranslation:CGPointMake(0, 0) inView:flotationBallBut];

    

    
}
-(void)setData{
    if ([[EGOCache globalCache] hasCacheForKey:@"homeVCData"]) {
    
        id cachdata = [[EGOCache globalCache] plistForKey:@"homeVCData"];
        NSArray * objc  = [NSJSONSerialization JSONObjectWithData:cachdata options:0 error:nil];
        _DataArrary = [homeModel setModelWithDictionary:objc];
        
        [_myTableView reloadData];

    }

    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak homeViewController * weakSelf = self;
    [manger GET:homeURLstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[EGOCache globalCache] setPlist:[responseObject copy] forKey:@"homeVCData"];
        NSLog(@"%@",responseObject);
        NSArray * objc  = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil] ;
        NSLog(@"%@",objc);
//        [ZJModelTool createModelWithDictionary:objc[0][@"goodList"][0] modelName:@"homeVCData"];
        
        weakSelf.DataArrary = [homeModel setModelWithDictionary:objc];
        
        [weakSelf.myTableView reloadData];
        
        //刷新结束
//        [weakSelf.myTableView footerEndRefreshing];
        [weakSelf.myTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        
        NSLog(@"%@",error);
        //刷新结束
//        [weakSelf.myTableView footerEndRefreshing];
        [weakSelf.myTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        
    }];
    
    
    
}
-(void)setTableView{
    
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight-64-49) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];

    _myTableView.delegate = self ;
    _myTableView.dataSource = self ;
    
    _myTableView.tableHeaderView = [self setScrollView];
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_myTableView];
    
    __weak homeViewController * weakSelf  = self;
    
    //添加下拉刷新
    [_myTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        weakSelf.myTableView.tableHeaderView = [weakSelf setScrollView];
        [weakSelf setData];
        
        
        
    }];
    
    //添加上拉加载更多
//    [_myTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
//        [weakSelf setData];
//    }];
    
}

//设置头部试图-循环滚动
#pragma mark - 设置头部试图-循环滚动
-(UIView *)setScrollView{
    
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,0.4225 * ScreenWidth + 20)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
    
    ScrollViewDemo *scrollView = [[ScrollViewDemo alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,0.4225 * ScreenWidth)  withIsNetUrl:YES andIsTimer:YES];
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
    
    if ([[EGOCache globalCache] hasCacheForKey:@"scrollViewData"]) {
        id cachedata = [[EGOCache globalCache] plistForKey:@"scrollViewData"];
        NSArray * objc = [NSJSONSerialization JSONObjectWithData:cachedata options:0 error:nil][@"adlist"];
        NSLog(@"%@",objc);
        _homeScrollViewArr = [NSMutableArray arrayWithArray:[homeAdModel setModelWithArray:objc]];
        NSMutableArray * marr = [NSMutableArray array];
        for (homeAdModel * homeAdModel in _homeScrollViewArr ) {
            [marr addObject: homeAdModel.img_url];
        }
        NSLog(@"%@",marr);
        [marr insertObject:[marr lastObject] atIndex:0];
        [marr addObject:marr[1]];
        
        scrollView.photoArrays = marr;

        
    }
    
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak homeViewController * weakSelf = self;
    
    [manger GET:homeAdURLstring parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[EGOCache globalCache] setPlist:responseObject forKey:@"scrollViewData"];
        
        NSArray * objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil][@"adlist"];
        weakSelf.homeScrollViewArr = [NSMutableArray arrayWithArray:[homeAdModel setModelWithArray:objc]];
        NSMutableArray * marr = [NSMutableArray array];
        for (homeAdModel * homeAdModel in weakSelf.homeScrollViewArr ) {
            [marr addObject: homeAdModel.img_url];
        }

        if (marr.count > 0) {
            
            [marr insertObject:[marr lastObject] atIndex:0];
            [marr addObject:marr[1]];
        }
    
        scrollView.photoArrays = marr;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        
    }];

    

    
#pragma mark 滚动视图返回区
    scrollView.backCurrentPage = ^(NSInteger pageAtIndex){
        NSLog(@ "-----滚动视图第%ld张------",(long)pageAtIndex);
        if (pageAtIndex <= _homeScrollViewArr.count) {
        
            classifitionDetailViewController * classifitionVC = [[classifitionDetailViewController alloc] init];
            homeAdModel * admodel = weakSelf.homeScrollViewArr[pageAtIndex - 1];
            classifitionVC.cat_id = admodel.cat_id;
            classifitionVC.goods_name = admodel.ad_name;
           
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:classifitionVC];
            nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
            
            //过场动画（翻转）#FF0000
            [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            
            [weakSelf presentViewController:nvc animated:YES completion:nil];
        }
    };
    [headView addSubview:scrollView];
    
    return headView;

    
}


-(void)setNavigation{
    
    self.navigationItem.title = @"首页";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_drawer.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(openDrawerNotifi)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;

    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    
    
}


-(void)openDrawerNotifi{

    NSNotification * notification = [NSNotification notificationWithName:@"cehuatongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    NSLog(@"%f,%f",ScreenHeight,ScreenWidth);
    
}

#pragma mark - tableview代理回调方法
//设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc ]init];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView * headerViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 28, 28)];

    [headerViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_DataArrary[section][@"classIcon"]]] placeholderImage:[UIImage imageNamed:@"home_icon_accessories_n.png"]];

    headerViewImage.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerViewImage];
    
    UILabel * headerViewNameLable = [[UILabel alloc] initWithFrame:CGRectMake(55, 11, 200 , 28)];
    headerViewNameLable.text = _DataArrary[section][@"className"];
    headerViewNameLable.font = [UIFont systemFontOfSize:20];
    headerViewNameLable.textColor = [UIColor colorWithHexString:@"#ff1800"];
    
    [headerView addSubview:headerViewNameLable];
    
    
    return headerView;

}
//设置组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc ]init];
    return footerView;
}
//设置组前距离
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
//设置组末距离
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==_DataArrary.count-1) {
        return 0.1;
    }else
        return 20;
}

//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _DataArrary.count;
}
//设置每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_DataArrary[section][@"secondClassifiction"] count];
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return _DataArrary.count ;
    return ScreenWidth/320*175;
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID = @"myCell";
    homeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"homeTableViewCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [cell setCellWithHomeVCModel:_DataArrary[indexPath.section][@"secondClassifiction"][indexPath.row]];
    
    
    return cell ;
}


#pragma mark tableview的滚动事件
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self flotationBallButAlphaNO];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
//    if (!decelerate) {
//        [self flotationBallButAlphaYES];
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    [self flotationBallButAlphaYES];
}

-(void)flotationBallButAlphaNO{
    
    UIButton * button = [self.view viewWithTag:10014];
    [UIView animateWithDuration:0.5 animations:^{
        button.alpha = 0.1;
    }];
}

-(void)flotationBallButAlphaYES{
    
    UIButton * button = [self.view viewWithTag:10014];
    [UIView animateWithDuration:0.5 animations:^{
        button.alpha = 1.0;
    }];
}

#pragma mark Cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    classifitionDetailViewController * classifitionVC = [[classifitionDetailViewController alloc] init];
 
    homeModel * homeModel = _DataArrary[indexPath.section][@"secondClassifiction"][indexPath.row];
    classifitionVC.cat_id = homeModel.cat_id;
    classifitionVC.goods_name = [NSString stringWithFormat:@"%@-%@",homeModel.keywords,homeModel.cat_name];
    
    UINavigationController * Nvc = [[UINavigationController alloc]initWithRootViewController:classifitionVC];
    Nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    
    [Nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    

 
    [self presentViewController:Nvc animated:YES completion:nil];
    

}

#pragma mark - 判断登录是否失效
-(void)JudgeLoginYesAndNo{
    
    
    AFHTTPRequestOperationManager * shoppingManager = [AFHTTPRequestOperationManager manager];
    shoppingManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    NSLog(@"%@",time);
    NSString * sign = [NSString stringWithFormat:@"shopInfo%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setValue:[UserData sharkedUser].uid forKey:@"uid"];
    [mdic setValue:time forKey:@"time"];
    [mdic setValue:sign forKey:@"sign"];
    
    [shoppingManager POST:shoppingCarURLstring parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        if([obj[@"info"] isEqualToString:@"u019"]){
            
            [UserData sharkedUser].uid = nil;
            [SVProgressHUD showErrorWithStatus:@"登录已失效！"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}









@end
