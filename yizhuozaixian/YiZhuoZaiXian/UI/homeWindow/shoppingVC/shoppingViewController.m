//
//  shoppingViewController.m
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import "shoppingViewController.h"
#import "shoppingTableViewCell.h"
#import "shoppingModel.h"
#import "shoppingCarChange.h"
#import "gooodsDetailsVC.h"
#import "getOrderViewController.h"
@interface shoppingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * DataArrary;

@property(nonatomic,assign)int totalPrice;

//结算-But
@property(nonatomic,strong)UIButton * jiesuanButton;
//结算-全选But
@property(nonatomic,strong)UIButton * jiesuanQuanxuanBut;
//结算-总计Lable
@property(nonatomic,strong)UILabel * jiesuanZongjiLable;
//结算全选but状态
@property(nonatomic,assign)BOOL jiesuanSeletced;
//组头全选but状态
@property(nonatomic,assign)BOOL zutouSeletced;
//区别是不是第一次加载
@property(nonatomic,assign)BOOL tagTaye;

@end

@implementation shoppingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _jiesuanSeletced = YES;

    if (_tagTaye) {
        
        NSLog(@"%@",_DataArrary);
        
//        [XCDLoadingView createXCDLoadingViewWithSuperView:self.view];

        
        [self setData];
        

    }
    _tagTaye = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:22],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
    
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-40) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    
    
    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    _DataArrary = [NSMutableArray array];

    [self setData];
//    shoppingModel * model = [shoppingModel new];
//    self.DataArrary = [NSMutableArray arrayWithArray:@[@[@"店铺名",@"店铺id",@"店铺id",@[model,model]],@[@"店铺名",@"店铺id",@"店铺id",@[model,model,model]],@[@"店铺名",@"店铺id",@"店铺id",@[model,model,model,model,model]]]];
//    [self setUIView];
    
    

    
}
-(void)setData{
    
    
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
    
    
    
    
    __weak shoppingViewController * weakSelf = self;
    [shoppingManager POST:shoppingCarURLstring parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",obj);
        
        if ([obj[@"info"] isEqualToString:@"a001"]) {
            
            NSMutableArray * mArr = [NSMutableArray arrayWithArray:obj[@"shopList"]];
            for (int i = 0; i < [mArr count]; i++) {
                if ([mArr[i][@"shopInfo"] count] == 0) {
                    [mArr removeObjectAtIndex:i];
                    i--;
                }
                
            }
            weakSelf.DataArrary = [shoppingModel setModelWithArray:mArr];
            
            
        }else if([obj[@"info"] isEqualToString:@"u019"]){
            [UserData sharkedUser].uid = nil;
            [SVProgressHUD showErrorWithStatus:@"登录已失效！"];
            
            
        }else{
            NSLog(@"购物车空");
            [weakSelf.DataArrary removeAllObjects];
        }
        
        [weakSelf.myTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
        [weakSelf setUIView];
        [weakSelf.myTableView reloadData];
        
        [XCDLoadingView cancelXCDLoadingView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [XCDLoadingView cancelXCDLoadingView];
        
        [weakSelf.myTableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        
        [self creatNOshoppingUI];
        NSLog(@"购物车下载数据错误：error = %@",error);
        
    }];
    
    
    
    
    NSLog(@"%@",_DataArrary);
    
}

#pragma mark - 视图初始化
-(void)setUIView{
    
    
    NSLog(@"%@",_DataArrary);
    
    if (_DataArrary.count > 0) {
        
        
        [self setJiesuanView];
        
        __weak shoppingViewController * weakSelf = self;
        //添加下拉刷新
        [_myTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
            
            [weakSelf setData];
            
        }];
        
        [self.view addSubview:_myTableView];
        
        
    }else{
        
        [self creatNOshoppingUI];
    }
    
    
}

#pragma mark - 结算支付UI布局
-(void)setJiesuanView{
    //结算view
    UIView * jiesuanView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-40-49, ScreenWidth, 40)];
    jiesuanView.tag = 789;
    jiesuanView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.view addSubview:jiesuanView];
    
    //全选but
    _jiesuanQuanxuanBut
    = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 30, 30)];
    _jiesuanQuanxuanBut.selected = _jiesuanSeletced;
    _jiesuanQuanxuanBut.tag = 889;
    [_jiesuanQuanxuanBut setBackgroundImage:[UIImage imageNamed:@"btn_pay_radiobox_defult.png"] forState:UIControlStateNormal];
    [_jiesuanQuanxuanBut setBackgroundImage:[UIImage imageNamed:@"btn_pay_radiobox_red.png"] forState:UIControlStateSelected];
    [_jiesuanQuanxuanBut addTarget:self action:@selector(jiesuanQuanxuanBut:) forControlEvents:UIControlEventTouchUpInside];
    [jiesuanView addSubview:_jiesuanQuanxuanBut];
    
    //总价合计
    _jiesuanZongjiLable = [[UILabel alloc]initWithFrame:CGRectMake(34, 0, 200, 40)];
    _jiesuanZongjiLable.textColor = [UIColor orangeColor];
    _jiesuanZongjiLable.tag = 990;
    NSString * jiesuanHejiStr = [NSString stringWithFormat:@"全选       合计  ￥ %.2f 元",[self jisuanSelectedGoodsPriceWithSection:10000]];
    NSMutableAttributedString * jiesuanHejiAttributedString = [[NSMutableAttributedString alloc]initWithString:jiesuanHejiStr];
    [jiesuanHejiAttributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 12)];
    _jiesuanZongjiLable.attributedText = jiesuanHejiAttributedString;
    [jiesuanView addSubview:_jiesuanZongjiLable];
    
    //结算But
    _jiesuanButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth*0.75, 0, 0.25*ScreenWidth, 40)];
    [_jiesuanButton setTitle:@"结算" forState:UIControlStateNormal];
