//
//  FKTabBarController.m
//  FKTabBarController
//
//  Created by Hirohisa Kawasaki on 13/05/07.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "FKTabBarController.h"

void FKSwizzleInstanceMethod(Class c, SEL original, SEL alternative)
{
    Method orgMethod = class_getInstanceMethod(c, original);
    Method altMethod = class_getInstanceMethod(c, alternative);
    if(class_addMethod(c, original, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) {
        class_replaceMethod(c, alternative, method_getImplementation(orgMethod), method_getTypeEncoding(orgMethod));
    } else {
        method_exchangeImplementations(orgMethod, altMethod);
    }
}

@interface UIImage (FKTabBarController)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation UIImage (FKTabBarController)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@interface UIView (FKTabBarController)
- (BOOL)validateCanscrollsToTop;
- (UIScrollView *)findEnabledscrollsToTopScrollView;
@end

@implementation UIView (FKTabBarController)

- (BOOL)validateCanscrollsToTop
{
    if ([[self class] isSubclassOfClass:[UIScrollView class]] &&
        [(UIScrollView *)self scrollsToTop]) {
        return YES;
    }
    return NO;
}

- (UIScrollView *)findEnabledscrollsToTopScrollView
{
    if ([self validateCanscrollsToTop]) {
        return (UIScrollView *)self;
    }
    for (UIView *subview in self.subviews) {
        id view = [subview findEnabledscrollsToTopScrollView];
        if (view) {
            return view;
        }
    }
    return nil;
}

@end

@interface UIViewController (FKTabBarController)
- (void)scrollsToTop;
@end

@implementation UIViewController (FKTabBarController)

- (void)scrollsToTop
{
    UIScrollView *scrollView = [self.view findEnabledscrollsToTopScrollView];
    if (scrollView) {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
}

@end

@interface UINavigationController (FKTabBarController)

@property (nonatomic, assign) id<UINavigationControllerDelegate> FKDelegate;

- (void)setTabBarController:(UIViewController*)viewController;

@end

@implementation UINavigationController (FKTabBarController)

- (void)setTabBarController:(UIViewController*)viewController
{
    [self setValue:viewController forKey:@"_parentViewController"];
}

- (UITabBarController *)tabBarController
{
    return (UITabBarController *)self.parentViewController;
}

static const char *FKTabBarDelegateKey = "FKTabBarDelegateKey";

+ (void)load
{
    FKSwizzleInstanceMethod([self class], @selector(setDelegate:), @selector(_setDelegate:));
}

- (void)_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if ([[delegate class] isSubclassOfClass:[FKTabBarController class]]) {
        [self _setDelegate:delegate];
    } else {
        self.FKDelegate = delegate;
    }
}

- (id<UINavigationControllerDelegate>)FKDelegate
{
    return objc_getAssociatedObject(self, FKTabBarDelegateKey);
}

- (void)setFKDelegate:(id<UINavigationControllerDelegate>)FKDelegate
{
    objc_setAssociatedObject(self, FKTabBarDelegateKey, FKDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface FKTabButtonLabel : UILabel
@end

@implementation FKTabButtonLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)sizeToFit
{
    [super sizeToFit];
    CGFloat length = CGRectGetHeight(self.frame) > CGRectGetWidth(self.frame)?CGRectGetHeight(self.frame):CGRectGetWidth(self.frame);
    self.frame = (CGRect) {
        .origin.x = CGRectGetMinX(self.frame),
        .origin.y = CGRectGetMinY(self.frame),
        .size.width = length,
        .size.height = length
    };
    self.layer.cornerRadius = length/2;
}

@end

@implementation FKTabButton
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                    badgeLabel:nil];
}

