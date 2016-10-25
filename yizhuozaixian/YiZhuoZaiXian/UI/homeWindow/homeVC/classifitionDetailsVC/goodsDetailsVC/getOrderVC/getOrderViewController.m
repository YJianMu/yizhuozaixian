//
//  getOrderViewController.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/29.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "getOrderViewController.h"
#import "getOrderTableViewCellAddress.h"
#import "getOrderTableViewCellGoods.h"
#import "invoiceTableViewCell.h"
#import "payOrderViewController.h"
#import "JSONKit.h"
#import "CheckinViewController.h"

#import "shoppingModel.h"

#import "addressViewController.h"
#import "gooodsDetailsVC.h"

@interface getOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSMutableArray * DataArray;
@property(nonatomic,strong)UITableView * getOrderTableView;
@property(nonatomic,strong)UITextView * textView11;


//留言
@property(nonatomic,strong)NSMutableArray * messageArray;

//发票选择开关
@property(nonatomic,strong)UISwitch * invoiceSwitch;
@property(nonatomic,assign)BOOL invoiceBOOL;

//发票抬头
@property(nonatomic,strong)NSString * invoiceHeader;
//键盘高度
@property(nonatomic,assign)NSInteger keyboardHeight;

//默认地址字典
@property(nonatomic,strong)NSDictionary * addressDic;

//当登入失效时，区别是否是由登入VC进入（yes）
@property(nonatomic,assign)BOOL returnTaye;
@end

@implementation getOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_returnTaye) {
        
        [self setOrderAddressData];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _returnTaye = NO;
    _invoiceBOOL = NO;
    _keyboardHeight = 216;
//    _messageArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    _messageArray = [NSMutableArray arrayWithObjects:@"",@"", nil];
    for ( id objc in _goodsOrderMarr) {
        
        [_messageArray addObject:@""];
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self setKeyboard];
    
    [self setNavigation];
    
    
    [self setData];
    
    
    [self setTableView];
    
    [self setSubmitOrdersView];
}
-(void)setKeyboard{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)setNavigation{
    
    self.navigationItem.title = @"订单确认";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    

    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;


    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;

    
      if (_shoppingCarInfo) {
          
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

-(void)setOrderAddressData{
    
    //获取地址信息
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[UserData sharkedUser].uid forKey:@"uid"];
    mdic[@"time"] = time;
    mdic[@"sign"] = [NSString stringWithFormat:@"affirmAddr%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
    [manager POST:getOrderAddressURLstring parameters:mdic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        _addressDic = objc[@"addrInfo"];
        if ([objc[@"info"]isEqualToString:@"u019"]) {
            [UserData sharkedUser].uid = nil;
            
            [SVProgressHUD showErrorWithStatus:@"登录已失效！"];
        }

        [_getOrderTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        NSLog(@"获取默认地址成功 = %@",objc);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取默认地址失败");
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
    }];
    

    
}

-(void)setData{
    
    
    _DataArray = [NSMutableArray arrayWithArray:_goodsOrderMarr];
    
    //在商品数据模型前插入地址信息模型
    [_DataArray insertObject:@"" atIndex:0];
    //在商品数据模型后追加开具发票信息模型
    [_DataArray addObject:@""];
  
    
    NSLog(@"%@",_DataArray);
    
}

-(void)setTableView{
    
    _getOrderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-49-64) style:UITableViewStyleGrouped];
    
    _getOrderTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    
    _getOrderTableView.dataSource = self;
    _getOrderTableView.delegate = self;
    
    
    [self.view addSubview:_getOrderTableView];
    
}

-(void)setSubmitOrdersView{
    
    
    //实付款
    UILabel * shifukuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ScreenHeight-64-49, ScreenWidth-120, 49)];
    
    shifukuanLabel.tag = 9999;
    shifukuanLabel.textColor = [UIColor redColor];
    NSString * jiesuanHejiStr = [NSString stringWithFormat:@"实付款  ￥%.2f元",[self zongPrice]];
    NSMutableAttributedString * jiesuanHejiAttributedString = [[NSMutableAttributedString alloc]initWithString:jiesuanHejiStr];
    [jiesuanHejiAttributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor],   NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 4)];
    shifukuanLabel.attributedText = jiesuanHejiAttributedString;
    [self.view addSubview:shifukuanLabel];

    //提交订单But
    UIButton * submitOrdersButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-120, ScreenHeight-64-49, 120, 49)];
    [submitOrdersButton setTitle:@"提交订单" forState:UIControlStateNormal];
    submitOrdersButton.backgroundColor = [UIColor redColor];
    [submitOrdersButton addTarget:self action:@selector(submitOrdersButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitOrdersButton];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview 代理回调

//设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerView = [[UIView alloc ]init];
    headerView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        //地址栏 没组头
        headerView.backgroundColor = [UIColor clearColor];
        
    }else if (section==_DataArray.count-1) {
        
        //开具发票
        UILabel * invoiceLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 10, 100, 30) andBackgroundColor:[UIColor clearColor] andText:@"开具发票" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [headerView addSubview:invoiceLabel];
        
        _invoiceSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth-60, 5, 0, 0)];
        _invoiceSwitch.onTintColor = [UIColor redColor];