//    _jiesuanButton.
    _jiesuanButton.backgroundColor = [UIColor redColor];
    [_jiesuanButton addTarget:self action:@selector(jiesuanBut:) forControlEvents:UIControlEventTouchUpInside];
    [jiesuanView addSubview:_jiesuanButton];
    
    
    
}
#pragma mark 结算支付事件
-(void)jiesuanBut:(UIButton *)button{
    
    //获取勾选后的商品数组
    NSMutableArray * jiesuanArr = [NSMutableArray arrayWithArray: _DataArrary ];
    for (int j = 0; j < jiesuanArr.count;j++) {
        NSMutableArray * zuArr = jiesuanArr[j];
        if (![zuArr[2] boolValue]) {
            BOOL ddye = NO;
            for (int i = 0;i < [zuArr[3] count]; i++) {
                shoppingModel * goodsModel = zuArr[3][i];
                if (!goodsModel.gouxuanSelected) {
                    [zuArr[3] removeObject:goodsModel];
                    i--;
                    
                }else{
                    ddye = YES;
                }
            }
            if (!ddye) {
                [jiesuanArr removeObject:zuArr];
                j--;
            }
        }
    }
    NSLog(@"%lu",(unsigned long)jiesuanArr.count);
    if (jiesuanArr.count > 0) {
        
        getOrderViewController * getVc = [[getOrderViewController alloc] init];
        getVc.shoppingCarInfo = YES;
        getVc.goodsOrderMarr = jiesuanArr;
        
        UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:getVc];
        nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
        [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        [self presentViewController:nvc animated:YES completion:nil];
    }
    
    
    
}

