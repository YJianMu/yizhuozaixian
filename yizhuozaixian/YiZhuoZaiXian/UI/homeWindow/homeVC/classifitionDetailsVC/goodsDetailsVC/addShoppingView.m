//
//  addShoppingView.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "addShoppingView.h"
#import "UIButton+WebCache.h"
#import "CheckinViewController.h"
@interface addShoppingView()

//@property(nonatomic,strong)NSMutableArray * dataArrary;
@property(nonatomic,strong)goodsSizeModel * goodsModel;

@property(nonatomic,assign)NSInteger colorSeleter;
@property(nonatomic,assign)NSInteger sizeSeleter;

//@property(nonatomic,strong)UILabel * suLiangLabel;
@property(nonatomic,strong)NSString * imageURL;
@property(nonatomic,strong)shoppingModel * goodsSeleterModel;

@property(nonatomic,strong)UILabel * iconLabel;

@property(nonatomic,strong)gooodsDetailsVC * goodsVC;
//判断是否由会员专区进入（YES）
@property(nonatomic,assign)BOOL membersBool;
@end
@implementation addShoppingView

- (UIView *)initWithFrame:(CGRect)frame andWithDataModel:(goodsSizeModel *)goodsModel andImageURL:(NSString *)imageURL andAddshoppingOrNowbuy:(BOOL)addOrNowbuy andDic:(NSDictionary *)dic andMembersBool:(BOOL)membersBool andVC:(gooodsDetailsVC *)goodsVC{
    self = [super initWithFrame:frame];
    if (self) {
        _goodsVC = goodsVC;
        _goodsModel = goodsModel;
        _addOrNowbuy = addOrNowbuy;
        _imageURL = imageURL;
        _membersBool = membersBool;
        //选择尺码颜色时，获得默认值；
        _goodsSeleterModel = [[shoppingModel alloc]init];
        
        _goodsSeleterModel.num = @"1";
        _goodsSeleterModel.goods_name = _goodsModel.goods_name;
        if (_membersBool) {
            _goodsSeleterModel.goods_price = _goodsModel.member_price;
        }else{
            _goodsSeleterModel.goods_price = _goodsModel.shop_price;
            
        }        _goodsSeleterModel.goods_id = _goodsModel.goods_id;
        _goodsSeleterModel.goods_small_img = _imageURL;
        
        
        
        if ([_goodsModel.goods_color count] > 0) {
            
            _goodsSeleterModel.color = _goodsModel.goods_color[0];

        }
//        15777906557
        if ([_goodsModel.goods_size count] > 0) {
            _goodsSeleterModel.size = _goodsModel.goods_size[0];
        }
        
        
        [self setHeaderView];
        
        
        [self setScrollView];
        
        [self setFooterView];
        
        
    }


    return self;
}
-(void)setHeaderView{
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-ScreenWidth)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.35;
    [self addSubview:backgroundView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [backgroundView addGestureRecognizer:tap];
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-ScreenWidth - 64, ScreenWidth, 0.25 * ScreenWidth)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    
//    headerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:headerView.layer.bounds].CGPath;
//    headerView.layer.shadowColor = [UIColor grayColor].CGColor;
//    headerView.layer.shadowOpacity = 1.0f;
//    headerView.layer.shadowOffset = CGSizeMake(1.0, 0.0f);
//    headerView.layer.shadowRadius = 2.0;
    
    //产品图
    UIButton * goodsImage = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 10, 1.33 * (0.25 * ScreenWidth - 20) , 0.25 * ScreenWidth - 20) andBackgroundColor:[UIColor clearColor] andImage:nil andBackgroundImage:nil andTarget:nil andSelector:nil];
    goodsImage.layer.borderColor = UIColor.lightGrayColor.CGColor;
    goodsImage.layer.borderWidth = 1;
//    goodsImage.layer.cornerRadius = 6;
    goodsImage.layer.masksToBounds = YES;

    
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@",websiteURLstring,_imageURL]);