////        invoiceSwitch.tintColor = [UIColor purpleColor];
//        invoiceSwitch.thumbTintColor = [UIColor orangeColor];
        [_invoiceSwitch setOn:_invoiceBOOL animated:YES];
        [_invoiceSwitch addTarget:self action:@selector(invoiceSwitchClick:) forControlEvents:UIControlEventValueChanged];
        [headerView addSubview:_invoiceSwitch];
        
        
        
        
    }else{
        //店铺图标logo
        UIImageView * headerViewImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        //    headerViewImage.image = [UIImage imageNamed:@""];
//        [headerViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@""]] placeholderImage:[UIImage imageNamed:@"shop_icon_n.png"]];
        headerViewImage.image = [UIImage imageNamed:@"shop_icon_n.png"];
        headerViewImage.backgroundColor = [UIColor clearColor];
        [headerView addSubview:headerViewImage];
        
        //店铺名
        UILabel * storeNameLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200 , 30)];
        storeNameLable.text = _DataArray[section][0];
        storeNameLable.font = [UIFont boldSystemFontOfSize:17];
        storeNameLable.textColor = [UIColor blackColor];
        [headerView addSubview:storeNameLable];

        
    }
    
    
    return headerView;
    
}


//设置组头间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else
        return 40;
}
//设置组尾间距
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section != 0 && section != _DataArray.count-1) {
        return 180;
    }else{
        return 20;
    }
}

//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _DataArray.count;
}
//设置每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == _DataArray.count-1) {
        if (_invoiceSwitch.isOn) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return [[_DataArray[section] lastObject] count];

    }
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == _DataArray.count-1){
        
            return 150;
        
    }else{
        return 90;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        addressViewController * addressVC = [[addressViewController alloc]init];
        addressVC.isfrom = 100;
        
        [self.navigationController pushViewController:addressVC animated:YES];
        
    }
}

#pragma mark 设置组尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section != 0 && section !=_DataArray.count-1) {
        
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
        
        footerView.backgroundColor = [UIColor whiteColor];
        
        //配送方式
        UILabel * lable11 = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 0, 100, 40) andBackgroundColor:[UIColor clearColor] andText:@"配送方式" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [footerView addSubview:lable11];
        
        //商家配送
        UILabel * lable22 = [MyViewCreateControl initLabelWithFrame:CGRectMake(ScreenWidth - 110, 0, 100, 40) andBackgroundColor:[UIColor clearColor] andText:@"商家配送" andTextFont:15 andTextAlignment:NSTextAlignmentRight];
        [footerView addSubview:lable22];
        
        //线
        UIImageView * lineImage11 = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, 39, ScreenWidth, 1) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
        lineImage11.alpha = 0.4;
        [footerView addSubview:lineImage11];
        
        //共几件商品
        NSString * numStr = [NSString stringWithFormat:@"共%lu件",[[_DataArray[section] lastObject] count]];
        UILabel * lable33 = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 40, 100, 40) andBackgroundColor:[UIColor clearColor] andText:numStr andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        
        [footerView addSubview:lable33];
        
        //优惠价格
