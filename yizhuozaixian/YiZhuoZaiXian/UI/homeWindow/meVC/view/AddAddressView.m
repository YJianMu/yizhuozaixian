//
//  AddAddressView.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/31.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "AddAddressView.h"
#define CellHeight  BF_ScaleHeight(44)
#define Margin  BF_ScaleHeight(10)
#import "UIView+Frame.h"
#import "AddressPickView.h"
#import "CheckPhoneNumber.h"
#import "HZQRegexTestter.h"

@interface AddAddressView ()<UITextFieldDelegate>


@end

@implementation AddAddressView


+ (instancetype)creatView {
    AddAddressView *view = [[AddAddressView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}



- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self setView];
        [self setupTap];
    }
    return self;
}


- (void)setupTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];
}

- (void)tapView{
    [self endEditing:YES];
}

- (void)setView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 220)];
    [self addSubview:bottomView];
    
    UILabel *consigneeLabel = [UILabel new];
    consigneeLabel.text = @"收货人";
    consigneeLabel.frame = CGRectMake(10, 0, 80, 44);
    //consigneeLabel.backgroundColor = [UIColor redColor];
    [bottomView addSubview:consigneeLabel];
    
    UIView *firstLine = [self setUpLine];
    firstLine.frame = CGRectMake(10, consigneeLabel.height - 0.5, ScreenWidth - 20, 0.5);
    [bottomView addSubview:firstLine];
    
    
    UILabel *areaChooseLabel = [UILabel new];
    areaChooseLabel.text = @"区域选择";
    areaChooseLabel.frame = CGRectMake(consigneeLabel.x, CGRectGetMaxY(consigneeLabel.frame), consigneeLabel.width, consigneeLabel.height);
    //areaChooseLabel.backgroundColor = [UIColor blueColor];
    [bottomView addSubview:areaChooseLabel];
    
    UIView *secondLine = [self setUpLine];
    secondLine.frame = CGRectMake(10, CGRectGetMaxY(areaChooseLabel.frame)-0.5, ScreenWidth - 20, 0.5);
    [bottomView addSubview:secondLine];
    
    UILabel *detailAddressLabel = [UILabel new];
    detailAddressLabel.text = @"详细地址";
    detailAddressLabel.frame = CGRectMake(consigneeLabel.x, CGRectGetMaxY(areaChooseLabel.frame), consigneeLabel.width, consigneeLabel.height);
    [bottomView addSubview:detailAddressLabel];
    
    UIView *thirdLine = [self setUpLine];
    thirdLine.frame = CGRectMake(10, CGRectGetMaxY(detailAddressLabel.frame)-0.5, ScreenWidth - 20, 0.5);
    [bottomView addSubview:thirdLine];
    
    UILabel *contactInformationLabel = [UILabel new];
     contactInformationLabel.text = @"联系方式";
    contactInformationLabel.frame = CGRectMake(consigneeLabel.x, CGRectGetMaxY(detailAddressLabel.frame), consigneeLabel.width, consigneeLabel.height);
    [bottomView addSubview:contactInformationLabel];
    
    UIView *foruthLine = [self setUpLine];
    foruthLine.frame = CGRectMake(10, CGRectGetMaxY(contactInformationLabel.frame)-0.5, ScreenWidth -20, 0.5);
    [bottomView addSubview:foruthLine];
    
    UILabel *addressDefaultLabel = [UILabel new];
    addressDefaultLabel.text = @"设置默认地址";
    addressDefaultLabel.frame = CGRectMake(consigneeLabel.x, CGRectGetMaxY(contactInformationLabel.frame), 150, consigneeLabel.height);
    [bottomView addSubview:addressDefaultLabel];
    
    UIView *fifthLine = [self setUpLine];
    fifthLine.frame = CGRectMake(10, CGRectGetMaxY(addressDefaultLabel.frame)-0.5, ScreenWidth -20, 0.5);
    [bottomView addSubview:fifthLine];
    
    
    UITextField *consignee = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 44)];
    self.consignee = consignee;
    consignee.font = [UIFont systemFontOfSize:13];
    consignee.textAlignment = NSTextAlignmentRight;
    consignee.delegate = self;
    consignee.returnKeyType = UIReturnKeyDone;
    //consignee.backgroundColor = [UIColor greenColor];
    [bottomView addSubview:consignee];
  
    
    UILabel *selectArea = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(consignee.frame), ScreenWidth - 10, 44)];
    self.selectArea = selectArea;
    selectArea.font = [UIFont systemFontOfSize:13];
    selectArea.userInteractionEnabled = YES;
    selectArea.textAlignment = NSTextAlignmentRight;
    //selectArea.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToChooseArea)];
    [selectArea addGestureRecognizer:tap];
    [bottomView addSubview:selectArea];

    
    UITextField *detailAddress = [[UITextField alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(selectArea.frame), ScreenWidth - detailAddressLabel.width - 20, 44)];
    self.detailAddress = detailAddress;
    detailAddress.delegate = self;
    detailAddress.returnKeyType = UIReturnKeyDone;
    detailAddress.font = [UIFont systemFontOfSize:13];
    detailAddress.textAlignment = NSTextAlignmentRight;
    //detailAddress.backgroundColor = [UIColor blueColor];
    [bottomView addSubview:detailAddress];
    
    
    UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(detailAddress.frame), ScreenWidth -20, 44)];
    self.phone = phone;
    phone.delegate = self;
    phone.returnKeyType = UIReturnKeyDone;
    phone.keyboardType = UIKeyboardTypeNumberPad;
    phone.font = [UIFont systemFontOfSize:13];
    phone.textAlignment = NSTextAlignmentRight;
    //phone.backgroundColor = [UIColor greenColor];
    [bottomView addSubview:phone];

    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 70, CGRectGetMaxY(phone.frame)+(44-31)/2, 51, 31)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:switchButton];
    
    
    UIButton *saveButton = [UIButton buttonWithType:0];
    saveButton.frame = CGRectMake(0.1 * ScreenWidth, CGRectGetMaxY(bottomView.frame) + 20, ScreenWidth - 0.2 *ScreenWidth, 0.1 * ScreenWidth);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.backgroundColor = [UIColor redColor];
    saveButton.layer.cornerRadius = 15;
    [saveButton addTarget:self action:@selector(cliclToSaveAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];

    self.defaultNumber = @"0";
}

