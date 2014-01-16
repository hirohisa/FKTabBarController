FKTabBarController
==================
FKTabBarController is intended to change the tabbar and items instead of UITabBarController

![FKTabBarController screenshot](https://raw.github.com/chion/FKTabBarController/master/Demo/screenshot.png "Screenshot")

### Example Usage

#### Setting

```objective-c
FKTabBarController *tabBarController = [[FKTabBarController alloc]initWithNibName:nil bundle:nil];
NSMutableArray *viewControllers = [@[] mutableCopy];
NSMutableArray *items = @[].mutableCopy;
for (int i=0; i<4; i++) {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[DemoViewController alloc]initWithNibName:nil bundle:nil]];
    [viewControllers addObject:nc];
    UIImage *icon = [UIImage imageWithColor:[UIColor clearColor]];
    [items addObject:[[FKTabBarItem alloc] initWithIcon:icon
                                          selectedColor:[UIColor blackColor]
                                        unselectedColor:[UIColor grayColor]]];
}
tabBarController.viewController = viewController;
tabBarController.tabBar.items = items;
```

#### Using

if use, need not to import file and cast.
use UITabBarController and UITabBarItem

```objective-c
UITabBarController *tabBarController = self.navigationController.tabBarController;

UITabBarItem *tabBarItem = tabBarController.tabBar.items[tabBarController.selectedIndex];
tabBarItem.badgeValue = [@([self.navigationController.viewControllers count]) stringValue];
```

### License

FKTabBarController is available under the MIT license.
