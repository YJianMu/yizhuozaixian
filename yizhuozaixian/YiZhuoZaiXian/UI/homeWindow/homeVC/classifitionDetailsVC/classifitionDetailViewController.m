//
//  classifitionDetailViewController.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "classifitionDetailViewController.h"
#import "gooodsDetailsVC.h"
#import "classCollectionViewCell.h"
#import "classifitionCollectionViewCell.h"

#import "TabBarViewController.h"

#import "classifitionModel.h"

@interface classifitionDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UICollectionView * myCollectionView;
@property(nonatomic,strong)NSMutableArray * DataArray;

@property(nonatomic,assign)int currentPage;
@end

@implementation classifitionDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    
    _currentPage = 1;
    _DataArray = [NSMutableArray array];
    [self setNavigation];
    
    [self setData];
    
    [self setCollectionView];
    
    
}

-(void)setNavigation{
    
    self.navigationItem.title = _goods_name;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * leftItemBttn = [MyViewCreateControl initImageButtonWithFrame:CGRectMake(10, 5, 34, 34) andBackgroundColor:[UIColor clearColor] andImage:[UIImage imageNamed:@"nav_return.png"] andBackgroundImage:[UIImage imageNamed:@""] andTarget:self andSelector:@selector(leftItemBttnClick)];
    leftItemBttn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemBttn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    //设置navigationController为不透明
    self.navigationController.navigationBar.alpha = 1;
//    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;

    
    

    UISwipeGestureRecognizer * fanhuiSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(fanhuiSwipe:)];
    [self.view addGestureRecognizer:fanhuiSwipe];
    fanhuiSwipe.direction = UISwipeGestureRecognizerDirectionRight;


}

#pragma mark - 请求数据
-(void)setData{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak classifitionDetailViewController * weakSelf = self;
    NSString * URLString = [NSString stringWithFormat:@"%@&cat_id=%@&page=%d",classifitionURLstring,_cat_id,_currentPage];
    NSLog(@"%@",URLString);
    [manager GET:URLString parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * objc = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSLog(@"%@",objc);
//        [ZJModelTool createModelWithDictionary:objc[@"list"][0] modelName:@"classifitionModel"];
        
        if (weakSelf.currentPage==1) {
            //只有在有数据返回时才创建DataArray
            if([objc[@"list"] count] != 0){
                weakSelf.DataArray = [NSMutableArray arrayWithArray:[classifitionModel setModelWithArray:objc[@"list"]]];
                NSLog(@"%@",weakSelf.DataArray[0]);
                
                [weakSelf.myCollectionView reloadData];
            }
        }else{
            [weakSelf.DataArray addObjectsFromArray:[classifitionModel setModelWithArray:objc[@"list"]]];
            [weakSelf.myCollectionView reloadData];
        }
        
        //结束刷新
        [weakSelf.myCollectionView footerEndRefreshing];
        [weakSelf.myCollectionView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请检查网络再试"];
        //结束刷新
        [weakSelf.myCollectionView footerEndRefreshing];
        [weakSelf.myCollectionView headerEndRefreshingWithResult:JHRefreshResultFailure];
        
        
    }];
    
//    if (!_currentPage) {
//        
//    }
}

-(void)setCollectionView{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向（纵向/横向）
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64)collectionViewLayout:flowLayout];
    
    _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    //注册
    [_myCollectionView registerClass:[classifitionCollectionViewCell class]forCellWithReuseIdentifier:@"classifitionCell"];
    [_myCollectionView registerClass:[classCollectionViewCell class]forCellWithReuseIdentifier:@"classCell"];
    //设置代理
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    [self.view addSubview:_myCollectionView];
    
    __weak classifitionDetailViewController * weakSelf = self;
    //添加下拉刷新
    [_myCollectionView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.currentPage = 1;
        [weakSelf setData];
    }];
    //添加上拉加载更多
    [_myCollectionView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.currentPage++;
        [weakSelf setData];
    }];

}
#pragma mark - collectionView delegate


