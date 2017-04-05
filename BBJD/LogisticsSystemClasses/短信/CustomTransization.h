//
//  CustomTransization.h
//  BBJD
//
//  Created by cbwl on 17/1/13.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTransization : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>
- (instancetype) initWithNavigationController:(UINavigationController*)nc;
@end
