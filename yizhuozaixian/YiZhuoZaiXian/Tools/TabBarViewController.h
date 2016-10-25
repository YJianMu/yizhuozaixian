

#import <UIKit/UIKit.h>

typedef void(^MyCloseDrawerBlock)();

@interface TabBarViewController : UIViewController

@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,copy)MyCloseDrawerBlock returnMyCloseDrawerBlock;


-(void)setBgImageViewFram:(CGRect)Fram;

//需要传入参数
/*
 1.按钮的普通图片数组
 2.按钮的选中图片数组
 3.按钮的文字数组
 4.tabBarController所需要控制的VC数组
 */

//输出参数:self

//重写初始化方法,传入参数
-(id)initWithPhotoArray:(NSArray *)photoArray andSelectedPhotoArray:(NSArray *)selectedPhotoArray andTitleArray:(NSArray *)titleArray andViewControllers:(NSArray *)VCArray;

/** eq:
 
     NSArray * photoArray=@[@"tabbar_mainframe_ios7.png",@"tabbar_contacts_ios7.png",@"tabbar_discover_ios7.png",@"tabbar_me_ios7.png"];
     NSArray * selectedPhotoArray=@[@"tabbar_mainframeHL_ios7.png",@"tabbar_contactsHL_ios7.png",@"tabbar_discoverHL_ios7.png",@"tabbar_meHL_ios7.png"];
     NSArray * titleArray=@[@"微信",@"通讯录",@"发现",@"我的"];
     
     ViewController1 * vc1=[[ViewController1 alloc] init];
     UINavigationController * nvc1=[[UINavigationController alloc] initWithRootViewController:vc1];
     
     ViewController2 * vc2=[[ViewController2 alloc] init];
     UINavigationController * nvc2=[[UINavigationController alloc] initWithRootViewController:vc2];
     
     ViewController3 * vc3=[[ViewController3 alloc] init];
     UINavigationController * nvc3=[[UINavigationController alloc] initWithRootViewController:vc3];
     
     ViewController4 * vc4=[[ViewController4 alloc] init];
     UINavigationController * nvc4=[[UINavigationController alloc] initWithRootViewController:vc4];
     
     NSArray * VCArray=@[nvc1,nvc2,nvc3,nvc4];
     
     
     TabBarViewController * tabBarVC=[[TabBarViewController alloc] initWithPhotoArray:photoArray andSelectedPhotoArray:selectedPhotoArray andTitleArray:titleArray andViewControllers:VCArray];
     
     [self.view addSubview:tabBarVC.view];
     
     [self addChildViewController:tabBarVC];

 
 */


@end