#pragma mark - 创建空购物车UI界面
//创建空购物车UI界面
-(void)creatNOshoppingUI{
    UIView * beijingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    beijingView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    [self.view addSubview:beijingView];
    UIImageView * beijingImage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-96)*0.5-5, (ScreenHeight-64-49-90)*0.5-60, 96, 90)];
    beijingImage.image = [UIImage imageNamed:@"Shopping-cart_on.png"];
    
    [self.view addSubview:beijingImage];
    
    UILabel * label = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, beijingImage.frame.origin.y + 120 + 30, ScreenWidth, 30) andBackgroundColor:nil andText:@"Hi 购物车还是空空的 , 赶紧行动吧 ~" andTextFont:16 andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    UIButton * fanhuiButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake((ScreenWidth - 0.25*ScreenWidth)/2, ScreenHeight-64-49-0.375*0.25*ScreenWidth-70, 0.25*ScreenWidth , 0.375*0.25*ScreenWidth) andBackgroundColor:[UIColor colorWithHexString:@"#fe0201"] andText:@"去逛逛" andTextColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:17] andTarget:self andSelector:@selector(fanhuiButtonClick)];
    
    [fanhuiButton addTarget:self action:@selector(button1BackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
    [fanhuiButton addTarget:self action:@selector(button1BackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    fanhuiButton.layer.cornerRadius = 5.0;
    
//    fanhuiButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:fanhuiButton.layer.bounds].CGPath;
//    fanhuiButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    fanhuiButton.layer.shadowOpacity = 1.6f;
//    fanhuiButton.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
//    fanhuiButton.layer.shadowRadius = 1.0;
    
    [self.view addSubview:fanhuiButton];
    
    
}
//  button1普通状态下的背景色
- (void)button1BackGroundNormal:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithHexString:@"#fe0201"];
}

//  button1高亮状态下的背景色
- (void)button1BackGroundHighlighted:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithHexString:@"fe5555"];
}
-(void)fanhuiButtonClick{
    
    NSLog(@"去逛逛");
    
    NSNotification * notification = [NSNotification notificationWithName:@"quguangguangtongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
    
}



//底部合计结算全选ButClick
-(void)jiesuanQuanxuanBut:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        
        _jiesuanButton.userInteractionEnabled = YES;
        _jiesuanButton.backgroundColor = [UIColor redColor];

        for (NSMutableArray * zuArr in _DataArrary) {
            [zuArr replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
            for (shoppingModel * model in [zuArr lastObject]) {
                model.gouxuanSelected = YES;
            }
            
        }
        

        [_myTableView reloadData];
    }else{
        
        _jiesuanButton.userInteractionEnabled = NO;
        _jiesuanButton.backgroundColor = [UIColor lightGrayColor];
        
        for (NSMutableArray * zuArr in _DataArrary) {
            
            [zuArr replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
            for (shoppingModel * model in [zuArr lastObject]) {
                model.gouxuanSelected = NO;
            }
        }
        [_myTableView reloadData];
    }
    //修改总价
    _jiesuanZongjiLable.attributedText = [self jisuangoodsPriceAndsetColor];
    
}

//组头全选ButClick
-(void)quanXuanButClick:(UIButton *)button{
    
    button.selected = !button.selected;
    NSMutableArray * zuArr = _DataArrary[button.tag - 2000];
    if (button.selected) {
        _jiesuanButton.userInteractionEnabled = YES;
        _jiesuanButton.backgroundColor = [UIColor redColor];
        for (shoppingModel * model in [zuArr lastObject]) {
            model.gouxuanSelected = YES;
        }
        [zuArr replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        [_myTableView reloadData];
        
    }else{
        for (shoppingModel * model in [zuArr lastObject]) {
            model.gouxuanSelected = NO;
        }
        [zuArr replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        [_myTableView reloadData];
        
        
        //判断是否有商品勾选，来决定结算but是否可点击
        __block BOOL bbb = NO;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            for (int i = 0 ; i < _DataArrary.count; i++) {
                for (shoppingModel * model in [_DataArrary[i] lastObject]) {
                    if (model.gouxuanSelected) {
                        bbb = YES;
                        break;
                    }
                }
                if (bbb) {
                    break;
                }
            }
        });
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!bbb) {
                _jiesuanButton.userInteractionEnabled = NO;
                _jiesuanButton.backgroundColor = [UIColor lightGrayColor];
            }
            
        });
        
        
    }
    BOOL zuBool = YES;
    for (NSMutableArray * arr in _DataArrary) {
        if (![arr[2] boolValue]) {
            zuBool = NO;
        }
    }
    _jiesuanQuanxuanBut.selected = zuBool;
    
    //修改总价
    _jiesuanZongjiLable.attributedText = [self jisuangoodsPriceAndsetColor];
}


