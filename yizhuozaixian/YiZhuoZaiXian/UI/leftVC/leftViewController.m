//
//  leftViewController.m
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import "leftViewController.h"
#import "rootViewController.h"
#import "classifitionDetailViewController.h"
#import "homeAdModel.h"


@interface leftViewController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic, assign) NSInteger previousRow;

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * DataArray;

@property(nonatomic,strong)NSMutableArray * isShow;

@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F54E28"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sidebar_bg.png"]];
    
    [self setData];
    
    [self setTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"%f",self.view.frame.size.width);
}
-(void)setTableView{
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 0.8125 * ScreenWidth, ScreenHeight-100) style:UITableViewStyleGrouped];
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"#F54E28"];
    
//    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];
    
}

-(void)setData{
    //判断是否有缓存数据
    if ([[EGOCache globalCache] hasCacheForKey:@"drawerVCData"]) {
        
        //获取缓存数据
        id cachdata = [[EGOCache globalCache] plistForKey:@"drawerVCData"];
        //解析
        NSArray * objc = [NSJSONSerialization JSONObjectWithData:cachdata options:0 error:nil];
        NSMutableArray * marray = [NSMutableArray array];
        for (NSDictionary * dic1 in objc) {
            NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
            [mdic setObject:dic1[@"superior"][@"cat_name"] forKey:@"name"];
            [mdic setObject:dic1[@"superior"][@"cat_img"] forKey:@"drawerTubiao"];
            [mdic setObject:[homeAdModel setModelWithArray:dic1[@"superior"][@"subordinate"]] forKey:@"erjimulu"];
            [marray addObject:mdic];
            
        }
        //返回数据，并刷新
        _DataArray = marray;
        
        _isShow = [NSMutableArray array];
        for (int i = 0; i < _DataArray.count; i++) {
            [_isShow addObject:[NSNumber numberWithBool:NO]];
        }
        
        [_myTableView reloadData];

        
    }
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak leftViewController * weakSelf = self ;
    [manager GET:drawerURLstring parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //把二进制数据缓存到本地，生成plis文件
        [[EGOCache globalCache] setPlist:[responseObject copy] forKey:@"drawerVCData"];
      
        NSArray * objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
 
        NSMutableArray * marray = [NSMutableArray array];
        for (NSDictionary * dic1 in objc) {
            NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
            [mdic setObject:dic1[@"superior"][@"cat_name"] forKey:@"name"];
            [mdic setObject:dic1[@"superior"][@"cat_img"] forKey:@"drawerTubiao"];
            [mdic setObject:[homeAdModel setModelWithArray:dic1[@"superior"][@"subordinate"]] forKey:@"erjimulu"];
            [marray addObject:mdic];
            
        }
        
        weakSelf.DataArray = marray;
        
        weakSelf.isShow = [NSMutableArray array];
        for (int i = 0; i < weakSelf.DataArray.count; i++) {
            [_isShow addObject:[NSNumber numberWithBool:NO]];
        }

        [weakSelf.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        
    }];

    

    
}

-(void)headerButClick:(UIButton *)button{

    
    for (int i = 0 ; i < _DataArray.count; i++) {
        if ([_isShow[i] boolValue] == YES && i != button.tag-100) {
            
            _isShow[i] = [NSNumber numberWithBool:NO] ;
            
            [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:i] withRowAnimation:UITableViewRowAnimationFade];

        }
    }
    
    
    
    _isShow[button.tag-100] = [_isShow[button.tag-100] boolValue] ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES];


    [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag - 100] withRowAnimation:UITableViewRowAnimationFade];

//    [_myTableView reloadData];

    
    
}


#pragma mark - tablewView代理方法实现

#pragma mark    设置组头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton * headerBut = [[UIButton alloc]init];
    
    //没有高亮图片
    headerBut.adjustsImageWhenHighlighted = NO;
    
    headerBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    headerBut.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    headerBut.tintColor = [UIColor whiteColor];
    [headerBut setTitle:_DataArray[section][@"name"] forState:UIControlStateNormal];
    headerBut.titleLabel.font = [UIFont systemFontOfSize:18];
//    headerBut.backgroundColor = [UIColor colorWithHexString:@"#F54E28"];
    headerBut.backgroundColor = [UIColor clearColor];
    
//    headerBut.frame = CGRectMake(0, 0, 80, 40);
    headerBut.tag = section + 100;
    [headerBut addTarget:self action:@selector(headerButClick:) forControlEvents:UIControlEventTouchUpInside];
    headerBut.selected = [_isShow[headerBut.tag-100] boolValue];
    [headerBut setImage:[UIImage imageNamed:@"sidebar_icon_pull-down_n.png"] forState:UIControlStateNormal];
    [headerBut setImage:[UIImage imageNamed:@"sidebar_icon_pull-up_n.png"] forState:UIControlStateSelected];
    headerBut.imageEdgeInsets = UIEdgeInsetsMake(10, tableView.frame.size.width-40, 10, 0);
    
    
    UIImageView * drawerTubiaoImageView = [MyViewCreateControl initImageVierWithFrame:CGRectMake(32, 16, 18, 18) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:nil andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    [drawerTubiaoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_DataArray[section][@"drawerTubiao"]]] placeholderImage:[UIImage imageNamed:@"sidebar_icon_clothes_n.png"]];
    [headerBut addSubview:drawerTubiaoImageView];
    
    UIImageView * drawerLineImageView = [MyViewCreateControl initImageVierWithFrame:CGRectMake(60, 48, tableView.frame.size.width-10-60, 1) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"sidebar_underline_n.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    drawerLineImageView.alpha = 0.6;
    [headerBut addSubview:drawerLineImageView];
    
    if (section==0) {
        
        UIImageView * drawerLine2ImageView = [MyViewCreateControl initImageVierWithFrame:CGRectMake(60, 1, tableView.frame.size.width-10-60, 1) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"sidebar_underline_n.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
        drawerLine2ImageView.alpha = 0.6;
        [headerBut addSubview:drawerLine2ImageView];
        
    }
    
    return headerBut;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//设置组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _DataArray.count;
}
//设置行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    NSArray * arr = _DataArray[section][@"erjimulu"];

    return [_isShow[section] boolValue] ? arr.count : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * ID = @"myCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.highlighted = YES;
    homeAdModel * model = _DataArray[indexPath.section][@"erjimulu"][indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"                  %@",model.cat_name];
    cell.textLabel.frame = CGRectMake(60, 0, ScreenWidth-60, 44);
    cell.textLabel.textColor  = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
        typeof(self) __weak weakSelf = self;
        
#pragma mark Drawer值返回区域
        [self.drawer reloadCenterViewControllerUsingBlock:^(){
            
            classifitionDetailViewController *  classifitionVC = [[classifitionDetailViewController alloc]init];
            homeAdModel * model = _DataArray[indexPath.section][@"erjimulu"][indexPath.row];
            classifitionVC.cat_id = model.cat_id;
            classifitionVC.goods_name = [NSString stringWithFormat:@"%@-%@",model.keywords,model.cat_name];
            
            [classifitionVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:classifitionVC];
            nvc.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
            [weakSelf presentViewController:nvc animated:YES completion:nil];
            
        }];
        
         self.previousRow = indexPath.row;

}


#pragma mark - Configuring the view’s layout behavior

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - ICSDrawerControllerPresenting代理

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}







@end
