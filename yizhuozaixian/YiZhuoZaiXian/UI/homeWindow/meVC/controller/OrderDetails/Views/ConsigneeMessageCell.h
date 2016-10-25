//
//  ConsigneeMessageCell.h
//  会员中心
//
#pragma mark - ******** 收货人信息cell ********
//

#import <UIKit/UIKit.h>
#import "BFTest.h"
@interface ConsigneeMessageCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong) BFTest *model;
@end
