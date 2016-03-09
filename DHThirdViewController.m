//
//  DHThirdViewController.m
//  XY2
//
//  Created by xy2 on 16/3/8.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "DHThirdViewController.h"
#import "DHHttpBusServer.h"
#import "DHThirdModel.h"
#import "UIImageView+WebCache.h"
@interface DHThirdViewController ()
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation DHThirdViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.980 alpha:1];
    
    self.dataArr = [NSMutableArray array];
    
    [DHHttpBusServer asyncNearbyListWithApi:@"http://api5.lingte.cc/web/getvodtype" parameters:nil method:DHRequestMethodTypeGet server:0 success:^(id result, NSInteger code) {
        
        NSArray *array = [result objectForKey:@"data"];
        for (NSDictionary *dict in array) {
            DHThirdModel *item =[[DHThirdModel alloc]init];
            [item setValuesForKeysWithDictionary:dict];
            [self.dataArr addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } falureMsg:^(NSString *msg) {
        
    } falure:^(NSDictionary *userInfo) {
        
    }];
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    DHThirdModel *item = [self.dataArr objectAtIndex:indexPath.item];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:cell.bounds];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.img]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            imageV.image = [UIImage imageWithData:data];
//        });
//    });
    [imageV sd_setImageWithURL:[NSURL URLWithString:item.img] placeholderImage:[UIImage imageNamed:@"111.jpg"]];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, CGRectGetMaxY(cell.bounds)-25, CGRectGetWidth(cell.bounds), 25);
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.text = item.name;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    [imageV addSubview:label];
    [cell.contentView addSubview:imageV];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(150, 150);
}

//设置每组的cell的边界, 具体看下图
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