#pragma mark - tableview代理回调方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
        return 60;
}
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _DataArrary.count;
}
//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [[_DataArrary[section] lastObject] count];
}
//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


//设置cell
#pragma mark 设置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ID  = @"myCell";
    shoppingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"shoppingTableViewCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellWithShoppingModel:[_DataArrary[indexPath.section] lastObject][indexPath.row]] ;
    __weak shoppingViewController * weakSelf = self;
    cell.shoppingCellBlock = ^(UIButton * gouxuanButton,NSString * goodsNumber){
        
        if (gouxuanButton.tag==0) {
            NSLog(@"数量%@",goodsNumber);
            shoppingModel * shoppmodel =  [weakSelf.DataArrary[indexPath.section] lastObject][indexPath.row];
            shoppmodel.num = goodsNumber;
            [weakSelf.myTableView reloadData];
            
            //因商品数量改变而同步到服务器
            NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
            [mdic setValue:[UserData sharkedUser].uid forKey:@"uid"];
            
            
            [mdic setValue:shoppmodel.car_id forKey:@"car_id"];
            [mdic setValue:shoppmodel.num forKey:@"num"];
            
            
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            long long int data = (long long int)a;
            NSString * time = [NSString stringWithFormat:@"%lld", data];
            mdic[@"time"] = time;
            mdic[@"sign"] = [NSString stringWithFormat:@"modInfo%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,shoppmodel.car_id,shoppmodel.num].md5String;
            

            
            
            NSLog(@"%@",mdic);
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                shoppingCarChange * shoppingChange = [[shoppingCarChange alloc]init];
                
                [shoppingChange changeShoppingCarNumRequestWithDic:mdic andURLstr:shoppingCarChangeURLsting];
            });

            
        }else{
            NSLog(@"第%ld个Button selected = %d,数量%@",(long)indexPath.row,gouxuanButton.selected,goodsNumber);
            shoppingModel * shoppmodel =  [weakSelf.DataArrary[indexPath.section] lastObject][indexPath.row];
            shoppmodel.gouxuanSelected = gouxuanButton.selected;
            if (shoppmodel.gouxuanSelected) {
                _jiesuanButton.userInteractionEnabled = YES;
                _jiesuanButton.backgroundColor = [UIColor redColor];
            }else{
                
                //判断是否有商品勾选，来决定结算but是否可点击
//                BOOL ddd = NO;
                __block BOOL bbb = NO;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    
                    for (int i = 0 ; i <  _DataArrary.count ; i++) {
                        
                        for (shoppingModel * model in [_DataArrary[i] lastObject]) {
                            if (model.gouxuanSelected) {
                                bbb = YES;
                                break;
                            }
                        }
                        if (bbb) {
                            break;
                        }
                    }
                    
                    
                });
                
                //回到主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!bbb) {
                        _jiesuanButton.userInteractionEnabled = NO;
                        _jiesuanButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                });

                
                
                
            }
            
            BOOL ddtype = YES;
            for (shoppingModel * model in [weakSelf.DataArrary[indexPath.section] lastObject]) {
                if (!model.gouxuanSelected) {
                    ddtype = NO;
                }
            }
            [weakSelf.DataArrary[indexPath.section] replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:ddtype]];
            
            [weakSelf.myTableView reloadData];
            
            //根据单个商品的勾选改变，而改变结算全选but的勾选状态
            BOOL bbtype = YES;
            for (NSMutableArray * marr in weakSelf.DataArrary) {
                if (![marr[2] boolValue]) {
                    bbtype = NO;
                }
            }
            _jiesuanQuanxuanBut.selected = bbtype;
            
        }
                //因修改数量而修改总价
        _jiesuanZongjiLable.attributedText = [self jisuangoodsPriceAndsetColor];
        
    };
    
    return cell;
}
#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    shoppingModel * model = [_DataArrary[indexPath.section] lastObject][indexPath.row];
    
    gooodsDetailsVC * goodsVC = [[gooodsDetailsVC alloc]init];
    
    goodsVC.goodsSizeURLstring = [NSString stringWithFormat:@"%@%@",goodsDetailsURLstring,model.goods_id];
    goodsVC.goodsID = model.goods_id;
    goodsVC.goodImage = model.goods_small_img;
    goodsVC.goodsName = model.goods_name;