//每个分组上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _DataArray.count;
    
        

    
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //当最后一个cell位单个，将其改为大图显示
    if (_DataArray.count % 5 == 2 || _DataArray.count % 5 == 4) {
        
        //collectionView的cell只能用注册的方式
        if(indexPath.row % 5==0){
            
            classifitionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifitionCell" forIndexPath:indexPath];
            NSLog(@"row = %ld",(long)indexPath.row);
            NSLog(@"%@", _DataArray);
            [cell sizeToFit];
            if (!cell) {
                NSLog(@"---------11111----------");
            }
            if (_DataArray.count != 0) {
                
                classifitionModel * model = _DataArray[indexPath.row];
                NSLog(@"%@",model);
                [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.original_img]] placeholderImage:[UIImage imageNamed:@"shop_img_big.png"]];
                cell.goodsNameLabel.text = model.goods_name;
                cell.goodsDescribeLabel.text = model.goods_brief;
                cell.goodsPriceLabel.text = model.shop_price;
            }
            
            
            return cell;
            
        }else{
            if (indexPath.row == _DataArray.count - 1) {
                classifitionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifitionCell" forIndexPath:indexPath];
                NSLog(@"row = %ld",(long)indexPath.row);
                NSLog(@"%@", _DataArray);
                [cell sizeToFit];
                if (!cell) {
                    NSLog(@"---------11111----------");
                }
                if (_DataArray.count != 0) {
                    
                    classifitionModel * model = _DataArray[indexPath.row];
                    NSLog(@"%@",model);
                    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.original_img]] placeholderImage:[UIImage imageNamed:@"shop_img_big.png"]];
                    cell.goodsNameLabel.text = model.goods_name;
                    cell.goodsDescribeLabel.text = model.goods_brief;
                    cell.goodsPriceLabel.text = model.shop_price;
                }
                
                
                return cell;
            }else{
                classCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
                [cell sizeToFit];
                if (!cell) {
                    NSLog(@"----------222222---------");
                }
                if (_DataArray.count != 0) {
                    
                    classifitionModel * model = _DataArray[indexPath.row];
                    
                    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_thumb]] placeholderImage:[UIImage imageNamed:@"shop_img_smal.png"]];
                    cell.goodsNameLabel.text = model.goods_name;
                    cell.goodsPriceLabel.text = model.shop_price;
                    
                    
                }
                
                return cell;
            }
            
        }

    }else{
        
        //collectionView的cell只能用注册的方式
        if(indexPath.row % 5==0){
            
            classifitionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classifitionCell" forIndexPath:indexPath];
            NSLog(@"row = %ld",(long)indexPath.row);
            NSLog(@"%@", _DataArray);
            [cell sizeToFit];
            if (!cell) {
                NSLog(@"---------11111----------");
            }
            if (_DataArray.count != 0) {
                
                classifitionModel * model = _DataArray[indexPath.row];
                NSLog(@"%@",model);
                [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.original_img]] placeholderImage:[UIImage imageNamed:@"shop_img_big.png"]];
                cell.goodsNameLabel.text = model.goods_name;
                cell.goodsDescribeLabel.text = model.goods_brief;
                cell.goodsPriceLabel.text = model.shop_price;
            }
            
            
            return cell;
            
        }else{
            classCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
            [cell sizeToFit];
            if (!cell) {
                NSLog(@"----------222222---------");
            }
            if (_DataArray.count != 0) {
                
                classifitionModel * model = _DataArray[indexPath.row];
                
                [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",websiteURLstring,model.goods_thumb]] placeholderImage:[UIImage imageNamed:@"shop_img_smal.png"]];
                cell.goodsNameLabel.text = model.goods_name;
                cell.goodsPriceLabel.text = model.shop_price;
                
                
            }
            
            
            
            return cell;
        }

        
    }

    
    
    
}

