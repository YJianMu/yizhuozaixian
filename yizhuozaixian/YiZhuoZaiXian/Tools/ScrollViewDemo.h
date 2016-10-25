

#import <UIKit/UIKit.h>

@protocol ScrollViewDemoDelegate <NSObject>

@optional // 选择性
-(void)ScrollViewDemoDelegateBackCurrentPage:(NSInteger) pageIndex; // 方法回调-->1

@end


@interface ScrollViewDemo : UIView<UIScrollViewDelegate>

@property(nonatomic,strong) id<ScrollViewDemoDelegate>delegate;
/**快速创建ScrollView 第一个参数fram 第二个参数：表示是否为网络图片加载   第三个参数：自动却换页面*/
-(id)initWithFrame:(CGRect)frame withIsNetUrl:(BOOL)isNetUrl andIsTimer:(BOOL)isTimer;
@property (nonatomic,strong) NSArray *photoArrays;


@property (nonatomic, strong) void(^backCurrentPage)(NSInteger pageIndex);  // 方法回调-->2

@end

/**
 
 ScrollViewDemo *scrollView =[[ScrollViewDemo alloc] initWithFrame:[UIScreen mainScreen].bounds  withIsNetUrl:NO andIsTimer:NO];
 
 scrollView.photoArrays = @[@"Welcome_3.0_5.jpg",@"Welcome_3.0_1.jpg",@"Welcome_3.0_2.jpg",@"Welcome_3.0_3.jpg",@"Welcome_3.0_4.jpg",@"Welcome_3.0_5.jpg",@"Welcome_3.0_1.jpg"];
 
 scrollView.delegate = self;
 scrollView.backCurrentPage = ^(NSInteger pageAtIndex){
 NSLog(@"-----%ld------",pageAtIndex);
 };
 
 [self.view addSubview:scrollView];

 
 */