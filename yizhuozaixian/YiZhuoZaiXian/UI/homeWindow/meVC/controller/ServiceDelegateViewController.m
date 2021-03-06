//
//  ServiceDelegateViewController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "ServiceDelegateViewController.h"

@interface ServiceDelegateViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *mytextview;
@property (nonatomic,strong)UITextView * textview;
@end

@implementation ServiceDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textview = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth-10, ScreenHeight-20)];
    
//    NSRange range;
//    range.location = 0;
//    range.length = 0;
//    _textview.selectedRange = range;

    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"yizhuoServiceDelegate"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                    error:NULL];
    _textview.text = content;
    _textview.editable = NO;
    
    [self.view addSubview:_textview];
    
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

    
}
- (void)dismissLeft{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
   
    
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