- (id)initWithFrame:(CGRect)frame badgeLabel:(UILabel *)badgeLabel
{
    if ((self = [super initWithFrame:frame])) {
        self.adjustsImageWhenHighlighted = NO;
        if (!badgeLabel) {
            badgeLabel = [[FKTabButtonLabel alloc] initWithFrame:CGRectZero];
        }
        _badgeLabel = badgeLabel;
        [self addSubview:self.badgeLabel];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    if ([badgeValue isEqual:@"0"]) badgeValue = nil;
    self.badgeLabel.text = badgeValue;
    if ([[self.badgeLabel class] isSubclassOfClass:[FKTabButtonLabel class]]) {
        [self.badgeLabel sizeToFit];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.imageView.frame.size, CGSizeZero)) {
        self.imageView.center = (CGPoint) {
            .x = CGRectGetWidth(self.frame)/2,
            .y = CGRectGetHeight(self.frame)/2
        };
        if (!CGSizeEqualToSize(self.titleLabel.frame.size, CGSizeZero)) {
            self.titleLabel.font = [self.titleLabel.font fontWithSize:9.];
            self.imageView.center = (CGPoint) {
                .x = CGRectGetWidth(self.frame)/2,
                .y = CGRectGetHeight(self.frame)/2 - 5
            };
            self.titleLabel.center = (CGPoint) {
                .x = CGRectGetWidth(self.frame)/2,
                .y = CGRectGetHeight(self.frame) - CGRectGetHeight(self.titleLabel.frame)/2 - 2
            };
        }
    }
    self.badgeLabel.hidden = !self.badgeLabel.text;
    if (!self.badgeLabel.hidden &&
        CGRectEqualToRect(self.badgeLabel.bounds, CGRectZero)) {
        [self.badgeLabel sizeToFit];
    }
    self.badgeLabel.center = (CGPoint) {
        .x = CGRectGetWidth(self.bounds)/2 +15.,
        .y = CGRectGetHeight(self.bounds)/2 -7.
    };
}

@end

@interface FKTabBarItem ()
@property (nonatomic) id delegate;
@property (nonatomic, readonly) UILabel *badgeLabel;
@end

@implementation FKTabBarItem

- (id)initWithTitle:(NSString *)title
               icon:(UIImage *)icon
      selectedColor:(UIColor *)selectedColor
{
    return [self initWithTitle:title
                          icon:icon
                 selectedColor:selectedColor
                    badgeLabel:nil];
}

- (id)initWithTitle:(NSString *)title
               icon:(UIImage *)icon
      selectedColor:(UIColor *)selectedColor
         badgeLabel:(UILabel *)badgeLabel
{
    self = [self init];
    if (self) {
        _title = title;
        _icon = icon;
        _selectedColor = selectedColor;
        _badgeLabel = badgeLabel;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    if ([self.delegate respondsToSelector:@selector(setBadgeValue:)]) {
        [self.delegate performSelector:@selector(setBadgeValue:) withObject:badgeValue];
    }
}

@end

@interface FKTabBarController (FKTabBar)
- (void)reselect:(BOOL)animated;
@end

@interface FKTabBar ()
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic) FKTabBarController *delegate;
@end

@implementation FKTabBar

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (BOOL)_isTranslucent
{
    return YES;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight(self.delegate.view.frame);
    if (!hidden) {
        frame.origin.y -= CGRectGetHeight(self.frame);
    }
    self.frame = frame;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    NSMutableArray *buttons = [@[] mutableCopy];
    for (FKTabBarItem *item in items) {
        FKTabButton *button = [[FKTabButton alloc]initWithFrame:CGRectZero
                                                     badgeLabel:item.badgeLabel];
        if (item.title) {
            [button setTitle:item.title forState:UIControlStateNormal];
        }
        if (item.icon) {
            [button setImage:item.icon forState:UIControlStateNormal];
        }
        if (item.selectedColor) {
            [button setBackgroundImage:[UIImage imageWithColor:item.selectedColor]
                              forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage imageWithColor:item.selectedColor]
                              forState:UIControlStateSelected|UIControlStateHighlighted];
        }
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        [buttons addObject:button];
        item.delegate = button;
    }
    self.buttons = buttons.copy;
    [self initialize];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        [self.delegate reselect:YES];
    } else {
        _selectedIndex = selectedIndex;
        [self.delegate switchViewControllers];
    }
    [self switchButtons];
}

- (FKTabBarItem *)selectedItem
{
    return [self.items objectAtIndex:self.selectedIndex];
}

- (void)initialize
{
    if ([self.delegate.viewControllers count] > 0) {
        _selectedIndex = 0;
        [self switchButtons];
        [self.delegate switchViewControllers];
    }
}