//    goodsVC.goodBrief = model.
    goodsVC.shoppingCarInto = YES;
    NSLog(@"%@",model);
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:goodsVC];
    nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    [nvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nvc animated:YES completion:nil];


}


#pragma mark 删除cell
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        
        //删除购物车某商品数据同步服务器
        NSLog(@"%@",_DataArrary);
        shoppingModel * shoppmodel =  [self.DataArrary[indexPath.section] lastObject][indexPath.row];
        NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
        
        
        [mdic setValue:[UserData sharkedUser].uid forKey:@"uid"];
        
        [mdic setValue:shoppmodel.car_id forKey:@"car_id"];
        
        
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        mdic[@"time"] = time;
        mdic[@"sign"] = [NSString stringWithFormat:@"delInfo%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,shoppmodel.car_id].md5String;
        
        

        
        
        NSLog(@"%@",mdic);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            shoppingCarChange * shoppingChange = [[shoppingCarChange alloc]init];
            
            [shoppingChange changeShoppingCarNumRequestWithDic:mdic andURLstr:deleteShoppingCarGoodsURLsting];
        });
        
        
        [[_DataArrary[indexPath.section]lastObject] removeObjectAtIndex:indexPath.row];
        
        if ([[_DataArrary[indexPath.section] lastObject] count]==0) {
            
            [_DataArrary removeObjectAtIndex:indexPath.section];
        }
        
        if (_DataArrary.count == 0) {
            
            UIView * zifuView = [self.view viewWithTag:789];
            zifuView.hidden = YES;
            
            [self creatNOshoppingUI];
        }
        
        [_myTableView reloadData];

        _jiesuanZongjiLable.attributedText = [self jisuangoodsPriceAndsetColor];
        
        NSLog(@"%@",_DataArrary);
  
        
    }else if (editingStyle==UITableViewCellEditingStyleInsert){
        
    }
}


//设置组头
#pragma mark 设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton * quanXuanBut = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 30, 30)];
    NSLog(@"%@----%d",_DataArrary[section][2],[_DataArrary[section][2] boolValue]);
    quanXuanBut.selected = [_DataArrary[section][2] boolValue] ;
    [quanXuanBut setBackgroundImage:[UIImage imageNamed:@"btn_pay_radiobox_defult.png"] forState:UIControlStateNormal];
    [quanXuanBut setBackgroundImage:[UIImage imageNamed:@"btn_pay_radiobox_red.png"] forState:UIControlStateSelected];
    quanXuanBut.tag = 2000 + section;
    [quanXuanBut addTarget:self action:@selector(quanXuanButClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:quanXuanBut];
    
    UILabel * shangJiaNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 250, 24)];
    shangJiaNameLabel.text = _DataArrary[section][0];
    
    [headerView addSubview:shangJiaNameLabel ];
    
    return headerView;
    
    
}

