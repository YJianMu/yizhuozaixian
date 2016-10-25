//
//  addressViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "addressViewController.h"
#import "AddaddressController.h"
#import "AddressTableViewCell.h"
#import "ChangeAddressController.h"
#import "AddressModel.h"
#import "shoppingCarChange.h"


@interface addressViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *addressArray;
@property (nonatomic,strong) UIButton *addbutton;


@end

@implementation addressViewController

- (UIButton *)addbutton{
    if (!_addbutton) {
        if (_isfrom == 100) {
            _addbutton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(20, ScreenHeight - 64 - 0.1*ScreenWidth -10, ScreenWidth - 40 , 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"添加地址" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(clickaddbutton:)];
            _addbutton.layer.cornerRadius = 10.0;
        }else{
            _addbutton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(20, ScreenHeight - 49 - 64 - 0.1*ScreenWidth -10, ScreenWidth - 40, 0.1*ScreenWidth) andBackgroundColor:[UIColor redColor] andText:@"添加地址" andTextColor:[UIColor whiteColor] andTextFont:nil andTarget:self andSelector:@selector(clickaddbutton:)];
            _addbutton.layer.cornerRadius = 10.0;
        }
        
        
    }
    return _addbutton;
}


-(NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc]init];
    }
    return _addressArray;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        if (_isfrom == 100) {
            _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 0.1*ScreenWidth -64 - 20) style:UITableViewStyleGrouped];
            _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
            
        }else{
            _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- 0.1*ScreenWidth - 49-64 - 20) style:UITableViewStyleGrouped];
            _myTableView.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
        }
    }
    return _myTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
//    self.myTableView.editing = YES;
    
     [self.view addSubview:self.myTableView];
    [self.view addSubview:self.addbutton];
    
    
    UIBarButtonItem * rightItem = [self editButtonItem];
    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCoder:button];
    
//    rightItem.image = [UIImage imageNamed:@"btn_cart_delete.png"];
    rightItem.tintColor = [UIColor whiteColor];
//    rightItem.title = @"";
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(dismissLeft)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addaddress) name:@"addaddress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeaddress) name:@"changeaddress" object:nil];
    [self loadNewData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addaddress" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeaddress" object:nil];
}

- (void)changeaddress{
    [self loadNewData];
}

- (void)addaddress{
    [self loadNewData];
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"addaddress" object:nil];
}


- (void)loadNewData{
    if ([[EGOCache globalCache] hasCacheForKey:@"addressListData"]) {
        id objc = [[EGOCache globalCache] plistForKey:@"addressListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:objc options:0 error:nil];
        NSLog(@"%@",json);
        [self.addressArray removeAllObjects];
        AddressModel *model = [AddressModel objectWithKeyValues:json];
        NSArray *array = [addrData objectArrayWithKeyValuesArray:model.addrData];
        [self.addressArray addObjectsFromArray:array];
        [self.myTableView reloadData];
    }
    
    __weak addressViewController *weakself = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"uid"] = [UserData sharkedUser].uid;
    param[@"sign"] = [NSString stringWithFormat:@"address%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token].md5String;
    param[@"time"] = time;
    
    [manager POST:AddressData parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[EGOCache globalCache] setPlist:responseObject forKey:@"addressListData"];
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       
        [weakself.addressArray removeAllObjects];
        AddressModel *model = [AddressModel objectWithKeyValues:json];
        NSArray *array = [addrData objectArrayWithKeyValuesArray:model.addrData];
        [weakself.addressArray addObjectsFromArray:array];
        [weakself.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
    }];
}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   AddressTableViewCell *cell = [AddressTableViewCell cellWithTableView:tableView];
    addrData *data = self.addressArray[indexPath.row];
    cell.model = data;
    return cell;    
}


- (void)clickaddbutton:(UIBarButtonItem *)sender{
    AddaddressController *add = [[AddaddressController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}


#pragma ---------tableViewDelegate----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    addrData *list = self.addressArray[indexPath.row];
    __weak AddaddressController *weakself = self;
    if (self.isfrom == 100) {
       
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];

        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"uid"] = [UserData sharkedUser].uid;
        param[@"address_id"] = list.address_id;
        param[@"address"] = list.address;
        param[@"detailAddress"] = list.detailAddress;
        param[@"isDefault"] = @"1";
        param[@"mobile"] = list.mobile;
        param[@"consignee"] = list.consignee;
        param[@"time"] = time;
        param[@"sign"] = [NSString stringWithFormat:@"modAddr%@%@%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,list.address,list.address_id,list.consignee,list.detailAddress,@"1",list.mobile].md5String;
        NSLog(@"%@",param);
        [manager POST:changeAddressUrl parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            NSLog(@"%@",json);
            if ([json[@"info"] isEqualToString:@"a005"]) {
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
            NSLog(@"%@",error);
        }];
    }else{
    
    ChangeAddressController *change = [[ChangeAddressController alloc]init];
    change.address = list.address;
    change.detailAddress = list.detailAddress;
    change.consignee = list.consignee;
    change.defaultNumber = list.isDefault;
    change.address_id = list.address_id;
    change.phone = list.mobile;
        NSLog(@"%@",list.isDefault);
        
        change.title = @"修改地址";
    [self.navigationController pushViewController:change animated:YES];
    }
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:animated];
}



- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [_addressArray count])
    {
        return NO;
    }
    return YES;
}
//增加或删除
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == [_addressArray count])
//    {
//        return UITableViewCellEditingStyleInsert;
//    }
//    
//    return UITableViewCellEditingStyleDelete;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//完成编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        //插入一条新条目的时候，会更新numberOfRowsInSection 方法，并且 运行一次cellForRowAtIndexPath，生成一个新增的cell
        //[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationRight];
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        //删除一条条目时，更新numberOfRowsInSection
        NSLog(@"%@",self.addressArray);
        addrData *addresslist = self.addressArray[indexPath.row];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"uid"] = [UserData sharkedUser].uid;
        param[@"address_id"] = addresslist.address_id;
        
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        long long int data = (long long int)a;
        NSString * time = [NSString stringWithFormat:@"%lld", data];
        param[@"time"] = time;
        param[@"sign"] = [NSString stringWithFormat:@"delAddre%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,addresslist.address_id].md5String;
        
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            shoppingCarChange *change = [[shoppingCarChange alloc] init];
            [change changeShoppingCarNumRequestWithDic:param andURLstr:delAddre];
        });

        [self.addressArray removeObjectAtIndex:indexPath.row];
        
        
        [_myTableView reloadData];
//        [_addressArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationBottom];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
