//
//  VipViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "VipViewController.h"
#import "UIButton+WebCache.h"
#import "VipTableViewCell.h"
#import "VIPModel.h"

#import "gooodsDetailsVC.h"
#import "VIPShowViewController.h"

@interface VipViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic,strong) NSMutableArray *VIPArray;
@property (nonatomic ,strong) VIPModel *vipmodel;


@end

@implementation VipViewController


- (VIPModel *)vipmodel{
    if (!_vipmodel) {
        _vipmodel  = [[VIPModel alloc] init];
    }
    return _vipmodel;
}

- (NSMutableArray *)VIPArray{
    if (!_VIPArray) {
        _VIPArray = [NSMutableArray array];
    }
    return _VIPArray;
}


- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, ScreenWidth, 100)];
        _label.text = @"暂无特价商品,敬请期待～～～～";
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor colorWithHexString:@"#888888"];
        _label.textAlignment = 1;
    }
    return _label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    [self loadNewData:nil];
    [self setUpUI];
    

}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}



#pragma mark - ******** 设置UI ********
- (UIView *)setHeaderView{
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    headerview.backgroundColor = [UIColor colorWithHexString:@"#fe8c8d"];
    
    
    UILabel *prolabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 90, 100, 20)];
    if (!self.vipmodel.integral) {
        prolabel.text = [NSString stringWithFormat:@"0/%@",self.vipmodel.grade_scale];
    }else{
        prolabel.text = [NSString stringWithFormat:@"%@/%@",self.vipmodel.integral,self.vipmodel.grade_scale];
    }
    NSLog(@"%@",self.vipmodel.grade);
    prolabel.textAlignment = 2;
    prolabel.font = [UIFont systemFontOfSize:12.0];
    prolabel.textColor = [UIColor redColor];
    [headerview addSubview:prolabel];

    UIButton *iconBtn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(20, 30, 80, 80) andBackgroundColor:nil  andImage:nil andBackgroundImage:nil andTarget:nil andSelector:nil];
    if ([UserData sharkedUser].uid == nil) {
        [iconBtn setBackgroundImage:[UIImage imageNamed:@"personal_icon_head_n"] forState:UIControlStateNormal];
    }else{
        [iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserData sharkedUser].imgUrl] forState:UIControlStateNormal placeholderImage:nil];
    }
    iconBtn.layer.cornerRadius = 40.0;
    iconBtn.layer.masksToBounds = YES;

    [headerview addSubview:iconBtn];
    
    
    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 100, 20)];
    namelabel.text = [UserData sharkedUser].nickname;
    [headerview addSubview:namelabel];
    
    UIImageView *vip = [[UIImageView alloc] initWithFrame:CGRectMake(120, 80, 20, 20)];
    vip.layer.cornerRadius = 10.0;
    vip.layer.masksToBounds = YES;
    if ([self.vipmodel.grade isEqualToString:@"v0"]) {
        vip.image = [UIImage imageNamed:@"member_icon_level0_n"];
    }else if ([self.vipmodel.grade isEqualToString:@"v1"]){
        vip.image = [UIImage imageNamed:@"member_icon_level1_n"];
    }else if ([self.vipmodel.grade isEqualToString:@"v2"]){
        vip.image = [UIImage imageNamed:@"member_icon_level2_n"];
    }else if ([self.vipmodel.grade isEqualToString:@"v3"]){
        vip.image = [UIImage imageNamed:@"member_icon_level3_n"];
    }else if ([self.vipmodel.grade isEqualToString:@"v4"]){
        vip.image = [UIImage imageNamed:@"member_icon_level4_n"];
    }else if ([self.vipmodel.grade isEqualToString:@"v5"]){
        vip.image = [UIImage imageNamed:@"member_icon_level5_n"];
    }
    [headerview addSubview:vip];
    
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progress.frame = CGRectMake(145, 90, 100, 20);
    progress.trackTintColor = [UIColor colorWithHexString:@"#dddddd"];
    progress.progressTintColor = [UIColor redColor];
    progress.progress = [self.vipmodel.integral floatValue] / [self.vipmodel.grade_scale floatValue];
    //进度
    //[progress setProgress:0.7 animated:YES];
    [headerview addSubview:progress];
    
    
    UIButton *qiandao = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(ScreenWidth - 50, 60, 40, 40) andBackgroundColor:[UIColor redColor] andText:nil andTextColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:12.0] andTarget:self andSelector:@selector(clickqiandao)];
    if ([self.vipmodel.sign_status isEqualToString:@"1"]) {
        [qiandao setTitle:@"已签到" forState:UIControlStateNormal];
        qiandao.enabled = NO;
        [qiandao setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        [qiandao setTitle:@"签到" forState:UIControlStateNormal];
        qiandao.enabled = YES;
        
    }
    qiandao.layer.cornerRadius = 20.0;
    [headerview addSubview:qiandao];
    
    
    UILabel *firstlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, ScreenWidth/3, 45)];
    if (!self.vipmodel.days) {
        firstlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"签到天数",@"0"];
    }else{
        firstlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"签到天数",self.vipmodel.days];
    }
    firstlabel.font = [UIFont systemFontOfSize:13.0];
    firstlabel.numberOfLines = 2;
    firstlabel.textColor = [UIColor whiteColor];
    firstlabel.backgroundColor = [UIColor colorWithHexString:@"#e15673"];
    firstlabel.textAlignment = 1;
    
    
    UILabel *secondlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, 140, ScreenWidth/3 , 45)];
    if (!self.vipmodel.continuous) {
         secondlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"连续签到",@"0"];
    }else{
        secondlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"连续签到",self.vipmodel.continuous];
    }
    secondlabel.numberOfLines = 2;
    secondlabel.font = [UIFont systemFontOfSize:13.0];
    secondlabel.textColor = [UIColor whiteColor];
    secondlabel.textAlignment = 1;
    secondlabel.backgroundColor = [UIColor colorWithHexString:@"#e15673"];
    
    UILabel *thirdlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3*2, 140, ScreenWidth/3, 45)];
    if (!self.vipmodel.integral) {
        thirdlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"当前积分",@"0"];
    }else{
        thirdlabel.text = [NSString stringWithFormat:@"%@\r\n%@",@"当前积分",self.vipmodel.integral];
    }
    thirdlabel.font = [UIFont systemFontOfSize:13.0];
    thirdlabel.textAlignment = 1;
    thirdlabel.numberOfLines = 2;
    thirdlabel.backgroundColor = [UIColor colorWithHexString:@"#e15673"];
    thirdlabel.textColor = [UIColor whiteColor];
    
    UILabel *forthlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 150, 15)];
    forthlabel.text = @"   连续签到7天得10积分";
    forthlabel.textColor = [UIColor whiteColor];
    forthlabel.font = [UIFont systemFontOfSize:12.0];
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3 - 1, 150, 2, 25)];
    firstView.alpha = 0.5;
    firstView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/3 *2 - 1, 150, 2, 25)];
    secondView.alpha = 0.5;
    secondView.backgroundColor = [UIColor whiteColor];
    
    
    [headerview addSubview:firstlabel];
    [headerview addSubview:thirdlabel];
    [headerview addSubview:secondlabel];
    
    [headerview addSubview:forthlabel];
    [headerview addSubview:firstView];
    [headerview addSubview:secondView];
    
    UIButton *vipBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0, 185, ScreenWidth, 35) andBackgroundColor:[UIColor whiteColor] andText:@"   会员权益说明" andTextColor:[UIColor blackColor] andTextFont:[UIFont systemFontOfSize:15.0] andTarget:self andSelector:@selector(clickVipBtn)];
    vipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [vipBtn setBackgroundImage:[UIImage imageNamed:@"member_next"] forState:UIControlStateNormal];
    [headerview addSubview:vipBtn];
    
    return headerview;
}

