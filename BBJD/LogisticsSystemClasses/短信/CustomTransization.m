//
//  CustomTransization.m
//  BBJD
//
//  Created by cbwl on 17/1/13.
//  Copyright © 2017年 CYT. All rights reserved.
//

#import "CustomTransization.h"

@implementation CustomTransization
- (instancetype) initWithNavigationController:(UINavigationController*)nc
{
    self = [super init];
    if (self) {
        nc.delegate= self;
    }
    
    return self;
}

//实现动画代理：

#pragma mark - UIViewControllerAnimatedTransitioning protocol

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor= [UIColor whiteColor];
    [containerView addSubview:toVC.view];
    
    CGRect fromFrame = fromVC.view.frame;
    CGRect toFrame = toVC.view.frame;
    
    fromFrame.origin.x= -fromFrame.size.width;
    toFrame.origin.x= containerView.frame.size.width;
    [toVC.view setFrame:toFrame];
    toFrame.origin.x= 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         delay:0
        usingSpringWithDamping:0.9f
         initialSpringVelocity:20
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        [fromVC.view setFrame:fromFrame];
                        [toVC.view setFrame:toFrame];
                    } completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                    }];
  
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}


#pragma mark - UINavigationControllerDelegate
/**
 * 关键实现这俩个方法 UINavigationControllerOperation包含了push还是pop的信息
 */
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController*)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC {
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController*)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    
    return nil;
}

@end