- (void)switchAction:(UISwitch *)sender {
    [self endEditing:YES];
    self.defaultNumber = @"0";
    NSLog(@"不是");
    if (sender.isOn) {
        self.defaultNumber = @"1";
        NSLog(@"是的");
    }
}

- (void)clickToChooseArea {
    [self endEditing:YES];
    NSLog(@"点击选择城市");
    AddressPickView *addressPickView = [AddressPickView shareInstance];
    [self addSubview:addressPickView];
    addressPickView.block = ^(NSString *province,NSString *city,NSString *town){
        self.selectArea.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,town] ;
        self.province = province;
        self.city = city;
        self.area = town;
        
    };
    
}


- (void)cliclToSaveAddress:(UIButton *)sender {
    [self endEditing:YES];
    
    //BFUserInfo *userInfo = [BFUserDefaluts getUserInfo];
    //NSString *url = [NET_URL stringByAppendingPathComponent:@"/index.php?m=Json&a=user_address"];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    long long int data = (long long int)a;
    NSString * time = [NSString stringWithFormat:@"%lld", data];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [UserData sharkedUser].uid;
    NSString *str = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.area];
    param[@"address"] = str;
    param[@"detailAddress"] = self.detailAddress.text;
    param[@"mobile"] = self.phone.text;
    param[@"consignee"] = self.consignee.text;
    param[@"isDefault"] = self.defaultNumber;
    param[@"sign"]=[NSString stringWithFormat:@"mUser%@%@%@%@%@%@%@%@%@",time,[UserData sharkedUser].uid,[[UIDevice currentDevice].identifierForVendor UUIDString],[UserData sharkedUser].token,str,_consignee.text,_detailAddress.text,_defaultNumber,_phone.text].md5String;
    param[@"time"] = time;
    
    NSLog(@"%@,",param);
    __weak AddAddressView *weakself = self;
    if (self.consignee.text.length == 0 || self.selectArea.text.length == 0 || self.detailAddress.text.length == 0 || self.phone.text.length == 0 ) {
        [SVProgressHUD showInfoWithStatus:@"请完善资料"];
    }else if (![HZQRegexTestter validateRealName:self.consignee.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入真名"];
    }else if (![CheckPhoneNumber  isMobileNumber:self.phone.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:ChangeDataURLString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            NSLog(@"%@",json);
            if ([json[@"info"] isEqualToString:@"n003"]) {
                
                [SVProgressHUD showInfoWithStatus:@"添加地址成功,正在跳转"];
                [weakself.delegate goBackToAddressView];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(goBackToAddressView)]) {
//                        
//                    }else {
//                        [SVProgressHUD showInfoWithStatus:@"添加失败"];
//                    }
//                    
//                });
            
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
            NSLog(@"%@",error);
        }];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.consignee resignFirstResponder];
    [self.detailAddress resignFirstResponder];
    [self.phone resignFirstResponder];
    return YES;
}

- (UIView *)setUpLine {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    return line;
}

@end