//        UILabel * lable44 = [MyViewCreateControl initLabelWithFrame:CGRectMake(ScreenWidth*0.5-50, 40, 100, 40) andBackgroundColor:[UIColor clearColor] andText:@"优惠￥0" andTextFont:15 andTextAlignment:NSTextAlignmentCenter];
//        [footerView addSubview:lable44];
        
        //当优惠不为0时加载
        //    if (lable44.text != 0) {
        //        [footerView addSubview:lable44];
        //    }
        
        //应付价格
        NSString * zongPrice = [NSString stringWithFormat:@"合计￥%.2f",[self jisuanzongjia:[_DataArray[section] lastObject]]];
        UILabel * lable55 = [MyViewCreateControl initLabelWithFrame:CGRectMake(ScreenWidth-210, 40, 200, 40) andBackgroundColor:[UIColor clearColor] andText:zongPrice andTextFont:15 andTextAlignment:NSTextAlignmentRight];
        [footerView addSubview:lable55];
        
        //线
        UIImageView * lineImage22 = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, 79, ScreenWidth, 1) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
        lineImage22.alpha = 0.4;
        [footerView addSubview:lineImage22];
        
        //留言Label
        UILabel * lable66 = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 80, 50, 40) andBackgroundColor:[UIColor clearColor] andText:@"留言：" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [footerView addSubview:lable66];
        
        //留言textView
        _textView11 = [[UITextView alloc] initWithFrame:CGRectMake(60, 90, ScreenWidth-70, 60)];
        _textView11.textColor = [UIColor blackColor];
        _textView11.font = [UIFont systemFontOfSize:15];
        _textView11.scrollEnabled = YES;
            //设置边框
            _textView11.layer.borderColor = UIColor.lightGrayColor.CGColor;
            _textView11.layer.borderWidth = 1;
            _textView11.layer.cornerRadius = 6;
            _textView11.layer.masksToBounds = YES;
        _textView11.delegate = self;
        _textView11.tag = 300 + section;
        _textView11.text = _messageArray[section];
        [footerView addSubview:_textView11];
        
        
        UILabel * label88 = [[UILabel alloc]initWithFrame:CGRectMake(8, 6, 200, 20)];
        label88.enabled = NO;
        if (_textView11.text.length > 0) {
            label88.hidden = YES;
        }else{
            label88.hidden = NO;
        }
        label88.tag = 88;
        label88.text = @"在此输入留言";
        label88.font =  [UIFont systemFontOfSize:15];
        label88.textColor = [UIColor lightGrayColor];
        [_textView11 addSubview:label88];
        
        //底部灰色组尾断开
        UILabel * lable77 = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, 160, ScreenWidth, 20) andBackgroundColor:[UIColor colorWithHexString:@"#ebebF4"] andText:@"" andTextFont:0 andTextAlignment:NSTextAlignmentLeft];
        [footerView addSubview:lable77];
        
        
        
        return footerView;
        
    }else{
        return nil;
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString * ID = @"addressCell";
        getOrderTableViewCellAddress * addressCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!addressCell) {
            addressCell = [[[NSBundle mainBundle] loadNibNamed:@"getOrderTableViewCellAddress" owner:self options:nil] firstObject];
        }
        
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [addressCell setTableViewCellWithAddress:_addressDic];
        
        return addressCell;
        
    }else if(indexPath.section == _DataArray.count - 1){
        static NSString * ID  = @"invoiceCell";
        invoiceTableViewCell * invoiceCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!invoiceCell) {

            invoiceCell = [[invoiceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        __weak getOrderViewController * weakSelf = self;
        invoiceCell.invoiceCellBolk = ^(NSString * tayeStr,NSString * uninNameStr){
            
            
            
            
            
            if ([tayeStr isEqualToString:@"tanqi"]) {
//                弹起
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = weakSelf.getOrderTableView.frame;
                    frame.origin.y = - weakSelf.keyboardHeight + 49;
                    weakSelf.getOrderTableView.frame = frame;
                    NSLog(@"%f",frame.origin.y);
                }];

                
                
            }else{
                NSLog(@"%@",uninNameStr);
                weakSelf.invoiceHeader = uninNameStr;
                
                [UIView animateWithDuration:0.2 animations:^{
                    CGRect frame = weakSelf.getOrderTableView.frame;
                    frame.origin.y = 0;
                    weakSelf.getOrderTableView.frame = frame;
                }];

            
            }
            
        };
        
        invoiceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return invoiceCell;
        
    }else{
        static NSString * ID = @"goodsCell";
        getOrderTableViewCellGoods * goodsCell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!goodsCell) {
            goodsCell = [[[NSBundle mainBundle] loadNibNamed:@"getOrderTableViewCellGoods" owner:self options:nil] lastObject];
        }

        goodsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [goodsCell setTableViewCellWithShoppModel:[_DataArray[indexPath.section] lastObject][indexPath.row]];
        
        
        return goodsCell;
    }
}

