//
//  invoiceTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/5.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "invoiceTableViewCell.h"
@interface invoiceTableViewCell()<UITextFieldDelegate>


@end

@implementation invoiceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //发票类型
        UILabel * invoiceTayeLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 0, 300, 30) andBackgroundColor:[UIColor clearColor] andText:@"发票类型： 纸资发票" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:invoiceTayeLabel];
        
        //发票内容
        UILabel * invoiceContentLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 30, 300, 30) andBackgroundColor:[UIColor clearColor] andText:@"发票内容： 明细" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:invoiceContentLabel];
        
        //发票抬头
        UILabel * invoiceHeaderLabel = [MyViewCreateControl initLabelWithFrame:CGRectMake(20, 60, 75, 30) andBackgroundColor:[UIColor clearColor] andText:@"发票抬头：" andTextFont:15 andTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:invoiceHeaderLabel];
        
        //个人
        UIButton * meInvoiceHeaderBut = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(95, 60, 90, 30) andBackgroundColor:[UIColor clearColor] andText:@"个人" andTextColor:[UIColor blackColor] andTextFont:[UIFont systemFontOfSize:15] andTarget:self andSelector:@selector(meInvoiceHeaderButClick:)];
        meInvoiceHeaderBut.tag = 33;
        meInvoiceHeaderBut.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
        meInvoiceHeaderBut.selected = YES;
        [meInvoiceHeaderBut setImage:[UIImage imageNamed:@"order_btn_pitch_n.png"] forState:UIControlStateNormal];
        [meInvoiceHeaderBut setImage:[UIImage imageNamed:@"order_btn_pitch_s.png"] forState:UIControlStateSelected];
        
        [self.contentView addSubview:meInvoiceHeaderBut];
        //单位
        UIButton * unitInvoiceHeaderBut = [MyViewCreateControl initTitleButtonWithFrame:CGRectMake(95+90, 60, 90, 30) andBackgroundColor:[UIColor clearColor] andText:@"单位" andTextColor:[UIColor blackColor] andTextFont:[UIFont systemFontOfSize:15] andTarget:self andSelector:@selector(unitInvoiceHeaderButClick:)];
        unitInvoiceHeaderBut.tag = 34;
        unitInvoiceHeaderBut.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);
        [unitInvoiceHeaderBut setImage:[UIImage imageNamed:@"order_btn_pitch_n.png"] forState:UIControlStateNormal];
        [unitInvoiceHeaderBut setImage:[UIImage imageNamed:@"order_btn_pitch_s.png"] forState:UIControlStateSelected];
        
        [self.contentView addSubview:unitInvoiceHeaderBut];
        

        UITextField * unitNameTextField = [[ZCtextField alloc]initWithFrame:CGRectMake(10, 95, ScreenWidth-20, 40) placeholder:@"请输入姓名" backGroundImage:[UIImage imageNamed:@""]];
        //设置边框  goods_getails_boreder_gray.png
        unitNameTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        unitNameTextField.layer.borderWidth = 1;
        unitNameTextField.layer.cornerRadius = 6;
        unitNameTextField.layer.masksToBounds = YES;

//        [unitNameTextField becomeFirstResponder];
        
        unitNameTextField.delegate = self;
        
        unitNameTextField.tag = 35;
            [self.contentView addSubview:unitNameTextField];

        
    }
    return self;
}
-(void)meInvoiceHeaderButClick:(UIButton *)button{
    
    
    
    button.selected = YES;
    UIButton * bt = [self.contentView viewWithTag:34];
    bt.selected = NO;
    
    UITextField * tf = [self.contentView viewWithTag:35];
    tf.placeholder = @"请输入姓名";
    
    
}
-(void)unitInvoiceHeaderButClick:(UIButton *)button{
    button.selected = YES;
    UIButton * bt = [self.contentView viewWithTag:33];
    bt.selected = NO;
    
    UITextField * tf = [self.contentView viewWithTag:35];
    tf.placeholder = @"请输入单位全称";
    
    
}
//即将进入编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    

    
    self.invoiceCellBolk(@"tanqi",@"");
    return YES;
}
//即将结束编辑
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    UITextField * tf = [self.contentView viewWithTag:35];
    NSLog(@"%@,%@",tf.placeholder,tf.text);
    
    if ([tf.placeholder isEqualToString:@"请输入姓名"]) {
        self.invoiceCellBolk(@"InvoiceHeader",tf.text);
    }else{
        self.invoiceCellBolk(@"InvoiceHeader",tf.text);
    }
    
    
//    [textField resignFirstResponder];
    
    return YES;
}
//按回车时结束编辑
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
