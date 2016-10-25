//
//  screeningViewController.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/5/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "screeningViewController.h"
#import "screeningView.h"

@interface screeningViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)screeningView * screeningScrollView;
@property(nonatomic,strong)NSDictionary * upDic;
@end

@implementation screeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    
    [self setNavigation];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}

-(void)setNavigation{
    
    self.navigationItem.title = @"筛选";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ebebf4"];
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttnClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
    //    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    
    UISwipeGestureRecognizer * fanhuiSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(fanhuiSwipe:)];
    [self.view addGestureRecognizer:fanhuiSwipe];
    fanhuiSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    
}

-(void)leftItemBttnClick{
    
    //    CATransition *animation = [CATransition animation];
    //    animation.duration = 0.25;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    //        animation.type = @"rippleEffect";
    //    animation.type = kCATransitionPush;
    //    animation.subtype = kCATransitionFromLeft;
    //    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (void)setData{
    
    _dataArr = [NSMutableArray arrayWithArray:@[@[@"上装",@[@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"POLO",@"T恤"]],@[@"下装",@[@"牛仔裤",@"休闲裤",@"西裤",@"短裤",@"POLO",@"T恤"]],@[@"女装",@[@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"外套",@"针织衫",@"长袖衬衫",@"短袖衬衫",@"短袖衬衫"]]]];
    
    [_dataArr addObjectsFromArray:@[@[@"身高",@[@"cm"]],@[@"腰围",@[@"cm    ==",@"码"]],@[@"体重",@[@"kg"]]]];

    
}

- (void)createUI{

    _screeningScrollView = [[screeningView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 44) andWithDataModelArr:_dataArr];
    
    [self.view addSubview:_screeningScrollView];
    _screeningScrollView.screeningViewReturnBlock = ^(NSDictionary * dic){
        
        _upDic = dic;
        NSLog(@"回调上传参数：%@",dic);
        
    };
    
    UIButton * submitButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0, ScreenHeight - 44 - 64, ScreenWidth, 44) andBackgroundColor:[UIColor redColor] andText:@"提交" andTextColor:[UIColor whiteColor] andTextFont:[UIFont boldSystemFontOfSize:16] andTarget:self andSelector:@selector(submitButtonClick)];
    
    [self.view addSubview:submitButton];
    
}

- (void)submitButtonClick{
    
    NSLog(@"点击提交按钮");
    
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