//    [goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_imageURL]] forState:UIControlStateNormal];
    [goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_imageURL]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"shop_img_smal.png"]];
    goodsImage.userInteractionEnabled = NO;
    
    [headerView addSubview:goodsImage];
    
    //产品价格
    UILabel * goodsPriceLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10+1.33 * (0.25 * ScreenWidth - 20)+10, 10, 200, 40) andBackgroundColor:[UIColor clearColor] andText:@"" andTextFont:18 andTextAlignment:NSTextAlignmentLeft];
    goodsPriceLabel.textColor = [UIColor redColor];
    NSString * sstr = _goodsModel.shop_price;
    goodsPriceLabel.text = [NSString stringWithFormat:@"￥ %@ ",sstr];
    
    //是否从会员中心进入，（YES则有-会员价格）
    if (_membersBool) {
        
        NSString *oldPrice = goodsPriceLabel.text;
        NSUInteger length = [oldPrice length];
        oldPrice = [NSString stringWithFormat:@"%@  %@",oldPrice,_goodsModel.member_price];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];

        [attri addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:[UIColor grayColor],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(1, length-1)];

        [goodsPriceLabel setAttributedText:attri];
        

    }
    

    [headerView addSubview:goodsPriceLabel];
    //库存
    UILabel * cycleLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10+1.33 * (0.25 * ScreenWidth - 20)+10, 40, 200, 40) andBackgroundColor:[UIColor clearColor] andText:@"" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
    cycleLabel.text = [NSString stringWithFormat:@"库存：%@ 件",_goodsModel.warn_number];
    [headerView addSubview:cycleLabel];
    
    //退出加入购物车 按钮
    UIButton * backButton = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(ScreenWidth - 15 - 20, 15, 20, 20) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"details_btn_fork_n.png"] andBackgroundImage:nil andTarget:self andSelector:@selector(backButtonClick:)];
    [headerView addSubview:backButton];
    
    //线
    UIImageView * lineImage = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, 0.25 * ScreenWidth-2, ScreenWidth,0.5) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    lineImage.alpha = 0.6;
    [headerView addSubview:lineImage];
}
-(void)setScrollView{
    
    UIScrollView  * scrollView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, ScreenHeight-ScreenWidth - 64 + 0.25 *ScreenWidth-2, ScreenWidth,2+(ScreenHeight - 64 - 44)-(ScreenHeight-ScreenWidth - 64 + 0.25 *ScreenWidth))];
    scrollView.contentSize = CGSizeMake(ScreenWidth, (60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5+60);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.alwaysBounceVertical = YES;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    
    //判断是否有尺码数据
    if ([_goodsModel.goods_size count]>0) {
        
        
#pragma mark 选择尺码
        //请选择尺码
        UILabel * label1 = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 10, 200, 25) andBackgroundColor:[UIColor clearColor] andText:@"请选择尺码" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [scrollView addSubview:label1];
        
        //已选尺码：
        //    UILabel * label2 = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 35, 200, 15) andBackgroundColor:[UIColor purpleColor] andText:@"已选尺码：44" andTextFont:12 andTextAlignment:NSTextAlignmentLeft];
        //    [scrollView addSubview:label2];
        
        NSLog(@"%@",_goodsModel);
        
        for (int i = 0 ; i < [_goodsModel.goods_size count];i++ ) {
            
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10 + i%4*((ScreenWidth-50)*0.25+10), 45+i/4*40, (ScreenWidth-50)*0.25, 30)];
            button.backgroundColor = [UIColor clearColor];
            button.tag = 400 + i;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0) {
                button.selected = YES;
                _sizeSeleter = 400;
            }else{
                button.selected = NO;
            }
            
            [button setBackgroundImage:[UIImage imageNamed:@"goods_getails_boreder_gray.png"] forState:UIControlStateNormal];
            //选中时背景图
            [button setBackgroundImage:[UIImage imageNamed:@"shop_icon_case_s.png"] forState:UIControlStateSelected];
            
            
            [button setTitle:_goodsModel.goods_size[i] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(sizeButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:button];
        }
        //线
        UIImageView * image2 = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, 45+[_goodsModel.goods_size count]/4*40+40+5, ScreenWidth, 0.5) andBackgroundColor:nil andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
        image2.alpha = 0.6;
        [scrollView addSubview:image2];
        

        
    }
    
