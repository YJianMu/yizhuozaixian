//
//  BFShareView.m
//  缤微纷购
//
//  Created by 程召华 on 16/3/12.
//  Copyright © 2016年 xinxincao. All rights reserved.
//
#define navigationViewHeight 44.0f
#define pickViewViewHeight  250
#define buttonWidth 60.0f
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define ButtonWH  50



#import "BFShareView.h"

#import <QuartzCore/QuartzCore.h>

#import "UIView+Frame.h"

#import "BFSoundEffect.h"

static id _publishContent;
@interface BFShareView ()
/**微信朋友圈分享按钮*/
@property (nonatomic, strong) UIButton *moments;
/**QQ空间分享按钮*/
@property (nonatomic, strong) UIButton *QQZone;
/**QQ好友分享按钮*/
@property (nonatomic, strong) UIButton *QQFriends;
/**新浪分享按钮*/
@property (nonatomic, strong) UIButton *sinaBlog;
/**微信好友分享按钮*/
@property (nonatomic, strong) UIButton *wechatFriends;
@end

@implementation BFShareView

+ (instancetype)shareView{
    
    BFShareView *share = [[BFShareView alloc] init];
    
    [share showShareView];
    
    return share;
}

- (id)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setUpView];
        [self addTapGestureRecognizerToSelf];
    }
    return self;
}

- (void)addTapGestureRecognizerToSelf {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
}

- (void)setUpView {
    self.moments = [self setUpButtonWithFrame:CGRectMake(ScreenWidth * 0.5 - 25, ScreenHeight, ButtonWH, ButtonWH) image:@"share_icon_friends" type:BFShareButtonTypeMoments];
    
    self.QQZone = [self setUpButtonWithFrame:CGRectMake(ScreenWidth * 0.5 - 25 - 60, ScreenHeight + 40, ButtonWH, ButtonWH) image:@"share_icon_zone" type:BFShareButtonTypeQQZone];
   
    
    self.QQFriends = [self setUpButtonWithFrame:CGRectMake(ScreenWidth * 0.5 - 25 - 35, ScreenHeight + 110, ButtonWH, ButtonWH) image:@"share_icon_qq" type:BFShareButtonTypeQQFriends];
    
    
    self.sinaBlog = [self setUpButtonWithFrame:CGRectMake(ScreenWidth * 0.5 - 25 + 35, ScreenHeight+110, ButtonWH, ButtonWH) image:@"share_icon_collect" type:BFShareButtonTypeWeChatCollect];
    
    
    self.wechatFriends = [self setUpButtonWithFrame:CGRectMake(ScreenWidth * 0.5 - 25 + 60, ScreenHeight+40, ButtonWH, ButtonWH) image:@"share_icon_wechat" type:BFShareButtonTypeWechatFriends];
   
}

- (void)showShareView {
    [BFSoundEffect playSoundEffect:@"composer_open.wav"];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.8 delay:0.1f usingSpringWithDamping:0.5f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.moments.y = 120;
        self.backgroundColor = windowColor;
    } completion:nil];
    
    [UIView animateWithDuration:1.0 delay:0.08f usingSpringWithDamping:0.5f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.QQZone.y = 160;
    } completion:nil];
    
    [UIView animateWithDuration:1.2 delay:0.1f usingSpringWithDamping:0.5f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.QQFriends.y = 230;
    } completion:nil];
    
    [UIView animateWithDuration:1.2 delay:0.08f usingSpringWithDamping:0.5f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.sinaBlog.y = 230;
    } completion:nil];
    
    [UIView animateWithDuration:1.0 delay:0.1f usingSpringWithDamping:0.5f initialSpringVelocity:.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.wechatFriends.y = 160;
    } completion:nil];
}

- (void)hideShareView {
    [UIView animateWithDuration:1 delay:0.2f usingSpringWithDamping:1.0f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.moments.y = ScreenHeight;
        self.backgroundColor = [UIColor clearColor];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:1 delay:0.16f usingSpringWithDamping:1.0f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.QQZone.y = ScreenHeight+40;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:1 delay:0.12f usingSpringWithDamping:1.0f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.wechatFriends.y = ScreenHeight+40;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:1 delay:0.08f usingSpringWithDamping:1.0f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.QQFriends.y = ScreenHeight+110;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:1 delay:0.04f usingSpringWithDamping:1.0f initialSpringVelocity:1.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.sinaBlog.y = ScreenHeight+110;
    } completion:^(BOOL finished) {
        //[self removeFromSuperview];
    }];
    
}

- (void)hide {
     [BFSoundEffect playSoundEffect:@"composer_close.wav"];
    [self hideShareView];
}

- (UIButton *)setUpButtonWithFrame:(CGRect)frame image:(NSString *)image type:(BFShareButtonType)type{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.tag = type;
    button.layer.shadowOffset = CGSizeMake(0, 0);
    //button.layer.shadowColor = BFColor(0x000000).CGColor;
    button.layer.shadowOpacity = 0.7;
    button.layer.cornerRadius = 25.0;
    //button.layer.masksToBounds = YES;
    //button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}


- (void)clickToShare:(UIButton *)sender {
    
    [BFSoundEffect playSoundEffect:@"composer_open.wav"];
    
    int shareType = 0;
    switch (sender.tag) {
        case BFShareButtonTypeMoments:
            shareType = SSDKPlatformSubTypeWechatTimeline;
            break;
        case BFShareButtonTypeWechatFriends:
            shareType = SSDKPlatformSubTypeWechatSession;
            break;
        case BFShareButtonTypeQQZone:
            shareType = SSDKPlatformSubTypeQZone;
            break;
        case BFShareButtonTypeQQFriends:
            shareType = SSDKPlatformTypeQQ;
            break;
        case BFShareButtonTypeWeChatCollect:
            shareType = SSDKPlatformSubTypeWechatFav;
            break;
        default:
            break;
    }
    
    [self hideShareView];
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.goodsname
                                     images:self.goodsimage//传入要分享的图片
                                        url:self.goodsurl
                                      title:@"衣着在线"
                                       type:SSDKContentTypeAuto];

    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        NSLog(@"%@",error);
        if (state == SSDKResponseStateSuccess) {
            [self hideShareView];
            
            
        }else if (state == SSDKResponseStateFail) {
            [self hideShareView];
            
            
        }else if (state == SSDKResponseStateSuccess) {
            [self hideShareView];
            
        }
    }];
    
}





@end
