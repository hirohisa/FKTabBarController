FKTabBarController
==================
FKTabBarController is like UITabBarController

## Example Usage

```objective-c
DemoTabBarController *tabBarController = [[DemoTabBarController alloc]initWithNibName:nil bundle:nil];
NSMutableArray *viewControllers = @[].mutableCopy;
NSMutableArray *items = @[].mutableCopy;
for (int i=0; i<4; i++) {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[DemoViewController alloc]initWithNibName:nil bundle:nil]];
    [viewControllers addObject:nc];
    UIImage *icon = [UIImage imageWithColor:[UIColor clearColor]];
    [items addObject:[[FKTabBarItem alloc] initWithIcon:icon
                                          selectedColor:[UIColor blackColor]
                                        unselectedColor:[UIColor grayColor]]];
}
[tabBarController setViewControllers:viewControllers items:items];
```

## License

FKTabBarController is available under the MIT license. See the LICENSE file for more info.
