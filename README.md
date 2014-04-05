FKTabBarController
==================
FKTabBarController is intended to change the tabbar and items instead of UITabBarController.

- `import file` and `cast` are not necessary, except when the initialization.
- Change `TabBar` and `TabBarItem`

![FKTabBarController screenshot](https://raw.github.com/chion/FKTabBarController/master/Demo/screenshot.png "Screenshot")


Installation
----------

There are two ways to use this in your project:

- Copy `FKTabBarController/*.{h.m}` into your project

- Install with CocoaPods to write Podfile
```ruby
platform :ios
pod 'FKTabBarController',  '~> 1.0.4'
```

Usage
----------

- Setting TabBarController, TabBar and TabBarItem


Example
----------

### Setting TabBarController, TabBar and TabBarItem

```objc


FKTabBarController *tabBarController = [[FKTabBarController alloc]initWithNibName:nil bundle:nil];
NSMutableArray *viewControllers = [@[] mutableCopy];
NSMutableArray *items = @[].mutableCopy;
for (int i=0; i<4; i++) {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[DemoViewController alloc]initWithNibName:nil bundle:nil]];
    [viewControllers addObject:nc];
    item = [[FKTabBarItem alloc] initWithTitle:title
                                          icon:icon
                                 selectedColor:[UIColor greenColor]];
    [items addObject:item];
}
tabBarController.viewController = viewController;
tabBarController.tabBar.items = items;

```

### Using TabBarController, TabBar and TabBarItem

If use, need not to import file and cast.

```objc


UITabBarController *tabBarController = self.navigationController.tabBarController;

UITabBarItem *tabBarItem = tabBarController.tabBar.items[tabBarController.selectedIndex];
tabBarItem.badgeValue = [@([self.navigationController.viewControllers count]) stringValue];

```

## License

FKTabBarController is available under the MIT license.