#pragma mark
//开具发票 开关
-(void)invoiceSwitchClick:(UISwitch *)witch{
    if (witch.isOn) {
        NSLog(@"开");
        _invoiceBOOL = YES;
        
        [_getOrderTableView reloadSections:[NSIndexSet indexSetWithIndex:_DataArray.count-1] withRowAnimation:UITableViewRowAnimationFade];

        [_getOrderTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_DataArray.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }else{
        NSLog(@"关");
        _invoiceBOOL = NO;
        _invoiceHeader = @"";
        [_getOrderTableView reloadSections:[NSIndexSet indexSetWithIndex:_DataArray.count-1] withRowAnimation:UITableViewRowAnimationFade];

    }
    
//    [self tableView:_getOrderTableView numberOfRowsInSection:_DataArray.count - 1];
    

}

#pragma mark - 提交订单点击事件
-(void)submitOrdersButtonClick:(UIButton *)button{
    if ([UserData sharkedUser].uid == nil) {
        CheckinViewController * cvc = [CheckinViewController new];
        cvc.tayeInfrom = YES;
        cvc.returnTayeBlock = ^(BOOL returnTaye){
            _returnTaye = YES;
        };
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cvc] animated:YES completion:nil];

    }else{
        if(_addressDic[@"mobile"]==nil){
            
            __weak getOrderViewController *weakself = self;
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"主人！" message:@"还没填写默认收货地址哦，让奴家怎么给您发货啊！" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //            [weakself dismissViewControllerAnimated:YES completion:nil];
                //            [weakself.navigationController popViewControllerAnimated:YES];
            }];
            
            UIAlertAction *phone = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                addressViewController * addressVC = [[addressViewController alloc]init];
                addressVC.isfrom = 100;
                
                [weakself.navigationController pushViewController:addressVC animated:YES];
                
            }];
            
            [alertC addAction:cancleAction];
            [alertC addAction:phone];
            
            [self presentViewController:alertC animated:YES completion:nil];
            
            
        }else{
            
            NSLog(@"%@",_DataArray);
            NSString * orderURL;
//            button.userInteractionEnabled = NO;
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            long long int data = (long long int)a;
            NSString * time = [NSString stringWithFormat:@"%lld", data];
            
            
            NSMutableDictionary * ordmDic = [NSMutableDictionary dictionary];
            
//            [ordmDic setObject:[[UIDevice currentDevice].identifierForVendor UUIDString] forKey:@"devicesn"];
            
            ordmDic[@"uid"] = [UserData sharkedUser].uid;
            ordmDic[@"time"] = time;
            
            if (_invoiceHeader == nil) {
                _invoiceHeader = @"";
            }
            
            NSString * total_prices = [NSString stringWithFormat:@"%.2f",[self zongPrice]];
            
            
            ordmDic[@"total_prices"] = total_prices;
            ordmDic[@"invoice_name"] = _invoiceHeader;
            
/*
             if (_invoiceSwitch.isOn) {
             [ordmDic setObject:_invoiceHeader forKey:@"invoice_name"];
             }else{
             [ordmDic setObject:@"" forKey:@"invoice_name"];
             }
             
             
             
             
             if (_shoppingCarInfo) {
             
             [ordmDic setObject:[self setLeaveMessage] forKey:@"leave_message"];
             
             }else{
             [ordmDic setObject:_messageArray[1] forKey:@"leave_message"];
             }
             */
            
            
            if (_shoppingCarInfo) {
                orderURL = setOrderURLstring;
                NSString * car_id = [self joiningTogetherCar_id:_DataArray];
                id leave_message = [self setLeaveMessage];
                
                ordmDic[@"car_id"] = car_id;
                ordmDic[@"leave_message"] = leave_message;
                
                ordmDic[@"sign"] = [NSString stringWithFormat:@"order%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,car_id,_invoiceHeader,leave_message,total_prices].md5String;
//                NSLog(@"%@",[NSString stringWithFormat:@"order%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,car_id,_invoiceHeader,leave_message,total_prices]);
                
            }else{
                orderURL = nowBuyURLstring;
                shoppingModel * model = [[shoppingModel alloc]init];
                model = [_DataArray[1] lastObject][0];
                
                [ordmDic setObject:model.goods_id forKey:@"goods_id"];
                [ordmDic setObject:model.num forKey:@"num"];
                [ordmDic setObject:model.color forKey:@"color"];
                [ordmDic setObject:model.size forKey:@"size"];
                [ordmDic setObject:_messageArray[1] forKey:@"leave_message"];
                
                ordmDic[@"sign"] = [NSString stringWithFormat:@"buyNow%@%@%@%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,model.color,model.goods_id,_invoiceHeader,_messageArray[1],model.num,model.size,total_prices].md5String;
//                NSLog(@"%@",[NSString stringWithFormat:@"buyNow%@%@%@%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,model.color,model.goods_id,_invoiceHeader,_messageArray[1],model.num,model.size,total_prices]);
                
            }
            
            
            

            

            NSLog(@"上传订单%@",ordmDic);
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:orderURL parameters:ordmDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"上传订单完成：%@",[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]);
                NSDictionary * objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if ([objc[@"info"] isEqualToString:@"o005"]) {
                    
                    payOrderViewController * payVC = [[payOrderViewController alloc] init];
                    payVC.orderDic = objc;
                    payVC.shoppingCarInfo = _shoppingCarInfo;
                    
                    
                    [self.navigationController pushViewController:payVC animated:YES];
                    if(!_shoppingCarInfo){
                        
                        NSMutableArray * marr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        [marr removeObjectAtIndex:(marr.count - 2)];
                        self.navigationController.viewControllers = marr;
                    }
                    
                    
                    NSLog(@"%@",self.navigationController.viewControllers);
//
                    
                    
                }else if ([objc[@"info"]isEqualToString:@"u019"]) {
                    
                    [UserData sharkedUser].uid = nil;
                    [SVProgressHUD showErrorWithStatus:@"登录已失效！"];
                }
                
                button.userInteractionEnabled = YES;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
                
                NSLog(@"上传订单出错 error = %@",error);
                button.userInteractionEnabled = YES;
                
            }];
            
            
            
            
        }
    }
    
}
-(NSString *)joiningTogetherCar_id:(NSArray *)arr{
    NSMutableString * mstr = [NSMutableString string];
    for (int i = 1; i <= arr.count - 2; i++) {
        for (shoppingModel * model in [arr[i] lastObject]) {
            [mstr appendString:[NSString stringWithFormat:@"%@,",model.car_id]];
        }
        [mstr deleteCharactersInRange:NSMakeRange(mstr.length-1, 1)];
        [mstr appendString:@"-"];
        

    }
    NSLog(@"%@",mstr);
    [mstr deleteCharactersInRange:NSMakeRange(mstr.length-1, 1)];
    NSLog(@"%@",mstr);
    return mstr;
}