- (void)loadNewData:(NSString *)title{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
//    if ([[EGOCache globalCache] hasCacheForKey:@"VIPListData"]) {
//        id objc = [[EGOCache globalCache] plistForKey:@"VIPListData"];
//        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
//        NSLog(@"%@",json);
//        [self.VIPArray removeAllObjects];
//        VIPModel *model = [VIPModel objectWithKeyValues:json];
//        NSArray *array = [memberGoods objectArrayWithKeyValuesArray:model.memberGoods];
//        [self.VIPArray addObjectsFromArray:array];
//        [self.tableView reloadData];
//    }
    
    if ([[EGOCache globalCache] hasCacheForKey:[NSString stringWithFormat:@"qiandaoListData%@",[UserData sharkedUser].uid]]) {
        id objc = [[EGOCache globalCache] plistForKey:[NSString stringWithFormat:@"qiandaoListData%@",[UserData sharkedUser].uid]];
        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
        NSLog(@"%@",json);
        
        self.tableView.tableHeaderView = [self setHeaderView];

//        [self.tableView reloadData];
    }
    [self setHeaderView];
    __weak VipViewController *weakself = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [UserData sharkedUser].uid;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    param[@"time"] = time;
   
    

    
    [self.tableView reloadData];
    
    if ([title isEqualToString:@"1"]) {
        
        
        param[@"sign"] = [NSString stringWithFormat:@"signIn%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
        
        
        [manager POST:qiandaoUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[EGOCache globalCache] setPlist:responseObject forKey:[NSString stringWithFormat:@"qiandaoListData%@",[UserData sharkedUser].uid]];
            
            [weakself loadNewData:nil];
            [hud hideAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hideAnimated:YES];
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        }];

    }else{
        
        
         param[@"sign"] = [NSString stringWithFormat:@"members%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
        
        
        [manager POST:VIPUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[EGOCache globalCache] setPlist:responseObject forKey:@"VIPListData"];
          
            [weakself.VIPArray removeAllObjects];
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSLog(@"%@",json);
            VIPModel *model = [VIPModel objectWithKeyValues:json];
            self.vipmodel = model;
            NSLog(@"%@",model);
            NSArray *array = [memberGoods objectArrayWithKeyValuesArray:model.memberGoods];
            NSLog(@"%@",array);
            [weakself.VIPArray addObjectsFromArray:array];
            if (array.count == 0) {
                [weakself.VIPArray addObject:@"dddd"];
            }
            weakself.tableView.tableHeaderView = [weakself setHeaderView];
            [weakself.tableView reloadData];
            [weakself.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
            [hud hideAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hideAnimated:YES];
            [weakself.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        }];

    }
    
}