//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section % 5 == 0 ) {
        
        return UIEdgeInsetsMake(10, 10, 0, 10);
        
    }else if (section % 5 == 1 || section % 5 == 3 ) {
        
        //当最后一个cell位单个，将其改为大图显示
        if (section == _DataArray.count - 1) {
            return UIEdgeInsetsMake(10, 10, 0, 10);
        }else{
            return UIEdgeInsetsMake(10, 10, 0, 5);
        }
        
    }else{
        
        return UIEdgeInsetsMake(10, 5, 0, 10);
        
    }
    
    
    
    
}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={0,0};
    return size;
}
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //当最后一个cell位单个，将其改为大图显示
    if (_DataArray.count % 5 == 2 || _DataArray.count % 5 == 4) {
        
        if (indexPath.row % 5 == 0) {
            //        return CGSizeMake(ScreenWidth-20,5 + 0.75*(ScreenWidth-20) + 5 + 40 + 35 + 5 + 30 + 5);
            return CGSizeMake(ScreenWidth-20,0.6 * (ScreenWidth-20) + 10 + 40 + 5 + 35 + 10 + 30 + 10 );
            
        }else{
            
            if (indexPath.row == _DataArray.count - 1) {
                //        return CGSizeMake(ScreenWidth-20,5 + 0.75*(ScreenWidth-20) + 5 + 40 + 35 + 5 + 30 + 5);
                return CGSizeMake(ScreenWidth-20,0.6 * (ScreenWidth-20) + 10 + 40 + 5 + 35 + 10 + 30 + 10 );

            }else{
                
                //        return CGSizeMake(ScreenWidth * 0.453125, 5 + 0.5*0.75*(ScreenWidth-20) + 5 + 20 + 20 + 5);
                return CGSizeMake(ScreenWidth * 0.5 -15 , 0.85 * (ScreenWidth * 0.5 -15) + 5 + 20 + 5 +20 + 5);
                
            }
            
        }
        
        
    }else{
        
        if (indexPath.row % 5 == 0) {
            //        return CGSizeMake(ScreenWidth-20,5 + 0.75*(ScreenWidth-20) + 5 + 40 + 35 + 5 + 30 + 5);
            return CGSizeMake(ScreenWidth-20,0.6 * (ScreenWidth-20) + 10 + 40 + 5 + 35 + 10 + 30 + 10 );
            
        }else{
            //        return CGSizeMake(ScreenWidth * 0.453125, 5 + 0.5*0.75*(ScreenWidth-20) + 5 + 20 + 20 + 5);
            return CGSizeMake(ScreenWidth * 0.5 -15 , 0.85 * (ScreenWidth * 0.5 -15) + 5 + 20 + 5 +20 + 5);
            
        }

    }
    
}

#pragma mark 点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    classifitionModel * model = _DataArray[indexPath.row];
    gooodsDetailsVC * goodsVC = [[gooodsDetailsVC alloc]init];
    goodsVC.goodsID = model.goods_id;
    goodsVC.goodsName = model.goods_name;
    goodsVC.goodImage = model.goods_thumb;
    goodsVC.goodBrief = model.goods_brief;
    goodsVC.goodsSizeURLstring = [NSString stringWithFormat:@"%@%@",goodsDetailsURLstring,model.goods_id];
    goodsVC.shoppingCarInto = NO;
    [self.navigationController pushViewController:goodsVC animated:YES];
    
    

}



-(void)leftItemBttnClick{
    
    //    CATransition *animation = [CATransition animation];
    //    animation.duration = 0.25;
    //    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //    //        animation.type = @"rippleEffect";
    //    animation.type = kCATransitionPush;
    //    animation.subtype = kCATransitionFromLeft;
    //    [self.view.window.layer addAnimation:animation forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fanhuiSwipe:(UISwipeGestureRecognizer *)swipe{
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


@end
