//
//  DemoTabBarController.m
//  Demo
//
//  Created by Hirohisa Kawasaki on 13/05/18.
//  Copyright (c) 2013年 Hirohisa Kawasaki. All rights reserved.
//

#import "DemoTabBarController.h"

@interface DemoTabBarController ()

@end

@implementation DemoTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.frame = CGRectMake(0., 0., CGRectGetWidth(self.view.bounds), 40);
    self.tabBar.backgroundColor = [UIColor blackColor];
    CGFloat height = CGRectGetHeight(self.view.bounds)-(CGRectGetHeight(self.tabBar.bounds)/2);
    self.tabBar.center = CGPointMake(self.view.center.x, height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
