

#import "XCDLoadingView.h"


@interface XCDLoadingView ()
{
    UIView *view;
    UIActivityIndicatorView * activityIndicator;
}
@property(nonatomic,strong)XCDLoadingView * vii;

@end


@implementation XCDLoadingView

+(void)createXCDLoadingViewWithSuperView:(UIView *)superView{
    
    XCDLoadingView * vii = [self sharedManager];
    vii.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
    vii.backgroundColor = [UIColor blackColor];
    vii.alpha = 0.35;
    [superView addSubview:vii];
    
    [vii createXCDLoadingViewWithSuperView:superView];
}
-(void)createXCDLoadingViewWithSuperView:(UIView *)superView{
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:superView.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [superView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}
+(void)cancelXCDLoadingView{
    
    XCDLoadingView * vii = [self sharedManager];
    [vii cancelXCDLoadingView];
    
}
-(void)cancelXCDLoadingView{
    
    [activityIndicator stopAnimating];
    [self removeFromSuperview];
    
}
+ (XCDLoadingView *)sharedManager
{
    static XCDLoadingView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}









@end
