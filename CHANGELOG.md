#MMDrawerController Changelog

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