//设置组尾
#pragma mark 设置组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    footerView.backgroundColor = [UIColor whiteColor];
    if (section !=_DataArrary.count-1) {
        UILabel * grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, ScreenHeight, 20)];
        grayLabel.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
        [footerView addSubview:grayLabel];
    }

    //已选择商品数
    UILabel * selectedShangPingShu = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    selectedShangPingShu.textColor = [UIColor lightGrayColor];
    selectedShangPingShu.font = [UIFont systemFontOfSize:13];
    
    NSInteger goodsS = [self jisuanSelectedGoodsNumWithSection:section];
    selectedShangPingShu.text = [NSString stringWithFormat:@"已选%ld件商品",(long)goodsS];
    [footerView addSubview:selectedShangPingShu];
    
    //优惠价格
    UILabel * youHuiPriceLable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 10, 100, 20)];
    youHuiPriceLable.font = [UIFont systemFontOfSize:13];
    youHuiPriceLable.textAlignment = NSTextAlignmentCenter;
    NSString * youHuiStr = [NSString stringWithFormat:@"优惠￥0"];
    
    NSMutableAttributedString * youHuiAttributeString = [[NSMutableAttributedString alloc] initWithString:youHuiStr];
    
    [youHuiAttributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor],   NSFontAttributeName : [UIFont systemFontOfSize:13]} range:NSMakeRange(0, 3)];
    youHuiPriceLable.attributedText = youHuiAttributeString;
    
    //当优惠不为0时加载
//    if (_youHuiPriceArrary[section] != 0) {
//        [footerView addSubview:youHuiPriceLable];
//    }
    
    //应付价格
    UILabel * yingfuPriceLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-200-10, 10, 200, 20)];
    yingfuPriceLable.font = [UIFont systemFontOfSize:13];
    yingfuPriceLable.textColor = [UIColor redColor];
    yingfuPriceLable.textAlignment = NSTextAlignmentRight;
    NSString * yingfuPriceStr = [NSString stringWithFormat:@"应付 ￥%.2f",[self jisuanSelectedGoodsPriceWithSection:section]];
    NSMutableAttributedString * yingfuAttributedString = [[NSMutableAttributedString alloc] initWithString:yingfuPriceStr];
    [yingfuAttributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 3)];
    yingfuPriceLable.attributedText = yingfuAttributedString;
    [footerView addSubview:yingfuPriceLable];
    
    
    
    
    return footerView;
    
}

//计算已选商品数量
-(NSInteger)jisuanSelectedGoodsNumWithSection:(NSInteger)section{
    NSInteger goodsNum = 0;
    for(shoppingModel * model in [_DataArrary[section] lastObject]){
        if (model.gouxuanSelected) {
            goodsNum += [model.num intValue];
        }
    }
    return goodsNum;
}
//计算已选商品总价
-(float)jisuanSelectedGoodsPriceWithSection:(NSInteger)section{
    float goodsPrice = 0;
    if (section==10000) {
        for (NSArray * zuArr in _DataArrary) {
            //        if ([zuArr[2] boolValue]) {
            
            for (shoppingModel * model in zuArr[3]) {
                if (model.gouxuanSelected) {
                    goodsPrice += [model.num intValue] * [model.goods_price floatValue];
                }
            }
            
            
            //        }
        }

    }else{
        for (shoppingModel * model in _DataArrary[section][3]) {
            if (model.gouxuanSelected) {
                goodsPrice += [model.num intValue] * [model.goods_price floatValue];
            }
        }
    }
    
    NSLog(@"%f",goodsPrice);
    
    return goodsPrice;
    
    
    
}

//修改总价并设置字体颜色
-(NSMutableAttributedString *)jisuangoodsPriceAndsetColor{
    
    NSString * jiesuanHejiStr = [NSString stringWithFormat:@"全选       合计  ￥ %.2f 元",[self jisuanSelectedGoodsPriceWithSection:10000]];
    NSMutableAttributedString * jiesuanHejiAttributedString = [[NSMutableAttributedString alloc]initWithString:jiesuanHejiStr];
    [jiesuanHejiAttributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 12)];
    return jiesuanHejiAttributedString;
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


                                  
                                  
                                  
@end
