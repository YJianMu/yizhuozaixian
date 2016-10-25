//
//  CardsViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/19.
//  Copyright © 2016年 xincedong. All rights reserved.
//  卡券

#import "CardsViewController.h"
///** 环境设置 */
//#define UIColorFromRGB(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]
//#define NavigationBarHeight 64
//
///** 用户设置 */
//#define ButtonViewHeight 50
//#define ButtonViewBGColor UIColorFromRGB(0xfeffff)
//#define ButtonTitleColor UIColorFromRGB(0x000000)
//#define ButtonSelectedColor UIColorFromRGB(0xeeeeee)

@interface CardsViewController ()<UIGestureRecognizerDelegate>
//@property (nonatomic, strong) NSArray *btnTitles;
//@property (nonatomic, strong) NSArray *btns;
//@property (nonatomic, strong) NSArray *views;
@property (nonatomic ,strong) UIButton *firstBtn;
@property (nonatomic ,strong) UIButton *secondBtn;
@property (nonatomic ,strong) UIView *myview;

@end

@implementation CardsViewController


- (UIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(0, 0, ScreenWidth*0.5, 50) andBackgroundColor:[UIColor whiteColor] andText:@"红包" andTextColor:[UIColor blackColor] andTextFont:nil andTarget:self andSelector:@selector(clickFirstBtn)];
        //[_firstBtn setBackgroundImage:[UIImage imageNamed:@"new_btn_exp_n"] forState:UIControlStateSelected];
    }
    return _firstBtn;
}
- (UIButton *)secondBtn{
    if (!_secondBtn) {
        _secondBtn = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(ScreenWidth*0.5, 0, ScreenWidth*0.5, 50) andBackgroundColor:[UIColor whiteColor] andText:@"卡券" andTextColor:[UIColor blackColor] andTextFont:nil andTarget:self andSelector:@selector(clickSecondBtn)];
        //[_secondBtn setBackgroundImage:[UIImage imageNamed:@"new_btn_exp_n"] forState:UIControlStateSelected];

    }
    return _secondBtn;
}

- (UIView *)myview{
    if (!_myview) {
        _myview = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 50 - 49)];
        _myview.backgroundColor = [UIColor grayColor];
    }
    return _myview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.alpha = 1;
//    self.navigationController.navigationBar.tintColor = nil;
//    self.navigationController.navigationBar.translucent = NO;
//    [self setupData];
//    [self setupButtonsView];
//    [self setupViews];
    
    [self.view addSubview:self.firstBtn];
    [self.view addSubview:self.secondBtn];
    [self.view addSubview:self.myview];
    [self clickFirstBtn];
    
    
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

- (void)clickFirstBtn{
//    self.firstBtn.selected = YES;
//    self.secondBtn.selected = NO;
    self.firstBtn.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    self.secondBtn.backgroundColor = [UIColor whiteColor];
    [_myview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.myview.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    UIImageView * image1 = [MyViewCreateControl initImageVierWithFrame:CGRectMake((ScreenWidth-80)/2, (ScreenHeight-80)/2-80, 80, 80) andBackgroundColor:nil andBackgroundNameOfImage:@"coupon_icon_n.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    [_myview addSubview:image1];
    UILabel * label1 = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, (ScreenHeight-80)/2 + 40 , ScreenWidth, 40) andBackgroundColor:[UIColor clearColor] andText:@"您暂还没有红包信息 ~ ~ ~" andTextFont:14 andTextAlignment:NSTextAlignmentCenter];
    [_myview addSubview:label1];
}

- (void)clickSecondBtn{
//    self.secondBtn.selected = YES;
//    self.firstBtn.selected = NO;
    self.secondBtn.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    self.firstBtn.backgroundColor = [UIColor whiteColor];
    [_myview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.myview.backgroundColor = [UIColor colorWithHexString:@"#ebebF4"];
    UIImageView * image2 = [MyViewCreateControl initImageVierWithFrame:CGRectMake((ScreenWidth-80)/2, (ScreenHeight-80)/2-80, 80, 80) andBackgroundColor:nil andBackgroundNameOfImage:@"card_icon_n.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    [_myview addSubview:image2];
    UILabel * label2 = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, (ScreenHeight-80)/2 + 40, ScreenWidth, 40) andBackgroundColor:[UIColor clearColor] andText:@"您暂还没有卡券信息 ~ ~ ~" andTextFont:14 andTextAlignment:NSTextAlignmentCenter];
    [_myview addSubview:label2];
}

- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}



//- (void)setupData {
//    self.title = @"我的卡卷";
//    _btns = [NSArray array];
//    _views = [NSArray array];
//    
//    _btnTitles = @[@"红包", @"卡片"];
//}
//
///** 每一个的按钮:index从0开始 */
//- (void)setupViewContentWithButton:(UIButton*)button index:(int)index {
//    if (index==0) {
//        [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//        [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateSelected)];
//    } else if (index==1) {
//        [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
//        [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateSelected)];
//    }
//}
//
///** 每一页的内容:index从0开始 */
//- (void)setupViewContentWithView:(UIView*)view index:(int)index {
//    //doSomeThing..
//    view.frame = CGRectMake(ScreenWidth * index,
//                            ButtonViewHeight,
//                            ScreenWidth,
//                            ScreenHeight - (NavigationBarHeight+ButtonViewHeight+49));
//    if (index==0) {
//        view.backgroundColor = UIColorFromRGB(0x0000ff);
//    } else if (index==1) {
//        view.backgroundColor = UIColorFromRGB(0x00ff00);
//    }
//}
//
//#pragma mark - framework(下面开始不关你事..)
//- (void)setupButtonsView {
//    UIView *backgroundView = [UIView new];
//    backgroundView.frame = CGRectMake(0, 0, ScreenWidth, ButtonViewHeight);
//    backgroundView.backgroundColor = ButtonViewBGColor;
//    [self.view addSubview:backgroundView];
//    
//    /** 设置btn */
//    NSMutableArray *tempArray = [NSMutableArray array];
//    for (int i=0; i<_btnTitles.count; i++) {
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        button.tag = i; //tag值从0开始
//        button.frame = CGRectMake((ScreenWidth/_btnTitles.count)*i, 0,
//                                  (ScreenWidth/_btnTitles.count),
//                                  ButtonViewHeight);
//        [button setTitle:_btnTitles[i] forState:(UIControlStateNormal)];
//        [button setTitleColor:ButtonTitleColor forState:(UIControlStateNormal)];
//        if (i==0) {
//            button.selected = YES;
//        }
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        [backgroundView addSubview:button];
//        [tempArray addObject:button];
//        [self setupViewContentWithButton:button index:i];
//    }
//    _btns = [tempArray mutableCopy];
//}
//
//- (void)setupViews {
//    NSMutableArray *tempArray = [NSMutableArray array];
//    for (int i=0; i<_btnTitles.count; i++) {
//        UIView *view = [UIView new];
//        [self.view addSubview:view];
//        [tempArray addObject:view];
//        [self setupViewContentWithView:view index:i];
//    }
//    _views = [tempArray copy];
//}
//
//- (void)btnClick:(UIButton*)button {
//    /** btn的切换状态 */
//    for (UIButton *btn in _btns) {
//        btn.selected = NO;
//    }
//    button.selected = !button.selected;
//    
//    for (UIButton *btn in _btns) {
//        btn.backgroundColor = [UIColor clearColor];
//        if (btn.selected) {
//            btn.backgroundColor = ButtonSelectedColor;
//        }
//    }
//    
//    /** view的切换动画 */
//    [UIView animateWithDuration:0.3 animations:^{
//        for (int i=0; i<_btnTitles.count; i++) {
//            UIView *view = _views[i];
//            CGRect tempFrame = view.frame;
//            tempFrame.origin.x = ScreenWidth*(i-button.tag);
//            view.frame = tempFrame;
//        }
//    }];
//    NSLog(@"btn:%@", button.titleLabel.text);
//}



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
