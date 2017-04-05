#import "UIViewController+runtime.h"
#import <objc/runtime.h>

@interface UIViewController ()<UIGestureRecognizerDelegate>
@end

@implementation UIViewController (runtime)

+ (void)load
{
    SEL systemDidLoadSel = @selector(viewDidLoad);
    SEL customDidLoadSel = @selector(swizzleviewDidLoad);
    [UIViewController swizzleSystemSel:systemDidLoadSel implementationCustomSel:customDidLoadSel];
}

+ (void)swizzleSystemSel:(SEL)systemSel implementationCustomSel:(SEL)customSel
{
    Class cls = [self class];
    Method systemMethod =class_getInstanceMethod(cls, systemSel);
    Method customMethod =class_getInstanceMethod(cls, customSel);
    
    // BOOL class_addMethod(Class cls, SEL name, IMP imp,const char *types) cls被添加方法的类，name: 被增加Method的name, imp 被添加的Method的实现函数，types被添加Method的实现函数的返回类型和参数的字符串
    BOOL didAddMethod = class_addMethod(cls, systemSel, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    if (didAddMethod)
    {
        class_replaceMethod(cls, customSel, method_getImplementation(systemMethod), method_getTypeEncoding(customMethod));
    }
    else
    {
        method_exchangeImplementations(systemMethod, customMethod);
    }
}

-(void)swizzleviewDidLoad{
    
    [self creactRightGesture];
    
}

#pragma mark 右滑返回上一级_________
///右滑返回上一级
-(void)creactRightGesture{
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)pan{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
