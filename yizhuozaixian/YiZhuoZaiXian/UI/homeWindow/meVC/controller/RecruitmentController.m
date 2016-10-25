//
//  RecruitmentController.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/13.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "RecruitmentController.h"

@interface RecruitmentController ()

@end

@implementation RecruitmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *Recruitment = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
//http://m.kuaidi100.com/index_all.html?type=[快递公司编码]&postid=[快递单号]&callbackurl=[点击"返回"跳转的地址]

//http://m.kuaidi100.com/index_all.html?type=quanfengkuaidi&postid=123456
  
//http://m.kuaidi100.com/index_all.html?type=全峰&postid=123456
    [Recruitment loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:Recruitment];
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
