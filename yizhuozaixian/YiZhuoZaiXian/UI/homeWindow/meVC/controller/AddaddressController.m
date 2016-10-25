//
//  AddaddressController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/24.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "AddaddressController.h"
#import "AddAddressView.h"

@interface AddaddressController () <AddAddressViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) AddAddressView *addaddress;
@end

@implementation AddaddressController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.addaddress = [AddAddressView creatView];
    
    self.view = self.addaddress;
    self.addaddress.delegate = self;
    
    
    
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
}

- (void)dismissLeft{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
}
- (void)goBackToAddressView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addaddress" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
