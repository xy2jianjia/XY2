//
//  AppDelegate+ConfigControllers.m
//  XY2
//
//  Created by xy2 on 16/3/8.
//  Copyright © 2016年 xy2. All rights reserved.
//

#import "AppDelegate+ConfigControllers.h"

@implementation AppDelegate (ConfigControllers)

- (void)configControllers{
    self.window = [[UIWindow alloc]init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    self.childVcs = [NSMutableArray array];
    NSArray *array = @[@"DHFirstViewController",@"DHSecondViewController",@"DHThirdViewController",@"DHForeViewController"];
    NSArray *controllersArr = [self loadNavagationVcWithArray:array];
    UITabBarController *tab = [[UITabBarController alloc]init];
    [tab setViewControllers:controllersArr];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
}
- (NSArray *)loadNavagationVcWithArray:(NSArray *)array{
    NSInteger index = 0;
    for (NSString *controllerName in array) {
        UIViewController *vc = nil;
        if (index == 0) {
            vc = [[DHFirstViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
        }else if(index == 3){
            vc = [[DHForeViewController alloc]initWithStyle:(UITableViewStyleGrouped)];
        }else if(index == 1){
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//            layout.itemSize = CGSizeMake(70, 100);
            vc = [[DHSecondViewController alloc]initWithCollectionViewLayout:layout];
        }else{
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//            layout.itemSize = CGSizeMake(70, 100);
            vc = [[DHThirdViewController alloc]initWithCollectionViewLayout:layout];
        }
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        nc.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:index+5 tag:index];
        [self.childVcs addObject:nc];
        index ++;
    }
    return self.childVcs;
    
    
}

@end
