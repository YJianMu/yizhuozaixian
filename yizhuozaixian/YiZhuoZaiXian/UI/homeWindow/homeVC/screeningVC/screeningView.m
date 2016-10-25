//
//  screeningView.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/5/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "screeningView.h"
#import "CustomPopOverView.h"

@interface screeningView ()<CustomPopOverViewDelegate>

@property(nonatomic,strong)NSArray * dataArr;

@property(nonatomic,strong)NSMutableArray * selectedButTagArr;
@property(nonatomic,strong)NSMutableDictionary * uploadParametersMdic;

@property(nonatomic,strong)NSArray * sizeArr;

@end

@implementation screeningView

- (UIScrollView *)initWithFrame:(CGRect)frame andWithDataModelArr:(NSArray *)dataModelArr{
    self = [super initWithFrame:frame];
    if (self) {
        
        _sizeArr = @[@[@[@"145",@"150",@"155",@"160",@"165",@"170",@"175",@"180",@"185",@"190",@"195"]],@[@[@"67",@"70",@"72",@"74",@"77",@"79",@"82",@"87",@"90"],@[@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34"]],@[@[@"40",@"45",@"50",@"55",@"60",@"65",@"70",@"75",@"80",@"85"]]];
        _dataArr = dataModelArr;
        
        NSMutableArray * mArr = [NSMutableArray array];
        _uploadParametersMdic = [NSMutableDictionary dictionary];
        for (int i = 0 ;i < dataModelArr.count; i++) {
            if (i < dataModelArr.count - 3) {
                [mArr addObject:@0];
                [_uploadParametersMdic setValue:@"0" forKey:dataModelArr[i][0]];

            }else{
                
                [_uploadParametersMdic setValue:_sizeArr[i - (dataModelArr.count - 3)][0][0] forKey:dataModelArr[i][0]];

            }
        }
        _selectedButTagArr = [NSMutableArray arrayWithArray:mArr];
        
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ebebf4"];
//        self.backgroundColor = [UIColor yellowColor];
        
        
        self.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2);
        self.contentOffset = CGPointMake(0, 0);
        self.showsVerticalScrollIndicator = NO;
        //    scrollView.alwaysBounceVertical = YES;


        
        
        
        [self createCategoryUI];
        
        [self setDefaultSelectedBut];

    }
    
    return self;
    
    
}

-(void)createCategoryUI{
    
    float selfY = 0.0;
    
    for (int i = 0; i < _dataArr.count; i++) {
        
        UIView * beforeView = [self viewWithTag:1000 + i - 1];
        
        float whiteViewY = 10 + beforeView.frame.origin.y + beforeView.frame.size.height;
        
        UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, whiteViewY, ScreenWidth - 20, 40 * (([_dataArr[i][1] count] - 1) / 4 + 1 + 1))];
        whiteView.backgroundColor = [UIColor whiteColor];
        whiteView.tag = 1000 + i;
        
        if (i < _dataArr.count - 3) {
            //创建前三分组 上装,下装,女装
            [self createButtonWithInWhiteView:whiteView];
            
        }else{
            //创建其他 选择分组 身高,腰围,体重
            [self createTextFieldWithInWhiteView:whiteView];
            
        }
        
        [self addSubview:whiteView];
        
        selfY = whiteViewY + beforeView.frame.size.height + 10;
        
    }
    
    self.contentSize = CGSizeMake(ScreenWidth, selfY);
    
    
}
-(void)createButtonWithInWhiteView:(UIView *)whiteView{
    
    int i = (int)whiteView.tag -1000;
    
    //组头标题
    UILabel * classificationOfTitleLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 0, whiteView.frame.size.width, 40) andBackgroundColor:[UIColor clearColor] andText:_dataArr[i][0] andTextFont:17 andTextAlignment:NSTextAlignmentLeft];
    [whiteView addSubview:classificationOfTitleLabel];
    
    float secondaryClassificationButtonWidth = (whiteView.frame.size.width - 50) / 4 ;
    
    
    for (int j = 0; j < [_dataArr[i][1] count]; j++) {
        
        UIButton * secondaryClassificationButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(10 + j % 4 * (secondaryClassificationButtonWidth + 10), 40  + j / 4 * 40, secondaryClassificationButtonWidth, 30) andBackgroundColor:[UIColor clearColor] andText:_dataArr[i][1][j] andTextColor:[UIColor lightGrayColor] andTextFont:[UIFont systemFontOfSize:13] andTarget:self andSelector:@selector(secondaryClassificationButtonClick:)];
        
        secondaryClassificationButton.tag = 5000 + j;
        
        secondaryClassificationButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
        secondaryClassificationButton.layer.borderWidth = 1;
        secondaryClassificationButton.layer.cornerRadius = 15;
        secondaryClassificationButton.layer.masksToBounds = YES;
        
        [whiteView addSubview:secondaryClassificationButton];
        
    }
    
    
    
}

