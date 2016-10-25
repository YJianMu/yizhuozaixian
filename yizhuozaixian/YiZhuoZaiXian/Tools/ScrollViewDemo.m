
#define KCureentView_W self.frame.size.width
#define KCureentView_H self.frame.size.height
#import "ScrollViewDemo.h"
@implementation ScrollViewDemo
{
    UIScrollView *_scrollView;
    UIPageControl *_page;
    NSTimer *_timer;
    int _currentPage;
    BOOL _isNetUrl;
    BOOL _isTimer;
}

-(id)initWithFrame:(CGRect)frame withIsNetUrl:(BOOL)isNetUrl andIsTimer:(BOOL)isTimer{
    
    if ([super initWithFrame:frame]) {
                self.userInteractionEnabled = YES;
                [self createUI];
        //       [self addPage]; // 不能放这里--》需要获取photoArrays的大小定义frame 和 numberOfPages
            }
    _isNetUrl = isNetUrl;
    _isTimer = isTimer;

    [self createUI];
        return self;
}

-(void)createUI{
  
    _scrollView = [UIScrollView new];
    _scrollView.frame =CGRectMake(0, 0, KCureentView_W, KCureentView_H);
    _scrollView.contentOffset = CGPointMake(KCureentView_W *1, 0);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    NSLog(@"%f",self.frame.size.width);
     NSLog(@"--%f",KCureentView_W);
    
}

#pragma mark - 内容
-(void)setPhotoArrays:(NSArray *)photoArrays{

         _photoArrays = photoArrays;
    
    _scrollView.contentSize = CGSizeMake(KCureentView_W * photoArrays.count, 0);
    
    for (int i = 0; i < photoArrays.count ; i++) {
      
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake( KCureentView_W*i, 0, KCureentView_W ,KCureentView_H);
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 +i;
        if (_isNetUrl) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:photoArrays[i]] placeholderImage:[UIImage imageNamed: @"hone_img_lb.png"]];
            
        }else{
            imageView.image = [UIImage imageNamed:photoArrays[i]];
        }
        
        [_scrollView addSubview:imageView];
        
        //
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [imageView addGestureRecognizer:tap];
    }
    
    [self startTimer];
    [self addPage];
    
}
#pragma mark - 相应页面-->内容回调
-(void)tapClick:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld",tap.view.tag-100);
    NSInteger page = tap.view.tag - 100;
    if (self.delegate) {
        [self.delegate ScrollViewDemoDelegateBackCurrentPage:page];
    }
    
    __weak typeof(self) s = self;
    if( s.backCurrentPage) {
        s.backCurrentPage(page);
    }
    
}
#pragma mark - 添加页码；
-(void)addPage{
    
    _page = [UIPageControl new];
    _page.frame = CGRectMake(0, 0, 10*self.photoArrays.count, 12);
    _page.center = CGPointMake(KCureentView_W/2, KCureentView_H-10);
    _page.pageIndicatorTintColor = [UIColor purpleColor];
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    _page.numberOfPages = self.photoArrays.count -2;
    _page.currentPage = 0;
    [self addSubview:_page];
    
    
}
#pragma mark - 添加时间控制器
-(void)startTimer{
    if (_isTimer) {
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
        }
    }
    
    
}
-(void)stopTimer{
 [_timer invalidate]; //  结束
    _timer = nil;

}
-(void)changePage{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +KCureentView_W, 0) animated:YES];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"开始--滚动");
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖动");
    [self stopTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"结束--滚动");
    _currentPage = scrollView.contentOffset.x/KCureentView_W;
    _page.currentPage = _currentPage -1;
    
    [self changeScrollContentOffSet];
//    [self startTimer]; // 不能放在这里
    /*
     015-11-21 13:23:39.639 ScrollView封装[14881:8118079] 开始拖动
     2015-11-21 13:23:44.159 ScrollView封装[14881:8118079] 结束--拖动
     */
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"结束--拖动");
     [self startTimer];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   _currentPage = scrollView.contentOffset.x/KCureentView_W;
    
    [self changeScrollContentOffSet];
}
#pragma mark - 循环滚动；
-(void)changeScrollContentOffSet{

    if (_currentPage == 0) {
       _currentPage = (int)self.photoArrays.count-2;
    }else if (_currentPage == self.photoArrays.count-1){
        _currentPage = 1;
    }
    
    _scrollView.contentOffset = CGPointMake(KCureentView_W *_currentPage, 0);
    _page.currentPage = _currentPage -1;
}

@end