-(void)leftItemBttClick{
    
    if (_shoppingCarInfo) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(KeyBoardBrak)];
    
    [self.view addGestureRecognizer:tap];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSArray * allGesture = self.view.gestureRecognizers;
    for (UIGestureRecognizer * gesture in allGesture) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:gesture];
        }
        
    }
}

#pragma mark - textView代理
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.getOrderTableView.frame;
        frame.origin.y = - self.keyboardHeight + 49 + 20;
        self.getOrderTableView.frame = frame;
    }];
    
    
    
    return  YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.getOrderTableView.frame;
        frame.origin.y = 0;
        self.getOrderTableView.frame = frame;
    }];
//    if (_messageArray.count < textView.tag-300) {
//        
//    }else{
//        
//    }
    [_messageArray replaceObjectAtIndex:textView.tag-300 withObject:textView.text];
    
    
    
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    UILabel * label = [textView viewWithTag:88];
    if ([textView.text length] == 0) {
        [label setHidden:NO];
    }else{
        [label setHidden:YES];
    }
}
#pragma mark - 退键盘手势方法
-(void)KeyBoardBrak{
    
//    [_textView11 resignFirstResponder];
   
    [self.view endEditing:YES];
}


//分组合计
-(float)jisuanzongjia:(NSArray *)arr{
    
    float zPrice = 0.0;
    
    for (shoppingModel * model in arr ) {
        zPrice +=[model.goods_price floatValue]*[model.num intValue];
    }
    
    return zPrice;
    
}
//总价
-(float)zongPrice{
    float zongPrice = 0.0;
    for (int i = 1; i <= _DataArray.count-2; i++) {
        zongPrice += [self jisuanzongjia:[_DataArray[i] lastObject]];
    }
    
    return zongPrice;
}
//生成“品牌ID=留言”的JSon数据
-(id)setLeaveMessage{
    NSMutableDictionary * mdic = [NSMutableDictionary dictionary];

    
        
        for (int i =1;i <= _DataArray.count-2;i++) {
            [mdic setObject:_messageArray[i] forKey:_DataArray[i][1]];
            
        }
    
    
    
    return [mdic JSONString];
    
}

@end
