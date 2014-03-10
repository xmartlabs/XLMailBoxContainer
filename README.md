XLMailBoxContainer
==================

Custom container view controller ala MailBox app.

`XLSwipeContainerController` is the most important class of the library. Just using this class you can get the same functionality shown on the gif bellow.

XLSwipeContainerController handles a collection of childViewControllers created by the developer and also manages a UISegmentedControl, adding it to the parent UINavigationController and changing the color of it depending on which child view controller is selected.

`XLSwipeNavigationController` give us the possibility to create the UINavigationController along with the XLSwipeContainerController just passing a list of childViewControllets.

Each childViewController must conform `XLSwipeContainerChildItem` protocol.

You can use this pod along with [MCSwipeTableViewCell](https://github.com/alikaragoz/MCSwipeTableViewCell) to create an app that looks like MailBox app.



<p align="center"><img src="https://raw.github.com/xmartlabs/XLMailBoxContainer/master/example.gif"/></p>


Installation
--------

The easiest way to integrate XLMailBoxContainer in your projects is via [CocoaPods](http://cocoapods.org). 

1. Add the following line in the project's Podfile file.

`pod 'XLMailBoxContainer'`

2. Run the command `pod install` from the Podfile folder directory.

You can also install XLMailBoxContainer manually. We don't recommend this approach at all.
The source files you will need are included in XLMailBoxContainer/XL folder. 


Example
--------

Look at AppDelegate.m file.

The first think we should do is create each child viewController.

```objc
// create child view controllers that will be managed by XLSwipeContainerController
MailBoxTableChildViewController * child_1 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStylePlain];
MailBoxChildViewController * child_2 = [[MailBoxChildViewController alloc] init];
MailBoxTableChildViewController * child_3 = [[MailBoxTableChildViewController alloc] initWithStyle:UITableViewStyleGrouped];
MailBoxChildViewController * child_4 = [[MailBoxChildViewController alloc] init];
```

The second step is either create XLSwipeNavigationController using the child view controllers previously created or set up a XLSwipeContainerController and set it as rootViewController of any UINavigationController.  

```objc
// create XLSwipeNavigationController using the child view controllers previously created
self.window.rootViewController = [[XLSwipeNavigationController alloc] initWithViewControllers:child_1, child_2, child_3, child_4, nil];
```
or

NSArray * childViewControllers = @[child_1, child_2 ,child_3 ,child_4];
XLSwipeContainerController * containerController = [[XLSwipeContainerController alloc] initWithViewControllers:childViewControllers];
self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:containerController];

That's all folks!

XLMailBoxContainer files
--------

1. `XLSwipeContainerController` handles a collection of childViewControllers created by the developer and also manages a UISegmentedControl, adding it to the parent UINavigationController and changing the color of it depending on which child view controller is selected.

2. `XLSwipeNavigationController` give us the possibility to create the UINavigationController along with the XLSwipeContainerController just passing a list of childViewControllets.

License
--------
XLMailBoxContainer is distributed under MIT license, please feel free to use it and contribute.

Contact
--------

If you are using XLMailBoxContainer in your project and have any suggestion or question:

Martin Barreto, <martin@xmartlabs.com>

[@Xmartlabs](http://www.xmartlabs.com)

