//
//  DemoViewController.m
//  Demo
//
//  Created by Hirohisa Kawasaki on 13/05/18.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Demo:?";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Demo:%d", [self.navigationController.viewControllers count]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"next" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(50, 50, 50, 50);
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)next:(id)sender
{
    id demo = [[DemoViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:demo animated:YES];
    UITabBarController *tabBarController = self.navigationController.tabBarController;

    UITabBarItem *tabBarItem = tabBarController.tabBar.items[tabBarController.selectedIndex];
    tabBarItem.badgeValue = [@([self.navigationController.viewControllers count]) stringValue];
}

@end