#pragma mark  选择颜色
    //判断是否有颜色数据
    if ([_goodsModel.goods_color count] > 0) {
        [self setColorSelecte:scrollView];
    }
    
    
    //购买数量
    UILabel * buyLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, (60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5+20, 100, 20) andBackgroundColor:[UIColor clearColor] andText:@"购买数量" andTextFont:18 andTextAlignment:NSTextAlignmentLeft];
    [scrollView addSubview:buyLabel];
    
    //加
    UIButton * addButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(ScreenWidth-10-35-1,(60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5 +15, 35, 30) andBackgroundColor:[UIColor clearColor] andText:@"+" andTextColor:[UIColor redColor] andTextFont:[UIFont systemFontOfSize:22] andTarget:self andSelector:@selector(aaddButton:)];
    [addButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
        addButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
        addButton.layer.borderWidth = 1;
        addButton.layer.masksToBounds = YES;

    [scrollView addSubview:addButton];
    //数量
    UILabel * suLiangLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(ScreenWidth-10-35-50, (60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5 +15, 50, 30) andBackgroundColor:[UIColor colorWithHexString:@"#ffffff"] andText:@"1" andTextFont:16 andTextAlignment:NSTextAlignmentCenter];
    
        suLiangLabel.layer.borderColor = UIColor.lightGrayColor.CGColor;
        suLiangLabel.layer.borderWidth = 1;
        suLiangLabel.layer.masksToBounds = YES;
    
    suLiangLabel.tag = 7650;
    [scrollView addSubview:suLiangLabel];
    //减
    UIButton * reduceButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(ScreenWidth-10-35-50-35+1,(60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5  + 15, 35, 30) andBackgroundColor:[UIColor clearColor] andText:@"-" andTextColor:[UIColor redColor] andTextFont:[UIFont systemFontOfSize:22] andTarget:self andSelector:@selector(rreduceButton:)];
    [reduceButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
        reduceButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
        reduceButton.layer.borderWidth = 1;
        reduceButton.layer.masksToBounds = YES;

    [scrollView  addSubview:reduceButton ];
    

}


-(void)setColorSelecte:(UIScrollView *)scrollView
{
    //请选择颜色
    UILabel * colorLaber = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+[_goodsModel.goods_size count]/4*40+40, 100, 25)];
    colorLaber.font = [UIFont systemFontOfSize:15];
    colorLaber.text = @"请选择颜色";
    colorLaber.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:colorLaber];
    
    //已选择颜色
    
