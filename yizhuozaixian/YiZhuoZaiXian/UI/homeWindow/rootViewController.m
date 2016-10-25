//
//  rootViewController.m
//  YiZhuoZaiXian
//
//  Created by Mac on 16/3/10.
//  Copyright (c) 2016年 xincedong. All rights reserved.
//

#import "rootViewController.h"
#import "homeViewController.h"
#import "shoppingViewController.h"
#import "meViewController.h"
#import "TabBarViewController.h"

@interface rootViewController ()

@end

@implementation rootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDrawer) name:@"cehuatongzhi" object:nil];

    [self setNavAndBar];
    
}

-(void)setNavAndBar{
    
    NSArray * photoArray=@[@"tab_home_n.png",@"tab_car_n.png",@"tab_personal_n.png"];
    
    NSArray * selectedPhotoArray=@[@"tab_home_s.png",@"tab_car_s.png",@"tab_personal_s.png"];
    
    NSArray * titleArray=@[@"首页",@"购物车",@"个人中心"];
    
    homeViewController * vc1=[[homeViewController alloc] init];
    UINavigationController * nvc1=[[UINavigationController alloc] initWithRootViewController:vc1];
    nvc1.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    
    shoppingViewController * vc2=[[shoppingViewController alloc] init];
    UINavigationController * nvc2=[[UINavigationController alloc] initWithRootViewController:vc2];
    nvc2.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    
    meViewController * vc3=[[meViewController alloc] init];
    UINavigationController * nvc3=[[UINavigationController alloc] initWithRootViewController:vc3];
    nvc3.navigationBar.barTintColor = [UIColor colorWithHexString:@"#ff1800"];
    
    
    NSArray * VCArray=@[nvc1,nvc2,nvc3];
    
    
    TabBarViewController * tabBarVC=[[TabBarViewController alloc] initWithPhotoArray:photoArray andSelectedPhotoArray:selectedPhotoArray andTitleArray:titleArray andViewControllers:VCArray];
    
    tabBarVC.returnMyCloseDrawerBlock = ^(){
        NSLog(@"returnMyCloseDrawerBlock");
        
//        [self.drawer close];
        
    };
    
    [self.view addSubview:tabBarVC.view];
    
    [self addChildViewController:tabBarVC];

}






#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}


- (void)openDrawer{
    [self.drawer open];
}



@end
