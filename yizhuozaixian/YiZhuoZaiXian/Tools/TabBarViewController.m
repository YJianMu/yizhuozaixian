

#import "TabBarViewController.h"

//#import "MyViewCreateControl.h"

#define screenHeight [UIScreen mainScreen].bounds.size.height

#define screenWidth [UIScreen mainScreen].bounds.size.width

@interface TabBarViewController ()

//设置全局属性保存传递过来的参数
@property(nonatomic,strong)NSArray *photoArray;

@property(nonatomic,strong)NSArray *selectedPhotoArray;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,strong)NSArray *VCArray;


//当前选中按钮
@property(nonatomic,strong)UIButton *currentSelectedButton;

@property(nonatomic,strong)UIViewController *currenSelectedVC;


@end

@implementation TabBarViewController

//方法实现
-(id)initWithPhotoArray:(NSArray *)photoArray andSelectedPhotoArray:(NSArray *)selectedPhotoArray andTitleArray:(NSArray *)titleArray andViewControllers:(NSArray *)VCArray{
    if (self == [super init]) {
        //保存数据
        self.photoArray = photoArray;
        
        self.selectedPhotoArray = selectedPhotoArray;
        
        self.titleArray = titleArray;
        
        self.VCArray = VCArray;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册去逛逛通知（进入首页）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openIndex1) name:@"quguangguangtongzhi" object:nil];
    //注册进入购物车通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openIndex2) name:@"backshoppingtongzhi" object:nil];
    
    //设置tabBar的bar栏UI
    [self setTabBarImageView];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)setBgImageViewFram:(CGRect)Fram{
    _bgImageView.frame = Fram;
}

#pragma mark - 设置bar栏UI
-(void)setTabBarImageView{
    
    _bgImageView = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, screenHeight - 49, screenWidth, 49) andBackgroundColor:[UIColor colorWithHexString:@""] andBackgroundNameOfImage:@"" andUsInterfaceEnable:YES andContextMode:UIViewContentModeScaleToFill];
//    [self.view bringSubviewToFront:_bgImageView];

    _bgImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_bgImageView.layer.bounds].CGPath;
    _bgImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    _bgImageView.layer.shadowOpacity = 1.6f;
    _bgImageView.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    _bgImageView.layer.shadowRadius = 1.0;
    
    
    [self.view addSubview:_bgImageView];
    
    for (int i = 0; i < self.photoArray.count; i++) {
        
        UIButton *button = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(screenWidth/self.photoArray.count * i, 1, screenWidth/self.photoArray.count, 49) andBackgroundColor:[UIColor whiteColor] andImage:[UIImage imageNamed:self.photoArray[i]] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(buttonClick:)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0,0,5,0)];
        
        button.tag = 100 + i;
        
        [button setImage:[UIImage imageNamed:self.selectedPhotoArray[i]] forState:UIControlStateSelected];
        
        [_bgImageView addSubview:button];
        
        
        UILabel *label = [MyViewCreateControl initLabelWithFrame:CGRectMake(0, 49 - 15, screenWidth/self.photoArray.count, 15) andBackgroundColor:[UIColor clearColor] andText:self.titleArray[i] andTextFont:10 andTextAlignment:NSTextAlignmentCenter];
        
        label.textColor = [UIColor colorWithHexString:@"#808080"];
        
        label.tag = 1001;
        
        [button addSubview:label];
        
        //默认选中第一个
        if (i == 0) {
            button.selected = YES;
            label.textColor = [UIColor colorWithHexString:@"#fe0201"];
            //设置当前选中的按钮是第一个按钮
            self.currentSelectedButton = button;
            
            //添加第一个VC
            UIViewController *fVc = self.VCArray[0];
            
            fVc.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - 49);
            
            [self.view addSubview:fVc.view];
            
            [self addChildViewController:fVc];
            
            //保存当前vc
            self.currenSelectedVC = fVc;
        }
    }
}

/*******************************/

-(void)openIndex1{
    //模拟点击第一个bableBar按钮
    [self buttonClick:[_bgImageView viewWithTag:100]];
}

-(void)openIndex2{
    //模拟点击第二个bableBar按钮
    [self buttonClick:[_bgImageView viewWithTag:101]];
}
/*******************************/

-(void)buttonClick:(UIButton *)button{
    NSLog(@"按钮点击事件");
    
    if (button.tag == 101 || button.tag == 102) {
        NSLog(@"按钮2或3点击事件");
        
        self.returnMyCloseDrawerBlock();
        
    }
    
    //把原来的按钮selected状态设置为NO
    self.currentSelectedButton.selected = NO;
    
    //还原原来label颜色
    UILabel *label1 = (UILabel *)[self.currentSelectedButton viewWithTag:1001];
    
    label1.textColor = [UIColor colorWithHexString:@"#808080"];
    
    button.selected = YES;
    
    //还原原来label颜色
    UILabel *label2 = (UILabel *)[button viewWithTag:1001];
    
    label2.textColor = [UIColor colorWithHexString:@"#fe0201"];
    
    //重新给当前按钮赋值
    self.currentSelectedButton = button;
    
    
    //移除原来的vc
    [self.currenSelectedVC.view removeFromSuperview];
    
    [self.currenSelectedVC removeFromParentViewController];
    
    //切换vc
    UIViewController *fVc = self.VCArray[button.tag%100];
    
    fVc.view.frame = CGRectMake(0, 0, screenWidth, screenHeight - 49);
    
    [self.view addSubview:fVc.view];
    
    [self addChildViewController:fVc];
    
    //保存当前vc
    self.currenSelectedVC = fVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