//    UILabel * colorSeleteLaber = [[UILabel alloc]initWithFrame:CGRectMake(10, 60+[_goodsModel.goods_size count]/4*40+40 + 25, 100, 15)];
//    colorSeleteLaber.text = @"已选择颜色：白色";
//    colorSeleteLaber.backgroundColor = [UIColor purpleColor];
//    [scrollView addSubview:colorSeleteLaber];
    
    for (int i = 0 ; i < [_goodsModel.goods_color count];i++ ) {
        
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10 + i%4*((ScreenWidth-50)*0.25+10), (60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+i/4*40, (ScreenWidth-50)*0.25, 30)];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 800 + i;
        if (i == 0) {
            button.selected = YES;
            _colorSeleter = 800;
        }else{
            button.selected = NO;
        }
        
        button.tintColor = [UIColor blackColor];
        [button setBackgroundImage:[[UIImage imageNamed:@"goods_getails_boreder_gray.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:20] forState:UIControlStateNormal];
        //选中颜色时背景图
        [button setBackgroundImage:[UIImage imageNamed:@"shop_icon_case_s.png"] forState:UIControlStateSelected];
        
        
        [button setTitle:_goodsModel.goods_color[i] forState:UIControlStateNormal];
        
        
        
        [button addTarget:self action:@selector(colorButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [scrollView addSubview:button];
    }
    //线
    UIImageView * image2 = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, (60+[_goodsModel.goods_size count]/4*40+40 + 25 + 10)+[_goodsModel.goods_color count]/4*40+40+5, ScreenWidth, 0.5) andBackgroundColor:nil andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
    image2.alpha = 0.6;
    [scrollView addSubview:image2];
    
}
-(void)setFooterView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 44, ScreenWidth,44 )];
    footerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:footerView];
    
    footerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:footerView.layer.bounds].CGPath;
    footerView.layer.shadowColor = [UIColor grayColor].CGColor;
    footerView.layer.shadowOpacity = 1.0f;
    footerView.layer.shadowOffset = CGSizeMake(0.0, 1.0f);
    footerView.layer.shadowRadius = 2.0;
    
    
    //线
//    UIImageView * lineImage = [MyViewCreateControl initImageVierWithFrame:CGRectMake(0, 0, ScreenWidth, 1) andBackgroundColor:[UIColor clearColor] andBackgroundNameOfImage:@"goods_getails_line.png" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
//    [footerView addSubview:lineImage];
    
    
    
    //购物车 border_gray.png
    UIButton * shoppingButton = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 0.25 * ScreenWidth , 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"tab_car_n.png"] andBackgroundImage:[UIImage imageNamed:@"border_gray.png"] andTarget:self andSelector:@selector(shoppingButtonClick:)];
    shoppingButton.tag = 120;
//    shoppingButton.layer.borderColor = UIColor.grayColor.CGColor;
//    shoppingButton.layer.borderWidth = 1;
//    shoppingButton.layer.cornerRadius = 6;
//    shoppingButton.layer.masksToBounds = YES;
    shoppingButton.adjustsImageWhenHighlighted = NO;
    [footerView addSubview:shoppingButton];
    
    _iconLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(0.25 * 0.5 * ScreenWidth+10, -8, 26, 18) andBackgroundColor:[UIColor redColor] andText:[NSString stringWithFormat:@"%@",[UserData sharkedUser].iconValer] andTextFont:14 andTextAlignment:NSTextAlignmentCenter];
    _iconLabel.textColor = [UIColor whiteColor];
    _iconLabel.layer.cornerRadius = 9.0;
    _iconLabel.layer.masksToBounds = YES;
    if ([[UserData sharkedUser].iconValer isEqualToString:@"0"]) {
        _iconLabel.hidden = YES;
    }else{
        _iconLabel.hidden = NO;
    }
    [shoppingButton addSubview:_iconLabel];
    
    //确定
    UIButton * determineButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(10+0.25*ScreenWidth+10, 5,ScreenWidth-(10+0.25*ScreenWidth+10)-10, 34) andBackgroundColor:[UIColor redColor] andText:@"确定" andTextColor:[UIColor whiteColor] andTextFont:[UIFont systemFontOfSize:18] andTarget:self andSelector:@selector(determineButton:)];
//    determineButton.adjustsImageWhenHighlighted = NO;
    determineButton.layer.cornerRadius = 5.0;
    [determineButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [footerView addSubview:determineButton];
}


-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self backButtonClick:nil];
}