-(void)createTextFieldWithInWhiteView:(UIView *)whiteView{
    
    int i = (int)whiteView.tag -1000;
    
    UILabel * classificationOfTitleLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10, 0, whiteView.frame.size.width, 40) andBackgroundColor:[UIColor clearColor] andText:_dataArr[i][0] andTextFont:17 andTextAlignment:NSTextAlignmentLeft];
    [whiteView addSubview:classificationOfTitleLabel];
    
    float textFieldButWidth = (whiteView.frame.size.width - 50) / 4 ;
    
    

    for (int j = 0; j < [_dataArr[i][1] count]; j++) {
        
        UIButton * textFieldButton = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(10 + textFieldButWidth * 0.5 + 5 + j % 4 * (textFieldButWidth + 10 + textFieldButWidth ), 40  + j / 4 * 40, textFieldButWidth, 30) andBackgroundColor:[UIColor colorWithHexString:@"#dddddd"] andText:_sizeArr[i - _sizeArr.count][j][0] andTextColor:[UIColor darkGrayColor] andTextFont:[UIFont systemFontOfSize:13] andTarget:self andSelector:@selector(textFieldButtonClick:)];

        textFieldButton.tag = 8000 + j;
        textFieldButton.layer.cornerRadius = 15;
        textFieldButton.layer.masksToBounds = YES;
        
        
        UILabel * unitLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(10 + textFieldButton.frame.origin.x + textFieldButWidth, textFieldButton.frame.origin.y, textFieldButWidth, 30) andBackgroundColor:[UIColor clearColor] andText:_dataArr[i][1][j] andTextFont:13 andTextAlignment:NSTextAlignmentLeft];
        unitLabel.textColor = [UIColor grayColor];
        
        //判断是否是倒数第二个whiteView（腰围）
        if (i == _dataArr.count - 2 && j == 0) {
            
            NSString * unitLabelStr = _dataArr[i][1][j];
            NSMutableAttributedString * unitLabelAttributedStr = [[NSMutableAttributedString alloc] initWithString:unitLabelStr];
            [unitLabelAttributedStr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14]} range:NSMakeRange(2, unitLabelStr.length - 2)];
            unitLabel.attributedText = unitLabelAttributedStr;
            
        }
        
        [whiteView addSubview:unitLabel];
        [whiteView addSubview:textFieldButton];
        

    }
}


