#Mutual Mobile Drawer Controller
`MMDrawerController` is a side drawer navigation container view controller designed to support the growing number of applications that leverage the side drawer paradigm. This library is designed to exclusively support side drawer navigation in a light-weight, focused approach while exposing the ability to provide custom animations for presenting and dismissing the drawer.

<p align="center" >
<img src="http://mutualmobile.github.io/MMDrawerController/ExampleImages/example1.png" width="266" height="500"/>
<img src="http://mutualmobile.github.io/MMDrawerController/ExampleImages/example2.png" width="266" height="500"/>
</p>

<!-- MacBuildServer Install Button -->
<p align="center" >
    <a href="http://macbuildserver.com/project/github/build/?xcode_project=KitchenSink%2FMMDrawerControllerKitchenSink.xcodeproj&amp;target=MMDrawerControllerKitchenSink&amp;repo_url=git%3A%2F%2Fgithub.com%2Fmutualmobile%2FMMDrawerController.git&amp;build_conf=Release" target="_blank"><img src="http://com.macbuildserver.github.s3-website-us-east-1.amazonaws.com/button_up.png" align="center"/><br/><sup><a href="http://macbuildserver.com/github/opensource/" target="_blank">by MacBuildServer</a></sup></a>
</p>
<!-- MacBuildServer Install Button -->