- (void)push:(id)sender
{
    [self deselectAllButtons];

    NSInteger index = 0;
    for (int i=0; i<[self.buttons count]; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if ([button isEqual:sender]) {
            index = i;
        }
    }
    self.selectedIndex = index;
}

- (void)deselectAllButtons
{
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
}

- (void)switchButtons
{
    for (int i=0; i<[self.buttons count]; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        [button setSelected:(i == self.selectedIndex)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds)/(([self.buttons count] > 0)?[self.buttons count]:1);
    CGFloat height = CGRectGetHeight(self.bounds);
    for (int i=0; i<[self.buttons count]; i++) {
        UIButton *button = (UIButton *)[self.buttons objectAtIndex:i];
        button.frame = CGRectMake(0 + width*i, 0, width, height);
    }
}
@end

@interface FKTabBarController () <UINavigationControllerDelegate> {
    BOOL _lock;
}
@end

@implementation FKTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        [self setup];
    }
    return self;
}

- (id)init
{
    if ((self = [super init])) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _tabBar = [[FKTabBar alloc]initWithFrame:CGRectZero];
    self.tabBar.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.frame = CGRectMake(0., 0., CGRectGetWidth(self.view.bounds), 50);
    CGFloat height = CGRectGetHeight(self.view.bounds)-(CGRectGetHeight(self.tabBar.bounds)/2);
    self.tabBar.center = CGPointMake(self.view.center.x, height);
}

#pragma mark - setter/getter
- (UIViewController *)selectedViewController
{
    return self.viewControllers[self.tabBar.selectedIndex];
}

- (id)_selectedViewControllerInTabBar
{
    return self.selectedViewController;
}

- (void)_hideBarWithTransition:(int)arg1 isExplicit:(BOOL)arg2;
{
    self.tabBar.hidden = YES;
}

- (void)showBarWithTransition:(int)arg1
{
    self.tabBar.hidden = NO;
}

- (void)_showBarWithTransition:(int)arg1 isExplicit:(BOOL)arg2
{
    self.tabBar.hidden = NO;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    for (UIViewController *viewController in viewControllers) {
        if ([[viewController class] isSubclassOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)viewController;
            [navigationController setTabBarController:self];
            navigationController.delegate = self;
        }
    }
    [self initialize];
}

- (NSInteger)selectedIndex
{
    return self.tabBar.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.tabBar.selectedIndex = selectedIndex;
}

#pragma mark - action
- (void)reselect:(BOOL)animated
{
    if (_lock) {
        return;
    }
    if ([[self.selectedViewController class] isSubclassOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.selectedViewController;
        if ([navigationController.viewControllers count] > 1) {
            [navigationController popToRootViewControllerAnimated:animated];
        } else {
            [navigationController.visibleViewController scrollsToTop];
        }
    }
}

#pragma mark - layout
- (void)initialize
{
    [self.view addSubview:self.tabBar];
    if ([self.tabBar.items count] > 0) {
        [self.tabBar initialize];
    }
}

- (void)switchViewControllers
{
    for (UIViewController *viewController in self.viewControllers) {
        if (![viewController isEqual:self.selectedViewController]) {
            [viewController.view removeFromSuperview];
            if ([viewController respondsToSelector:@selector(removeFromParentViewController)]) {
                [viewController removeFromParentViewController];
            }
        }
    }
    if (self.selectedViewController != nil) {
        self.selectedViewController.view.frame = self.view.bounds;
        if ([self respondsToSelector:@selector(addChildViewController:)]) {
            [self addChildViewController:self.selectedViewController];
        }
        if ([self.selectedViewController respondsToSelector:@selector(didMoveToParentViewController:)]) {
            [self.selectedViewController didMoveToParentViewController:self];
        }
    }
    [self.view insertSubview:self.selectedViewController.view belowSubview:self.tabBar];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _lock = YES;
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [navigationController.FKDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    _lock = NO;
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [navigationController.FKDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
}

- (NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
{
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [navigationController.FKDelegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return -1;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [navigationController.FKDelegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return -1;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [navigationController.FKDelegate navigationController:navigationController interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (navigationController.FKDelegate &&
        [navigationController.FKDelegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [navigationController.FKDelegate navigationController:navigationController
                                     animationControllerForOperation:operation
                                                  fromViewController:fromVC
                                                    toViewController:toVC];
    }
    return nil;
}

@end