-(void)secondaryClassificationButtonClick:(UIButton *)button{
    
    UIView * vi = [button superview];
    
    NSLog(@"二级目录按钮(%ld,%ld)被点击（选择）",vi.tag - 1000,button.tag - 5000);
    
    if (button.tag - 5000 != [_selectedButTagArr[vi.tag - 1000] intValue] || [_selectedButTagArr[vi.tag - 1000] isKindOfClass:[NSString class]]) {
        
        //修改选中的But颜色为红色
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.layer.borderColor = UIColor.redColor.CGColor;
        
        //还原之前选中的But颜色为浅灰色
        if ([_selectedButTagArr[vi.tag - 1000] isKindOfClass:[NSNumber class]]) {
            
            UIButton * beforeSeletedBut = [vi viewWithTag:([_selectedButTagArr[vi.tag - 1000] intValue] + 5000)];
            //    NSLog(@"%@",_selectedButTagArr[vi.tag - 1000]);
            [beforeSeletedBut setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            beforeSeletedBut.layer.borderColor = UIColor.lightGrayColor.CGColor;
            
        }
        
        //修改上传参数字典
        [_uploadParametersMdic setValue:[NSString stringWithFormat:@"%ld",button.tag - 5000]  forKey:_dataArr[vi.tag - 1000][0]];
        
        //修改选中数组
        [_selectedButTagArr replaceObjectAtIndex:vi.tag - 1000 withObject:[NSNumber numberWithInteger:button.tag - 5000]];

    }else{
        
        //修改选中的But颜色为灰色
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.layer.borderColor = UIColor.lightGrayColor.CGColor;
        
        //修改上传参数字典
        [_uploadParametersMdic setValue:@"" forKey:_dataArr[vi.tag - 1000][0]];
        
        //修改选中数组
        [_selectedButTagArr replaceObjectAtIndex:vi.tag - 1000 withObject:@"NO-Seleted"];
        
    }
    
    NSLog(@"%@",_selectedButTagArr);
    
    _screeningViewReturnBlock(_uploadParametersMdic);
    
}

-(void)textFieldButtonClick:(UIButton *)button{
    
    UIView * superVi = [button superview];
    
    CustomPopOverView * tableView = [[CustomPopOverView alloc] initWithBounds:CGRectMake(0, 0, button.frame.size.width, 0.6 * ScreenWidth) titleMenus:_sizeArr[superVi.tag - 1000 - _sizeArr.count][button.tag - 8000]];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentOffset = CGPointMake(0, superVi.frame.origin.y - (ScreenHeight - 64 - 44 - 60 - 40 - 0.6 * ScreenWidth));

    }];

    tableView.tag = superVi.tag;
    tableView.containerBackgroudColor = [UIColor redColor];
    tableView.delegate = self;
    [tableView showFrom:button alignStyle:CPAlignStyleCenter];
    
}

-(void)setDefaultSelectedBut{
    
    for (int i = 0; i < _selectedButTagArr.count; i++) {
        UIView * whiteView = [self viewWithTag:1000 + i];
        UIButton * selectedBut = [whiteView viewWithTag:5000];
        [selectedBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        selectedBut.layer.borderColor = UIColor.redColor.CGColor;

    }
    
    
}

#pragma mark- CustomPopOverViewDelegate

- (void)popOverViewDidShow:(CustomPopOverView *)pView
{
    NSLog(@"popOverViewDidShow");
}
- (void)popOverViewDidDismiss:(CustomPopOverView *)pView
{
    NSLog(@"popOverViewDidDismiss");
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentOffset = CGPointMake(0, self.contentSize.height - (ScreenHeight - 64 - 44));

    }];
    
}

- (void)popOverView:(CustomPopOverView *)pView didClickMenuIndex:(NSInteger)index
{
    NSLog(@"select menu title is: %@", _sizeArr[pView.tag - 1000 - _sizeArr.count][0][index]);
    
    UIView * vi = [self viewWithTag:pView.tag];
    
    UIButton * textFieldBut = [vi viewWithTag:8000];
    
    [textFieldBut setTitle:_sizeArr[pView.tag - 1000 -_sizeArr.count][0][index] forState:UIControlStateNormal];
    
    [_uploadParametersMdic setValue:_sizeArr[vi.tag - 1000 - (_dataArr.count - 3)][0][index] forKey:_dataArr[vi.tag - 1000][0]];
    
    if (vi.tag == _dataArr.count - 2 + 1000 ) {
        
        UIButton * textFieldBut2 = [vi viewWithTag:8001];
        
        [textFieldBut2 setTitle:_sizeArr[pView.tag - 1000 -_sizeArr.count][1][index] forState:UIControlStateNormal];

    }
    
    _screeningViewReturnBlock(_uploadParametersMdic);
    
    [pView dismiss];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