---
##Documentation
Official appledoc documentation can be found at [CocoaDocs](http://cocoadocs.org/docsets/MMDrawerController/).

---
##Installing MMDrawerController
<img src="http://cocoapod-badges.herokuapp.com/v/MMDrawerController/badge.png"/><br/>
You can install MMDrawerController in your project by using [CocoaPods](https://github.com/cocoapods/cocoapods):

```Ruby
pod 'MMDrawerController', '~> 0.2.0'
```

---
##Creating a Drawer Controller
Creating a `MMDrawerController` is as easy as creating a center view controller and the drawer view controllers, and init'int the drawer.

```Objective-C
UIViewController * leftDrawer = [[UIViewController alloc] init];
UIViewController * center = [[UIViewController alloc] init];
UIViewController * rightDrawer = [[UIViewController alloc] init];

MMDrawerController * drawerController = [[MMDrawerController alloc]
                                  	   initWithCenterViewController:center
										   leftDrawerViewController:leftDrawer
										   rightDrawerViewController:rightDrawer];
```

---
##Features

###UINavigationController Support
`MMDrawerController` seamlessly accepts a `UINavigationController` as the `centerViewController`, and will update all of the gesture support automatically. In addition, any child view controller contained within the `UINavigationController` will have access to the parent drawer controller using the category explained [below](#accessing-the-drawer-controller-from-a-child-view-controller).

###UIGestureRecognizer Support
`MMDrawerController` exposes gesture support for opening and closing the drawer through two masks, one for opening and one for closing. The options are as follows:

* **MMOpenDrawerGestureMode**
 * **MMOpenDrawerGestureModePanningNavigationBar**: The user can open the drawer by panning anywhere on the navigation bar.
 * **MMOpenDrawerGestureModePanningCenterView**: The user can open the drawer by panning anywhere on the center view.
 * **MMOpenDrawerGestureModeBezelPanningCenterView**: The user can open the drawer by starting a pan anywhere within 20 points of the bezel.

* **MMCloseDrawerGestureMode**
 * **MMCloseDrawerGestureModePanningNavigationBar**: The user can close the drawer by panning anywhere on the navigation bar.
 * **MMCloseDrawerGestureModePanningCenterView**: The user can close the drawer by panning anywhere on the center view.
 * **MMCloseDrawerGestureModeBezelPanningCenterView**: The user can close the drawer by starting a pan anywhere within the bezel of the center view.
 * **MMCloseDrawerGestureModeTapNavigationBar**: The user can close the drawer by tapping the navigation bar.
 * **MMCloseDrawerGestureModeTapCenterView**: The user can close the drawer by tapping the center view.
 * **MMCloseDrawerGestureModePanningDrawerView**: The user can close the drawer by panning anywhere on the drawer view.
 
You are free to set whatever combination you want for opening and closing. Note that these gestures may impact touches sent to the child view controllers, so be sure to use these appropriately for your application. For example, you wouldn't want `MMOpenDrawerGestureModePanningCenterView` set if a `MKMapView` is your center view controller, since it would intercept the pan meant for moving around the map.

###Custom Drawer Open/Close Animations
`MMDrawerController` provides a callback block that allows you to implement your own custom state for the drawer controller when an open/close or pan gesture event happens. Within the block, you are responsible for updating the visual state of the drawer controller, and the drawer controller will handle animating to that state.

For example, to set the alpha of the side drawer controller from 0 to 1 during an animation, you would do the following:

```Objective-C
[drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         UIViewController * sideDrawerViewController;
		 if(drawerSide == MMDrawerSideLeft){
			 sideDrawerViewController = drawerController.leftDrawerViewController;
		 }
		 else if(drawerSide == MMDrawerSideRight){
			 sideDrawerViewController = drawerController.rightDrawerViewController;
		 }
		 [sideDrawerViewController setAlpha:percentVisible];
     }];
```

In addition, `MMDrawerController` ships with several prebuilt animations to let you go crazy right out of the box. These are included as a subspec for the project, and more information can be found [below](#prebuilt-example-animations).

###Center View Controller Interaction Mode
When a drawer is open, you can control how a user can interact with the center view controller. 

* **MMDrawerOpenCenterInteractionModeNone**: The user can not interact with any content in the center view.
* **MMDrawerOpenCenterInteractionModeFull**: The user can interact with all content in the center view.
* **MMDrawerOpenCenterInteractionModeNavigationBarOnly**: The user can interact with only content on the navigation bar. The setting allows the menu button to still respond, allowing you to toggle the drawer closed when it is open. This is the default setting.

###Accessing the Drawer Controller from a Child View Controller
You can use the `UIViewController+MMDrawerController` category in order to query the drawerController directly from child view controllers.

---
##Bells and Whistles
A few extras to make your life easier...

###MMDrawerBarButtonItem
Using Paint Code, we created a standard Menu Button that you can use in any `UINavigationBar`, and make it whatever color you want. It's included as a subspec to this library. Enjoy.

###Prebuilt Example Animations
In order to make it as easy as possible for you to use this library, we built some of the common animations we see out there today. Simply include the `MMDrawerVisualState` subspec, and use any of the prebuilt visual states.

For example, if you wanted to use a slide and scale animation, you would do the following:

```Objective-C
[drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
```

And that's it...

Here's a quick list of the built in animations:

* **Slide**: The drawer slides at the same rate as the center view controller.
* **Slide and Scale**: The drawer slides and scales up at the same time, while also alpha'ing from 0.0 to 1.0.
* **Swinging Door**: The drawer swings in along a hinge on the center view controller.
* **Parallax**: The drawer slides in at a slower rate than the center view controller, giving a parallax effect.

###Stretchy Drawer
By default, the side drawer will stretch if the user pans past the maximum drawer width. This gives a playful stretch effect. You can disable this by setting `shouldStretchDrawer` to NO, or you can make your own overshoot animation by creating a custom visual state block and setting up custom transforms for when percentVisible is greater than 1.0

###Nifty Example
We decided to spruce up the example a bit using graphics generated from PaintCode. Hope you like it.

The example shows off all the features of the library. Give it a whirl.

---
##What this Library Doesn't Do
In order to keep this library light-weight, we had to make some design trade off decisions. Specifically, we decided this library would NOT DO the following:

* Top or bottom drawer views
* Displaying both drawers at one time
* Displaying a minimum drawer width
* Support container view controllers other than `UINavigationController` (such as `UITabBarController` or `UISplitViewController`) as the center view controller. 
* Support presenting the drawer above the center view controller (like the Google+ app).

We're sure this list will grow over time. But that's the cost of keeping something maintainable :)

---
##Credit
Designed and Developed by these fine folks at [Mutual Mobile](http://mutualmobile.com):

###Development

* [Kevin Harwood](http://twitter.com/kevinharwood)
* [Lars Anderson](http://twitter.com/theonlylars)
* [Rene Cacheaux](http://twitter.com/rcachatx)
* [Conrad Stoll](http://twitter.com/conradstoll)

###Design

* [Matt McDaniel](http://twitter.com/supermattzor)

---
##Feedback
We'd love to hear feedback on the library. Create Github issues, or hit us up on Twitter.

---
##License
`MMDrawerController` is available under the MIT license. See the LICENSE file for more info.