#MMDrawerController Changelog

##0.5.1 (Wednesday, September 18, 2013)
###Fixed
* **FIXED** an issue ([#110](https://github.com/mutualmobile/MMDrawerController/pull/110)) where you could not compile for iOS 6 using Xcode 4.6.3.

##0.5.0 (Tuesday, September 17, 2013)
###New
* **iOS 7 Support** - Compiled to work with iOS 7
* **iOS 7 Status Bar Support** - Now includes a feature to drawer an iOS 6 style status bar, allowing your drawer animations to not impact the status bar area. Consult the README or the documentation for further information.
* **MMDrawerBarButtonItem Design** - Now designed to fit in with the iOS 7 aesthetic.
* **MMDrawerBarButtonItem TintColor** - Now uses tintColor in iOS 7.
* Example project now runs in both iOS 6 and iOS 7 with two different visual designs.

###Known Issues
* iOS 7 animations transforms are a bit choppy. This issue requires further investigation, and is being tracked [here](https://github.com/mutualmobile/MMDrawerController/issues/101).

##[0.4.0](https://github.com/mutualmobile/MMDrawerController/issues?milestone=8&page=1&state=closed) (Monday, August 19, 2013)
###New
* **State Restoration Support** - `MMDrawerController` now supports state restoration, and will save the state of the open side as well. Consult the [documentation](https://github.com/mutualmobile/MMDrawerController#state-restoration) for more information. ([#69](https://github.com/mutualmobile/MMDrawerController/pull/69)). (Kevin Harwood, djibouti33)
* **Better Subclass Support** - `MMDrawerController` now contains an additional Subclass header file, to allow subclasses to access protected methods of the framework. Please consult the [documentation](https://github.com/mutualmobile/MMDrawerController#subclassing) for additional details on how to properly subclass `MMDrawerController`. ([#37](https://github.com/mutualmobile/MMDrawerController/pull/37)). (Lars Anderson)
* **initWithCoder: Support** - `MMDrawerController` now implements `initWithCoder:`, making it easier to integrate with a storyboard. Looks for an official extension from @TomSwift providing storyboard integration. ([#81](https://github.com/mutualmobile/MMDrawerController/pull/81)). (Tom Swift)
* **Improved parent drawer controller detection** - `mm_drawerController` will now walk up the entire view controller stack looking for the parent, making it easier to access the drawer controller from any child view controller in the hierarchy. ([#70](https://github.com/mutualmobile/MMDrawerController/pull/70)). (messi)

###Fixed
* **FIXED** an issue ([#66](https://github.com/mutualmobile/MMDrawerController/pull/66)) where you would get unbalanced begin/end appearance transitions when using a non-animated `setCenterViewController:...` method. (Kevin Harwood, jsankey)
* **FIXED** an issue ([#63](https://github.com/mutualmobile/MMDrawerController/pull/63)) where the visual state block received invalid transform values. (Kevin Harwood)
* **FIXED** an issue ([#71](https://github.com/mutualmobile/MMDrawerController/pull/71)) where the side drawer could become blank if you called the `closeDrawerAnimated:...` while the drawer was closing. (Kevin Harwood, Bryan Wang)
* **FIXED** an issue ([#80](https://github.com/mutualmobile/MMDrawerController/pull/80)) where the block parameters were not named appropriately. (Kevin Harwood, Joao Nunes) 

##[0.3.0](https://github.com/mutualmobile/MMDrawerController/issues?milestone=6&page=1&state=closed) (Monday, July 22nd, 2013)
###New
* Added a block to determine if a gesture should be recognized, giving the implementer a chance to define where a gesture should be recognized within their views. Please consult the [README](https://github.com/mutualmobile/mmdrawercontroller#custom-gesture-recognizer-support) for additional details. ([#25](https://github.com/mutualmobile/MMDrawerController/pull/25)). (Kevin Harwood)

###Fixed
* **FIXED** an issue ([#56](https://github.com/mutualmobile/MMDrawerController/pull/56)) where the bezel gesture would be detected even if there was no drawer controller on that side. (Kevin Harwood)
* **FIXED** an issue ([#50](https://github.com/mutualmobile/MMDrawerController/pull/50)) where a subclass could get stuck in an infinite loop in the `init` method. (Tuan Cao)

##[0.2.1](https://github.com/mutualmobile/MMDrawerController/issues?milestone=7&state=closed) (Friday, June 21st, 2013)
###Fixed
* **FIXED** an issue([#42](https://github.com/mutualmobile/MMDrawerController/issues/42)) where the gesture completion block was not being called if the gesture action closed the drawer completely. (Kevin Harwood)

##[0.2.0](https://github.com/mutualmobile/MMDrawerController/issues?milestone=5&state=closed) (Tuesday, June 4th, 2013)
###New
* Added support for using the panning velocity to complete the animation. It now looks *much* better ([#18](https://github.com/mutualmobile/MMDrawerController/issues/18)). (Kevin Harwood)
* Added a new callback block to get notified when a gesture animation has completed ([#20](https://github.com/mutualmobile/MMDrawerController/issues/20)). (Kevin Harwood)

###Fixed
* **FIXED** an issue([#23](https://github.com/mutualmobile/MMDrawerController/issues/23)) where the drawer could bounce, even if a drawer was open. (Kevin Harwood)
* **FIXED** an issue([#38](https://github.com/mutualmobile/MMDrawerController/issues/38)) the designator initializer for `UIViewController` was not properly setting default values. (poteryaysya)
* **FIXED** an issue([#24](https://github.com/mutualmobile/MMDrawerController/issues/24)) where some documentation was incorrect. (Kevin Harwood)

##[0.1.0](https://github.com/mutualmobile/MMDrawerController/issues?milestone=3&page=1&state=closed) (Wednesday, May 15th, 2013)
###New
* `MMDrawerController` now properly supports full view controller containment. The drawer view controllers will properly receive their view appearance methods at the correct time now, including every time they are about to become visible. Please note that `mm_drawerWillApear` has now been deprecated. More notes below. (Kevin Harwood, Lars Anderson)

###Fixed
* **FIXED** an issue([#9](https://github.com/mutualmobile/MMDrawerController/issues/9)) where the drawer could bounce, even if no drawer was set. (Kevin Harwood)
* **FIXED** an issue([#14](https://github.com/mutualmobile/MMDrawerController/issues/14)) where open center interaction state could be incorrectly applied if a new view controller is pushed onto a center view controller when a drawer is open. (Kevin Harwood)

###Deprecated
* Support for the `mm_drawerWillAppear` method in the `UIViewController+MMDrawerController` category is no longer available. Please move any logic contained within this method to `viewWillAppear:` in your drawer view controllers. This method will no longer be called going forward.

##[0.0.2](https://github.com/mutualmobile/MMDrawerController/issues?milestone=2&state=closed) (Thursday, May 9th, 2013)
###New
* Improved the example to allow you to disable the left or right side drawer controller. (Kevin Harwood)

###Fixed
* **FIXED** an issue([#6](https://github.com/mutualmobile/MMDrawerController/issues/1)) where hidden side drawer controllers received touches if the center view controller was set to userInteraction NO. (Kevin Harwood)
* **FIXED** an issue([#1](https://github.com/mutualmobile/MMDrawerController/issues/1)) where `shouldStretchDrawer` caused drawer controllers with only one side drawer to stretch in the wrong direction (Lars Anderson, Kevin Harwood)

##0.0.1 (Wednesday, May 8th, 2013)
 * Initial Library Release