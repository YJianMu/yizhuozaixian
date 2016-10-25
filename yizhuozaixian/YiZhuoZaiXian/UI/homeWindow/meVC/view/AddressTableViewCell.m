//
//  AddressTableViewCell.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/3/29.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *isDefault;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    
}

- (void)setModel:(addrData *)model{
    _model = model;
    self.consignee.text = model.consignee;
    self.mobile.text = model.mobile;
    self.address.text = model.address;
    self.detailAddress.text = model.detailAddress;
    if ([model.isDefault isEqualToString:@"0"]) {
        self.isDefault.hidden = YES;
    }else if([model.isDefault isEqualToString:@"1"]){
        self.isDefault.hidden = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"addressCell";
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
