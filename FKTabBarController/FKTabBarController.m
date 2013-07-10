//
//  FKTabBarController.m
//  FKTabBarController
//
//  Created by Hirohisa Kawasaki on 13/05/07.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "FKTabBarController.h"

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

@interface UINavigationController (FKTabBarController)
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
@end

@implementation FKTabBarItem
- (id)initWithIcon:(UIImage *)icon selectedColor:(UIColor *)selectedColor unselectedColor:(UIColor *)unselectedColor
{
    if ((self = [super init])) {
        _icon = icon;
        _selectedColor = selectedColor;
        _unselectedColor = unselectedColor;
    }
    return self;
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
        self.selectedIndex = 0;
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    NSMutableArray *buttons = @[].mutableCopy;
    for (int i=0; i<[self.items count]; i++) {
        FKTabBarItem *item = [self.items objectAtIndex:i];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
        [button setImage:item.icon forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:item.unselectedColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:item.selectedColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        [buttons addObject:button];
    }
    self.buttons = buttons;
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

- (void)push:(id)sender
{
    NSInteger index = 0;
    for (int i=0; i<[self.buttons count]; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if ([button isEqual:sender]) {
            index = i;
        }
    }
    self.selectedIndex = index;
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

@interface FKTabBarController ()
@end

@implementation FKTabBarController
@synthesize tabBar = _tabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
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
    return [self.viewControllers objectAtIndex:self.tabBar.selectedIndex];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    for (UIViewController *viewController in viewControllers) {
        if ([[viewController class] isSubclassOfClass:[UINavigationController class]]) {
            [(UINavigationController *)viewController setTabBarController:self];
        }
    }
    [self initialize];
}

- (UIView *)tabBar
{
    if (_tabBar == nil) {
        _tabBar = [[FKTabBar alloc]initWithFrame:CGRectZero];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

#pragma mark - action
- (void)reselect:(BOOL)animated
{
    if ([[self.selectedViewController class] isSubclassOfClass:[UINavigationController class]]) {
        [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:animated];
    }
}

#pragma mark - layout
- (void)initialize
{
    [self.view addSubview:self.tabBar];
    [self switchViewControllers];
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
    }
    [self.view insertSubview:self.selectedViewController.view belowSubview:self.tabBar];
}
@end