-(void)backButtonClick:(UIButton *)button{
    
//    [UIView beginAnimations:@"move" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationDelegate:_goodsVC];
//    self.frame = CGRectMake(0  ,2*ScreenHeight, ScreenWidth, ScreenHeight);
//    [UIView commitAnimations];
    
    self.hidden = YES;
//    self.SizeSelectionBlock(nil);
    
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

//
-(void)determineButton:(UIButton * )button{
    
    if ([UserData sharkedUser].uid==nil) {
        [[self getPresentedViewController]  presentViewController:[[UINavigationController alloc] initWithRootViewController:[CheckinViewController new]] animated:YES completion:nil];
    }else{
    
        self.hidden = YES;
        if (_addOrNowbuy) {
            NSLog(@"%@",_goodsSeleterModel);

            UIImageView * imageV = [MyViewCreateControl initImageVierWithFrame:CGRectMake(20, ScreenHeight-ScreenWidth-49, 100,60) andBackgroundColor:[UIColor yellowColor] andBackgroundNameOfImage:@"" andUsInterfaceEnable:NO andContextMode:UIViewContentModeScaleToFill];
            [self.superview addSubview:imageV];
            imageV.tag = 99999;
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,_imageURL]] placeholderImage:[UIImage imageNamed:@""]];
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDelegate:self];
            imageV.frame = CGRectMake(0.25*ScreenWidth*0.5+10-2, ScreenHeight-64-22-10, 10, 10);
            [UIView commitAnimations];
    //        imageV.hidden = YES;
            [self performSelector:@selector(yanchi) withObject:nil afterDelay:1.0];

            
            
            self.SizeSelectionBlock(_goodsSeleterModel,@"addShoppingCar");
        }else{
            self.SizeSelectionBlock(_goodsSeleterModel,@"nowBuy");
        }
    }
    
}
-(void)yanchi{
    UIImageView * imageV = [self.superview viewWithTag:99999];
    [imageV removeFromSuperview];
    int iconV = [[UserData sharkedUser].iconValer intValue];
    [UserData sharkedUser].iconValer = [NSString stringWithFormat:@"%d",++iconV];
    _iconLabel.text = [UserData sharkedUser].iconValer;
    
    _iconLabel.hidden = NO;
}
//点击购物车图标方法实现
-(void)shoppingButtonClick:(UIButton *)button{
    NSLog(@"111");
    _iconLabel.hidden = YES;
    [UserData sharkedUser].iconValer = @"0";
    
    
    
    self.SizeSelectionBlock(nil,@"shoppingCar");
//    
//    NSNotification * backshoppingNotification = [NSNotification notificationWithName:@"backshoppingtongzhi" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:backshoppingNotification];
    
//    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)sizeButton:(UIButton *)button{
    
    
    UIButton * yuanButton = [button.superview viewWithTag:_sizeSeleter];
    yuanButton.selected = NO;
    button.selected = YES;
    _sizeSeleter = button.tag;
    
    _goodsSeleterModel.size = button.titleLabel.text;
    
    NSLog(@"选择尺码:%@",button.titleLabel.text);
    
}
-(void)colorButton:(UIButton *)button{
    
    UIButton * yuanButton = [button.superview viewWithTag:_colorSeleter];
    yuanButton.selected = NO;
    button.selected = YES;
    _colorSeleter = button.tag;
    
    _goodsSeleterModel.color = button.titleLabel.text;
    NSLog(@"选择颜色:%@",button.titleLabel.text);

}

-(void)rreduceButton:(UIButton *)button{
    
    UILabel * label = [button.superview viewWithTag:7650];
    int suLiang = [label.text intValue];
    if (suLiang > 1) {
        label.text = [NSString stringWithFormat:@"%d",--suLiang];
    }
    _goodsSeleterModel.num = label.text;
    NSLog(@"----  %@",label.text);
}
-(void)aaddButton:(UIButton *)button{
    UILabel * label = [button.superview viewWithTag:7650];
    int suLiang = [label.text intValue];
    label.text = [NSString stringWithFormat:@"%d",++suLiang];
    
    _goodsSeleterModel.num = label.text;
    NSLog(@"++++  %@",label.text);
}

@end