- (void)clickVipBtn{
    
    VIPShowViewController *vc = [VIPShowViewController new];
    vc.title = @"会员权益说明";
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"会员说明");
}

- (void)clickqiandao{
    
    [self loadNewData:@"1"];
    
}


- (void)setUpUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49 - 64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak VipViewController * weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        
        weakSelf.tableView.tableHeaderView = [weakSelf setHeaderView];
        [weakSelf loadNewData:nil];
        
        
        
    }];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self setHeaderView];
}


#pragma mark - ******** <UITableViewDataSource,UITableViewDelegate> ********


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    UILabel *headerlaber = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 30)];
    headerlaber.text = @"   会员专区";
    headerlaber.font = [UIFont systemFontOfSize:18.0];
    //headerlaber.backgroundColor = [UIColor lightGrayColor];
    [whiteview addSubview:headerlaber];
    return whiteview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 134;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.VIPArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    if (![self.VIPArray[0] isKindOfClass:[memberGoods class]]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        cell.textLabel.textAlignment = 1;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.textLabel.text = @"您的会员等级过低，暂无会员商品";
        return cell;
    }else{
        VipTableViewCell *cell = [VipTableViewCell cellWithTableView:tableView];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.model = self.VIPArray[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd",indexPath.row);
    
    memberGoods * model = self.VIPArray[indexPath.row];
    
    gooodsDetailsVC * goodsVC = [[gooodsDetailsVC alloc]init];
    
    //    goodsVC.fileName = model.fileName;
    goodsVC.goodsSizeURLstring = [NSString stringWithFormat:@"%@%@",goodsDetailsURLstring,model.goods_id];
    goodsVC.goodsID = model.goods_id;
    goodsVC.goodImage = model.goods_thumb;
    goodsVC.goodsName = model.goods_name;
    goodsVC.shoppingCarInto = YES;
    goodsVC.membersBool = YES;
    NSLog(@"%@",model);
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:goodsVC];
    nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#FF0000"];
    [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nvc animated:YES completion:nil];

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
