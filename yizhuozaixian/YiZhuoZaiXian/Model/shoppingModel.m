//
//  shoppingModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "shoppingModel.h"

@implementation shoppingModel
+(shoppingModel *)setModelWithDic:(NSDictionary *)dic{
    shoppingModel *model=[[shoppingModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];
    model.gouxuanSelected = YES;
    return model;
}

+(NSMutableArray *)setModelWithArray2:(NSArray *)array{
    
    NSMutableArray * mArr=[NSMutableArray array];
    
    for (NSDictionary * dic in array) {
        
        shoppingModel * model=[shoppingModel setModelWithDic:dic];
        
        [mArr addObject:model];
       
    }
    return mArr;
}

+(NSMutableArray *)setModelWithArray:(NSArray *)array{
    NSMutableArray * returnArr = [NSMutableArray array];
    for (NSDictionary * dic in array) {
       
        NSMutableArray * marr = [NSMutableArray array];
        [marr addObject:dic[@"brand_name"]];
        [marr addObject:dic[@"brand_id"]];
        [marr addObject:[NSNumber numberWithBool:YES]];
        
        [marr addObject:[shoppingModel setModelWithArray2:dic[@"shopInfo"]]];

        [returnArr addObject:marr];
    }
    return returnArr;
}


////@property(nonatomic,assign)BOOL gouxuanSelected;
////@property(nonatomic,strong)NSString * goodsNumber;
////
////@property(nonatomic,strong)NSString * goodsColor;
////@property(nonatomic,strong)NSString * goodsSize;
////@property(nonatomic,strong)NSString * goodsPrice;
//
//#pragma mark NSCoding协议
////内部的属性变量分别转码
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    
//    [aCoder encodeObject:_num forKey:@"goodsNumber" ];
//    [aCoder encodeObject:_color forKey:@"goodsColor"];
//    [aCoder encodeObject:_size forKey:@"goodsSize"];
//    [aCoder encodeObject:_goods_price forKey:@"goodsPrice"];
////    [aCoder encodeObject:_gouxuanSelected forKey:@"gouxuanSelected"];
//}
////分别把两个属性变量根据关键字进行逆转码，最后返回一个类的对象
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super init]) {
////        self.gouxuanSelected = [aDecoder decodeObjectForKey:@"gouxuanSelected"];
//        self.num= [aDecoder decodeObjectForKey:@"goodsNumber"];
//        self.color = [aDecoder decodeObjectForKey:@"goodsColor"];
//        self.size= [aDecoder decodeObjectForKey:@"goodsSize"];
//        self.goods_price= [aDecoder decodeObjectForKey:@"goodsPrice"];
//    }
//    return self;
//}

@end
