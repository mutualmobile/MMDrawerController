#MMDrawerController Changelog
##[0.6.0](https://github.com/mutualmobile/MMDrawerController/issues?q=milestone%3A0.6.0+is%3Aclosed) (Thursday, April 2, 2015)
###New
* **Removed iOS 6 support** ([#350](https://github.com/mutualmobile/MMDrawerController/pull/350))([#356](https://github.com/mutualmobile/MMDrawerController/pull/356)) (Kevin Harwood, podkovyrin)
* **Migrated from id to instancetype** ([#349](https://github.com/mutualmobile/MMDrawerController/pull/349)) (Kevin Harwood)
* **Added iPhone 6/6+ support to example project** ([#347](https://github.com/mutualmobile/MMDrawerController/pull/347)) (Kevin Harwood)
* **Added new properties for Shadow Radius, Shadow Opacity, Shadow Offset, Bezel Gesture Size, and Pan Velocity thresholds** Please consult the documentation for additional information. ([#294](https://github.com/mutualmobile/MMDrawerController/pull/294))([#338](https://github.com/mutualmobile/MMDrawerController/pull/338))([#270](https://github.com/mutualmobile/MMDrawerController/pull/270))([#194](https://github.com/mutualmobile/MMDrawerController/pull/194)) (SanggeonPark, lbasile, boherna, MartinMoizard)

###Fixed
* **FIXED** an issue ([#288](https://github.com/mutualmobile/MMDrawerController/pull/288)) rotation methods were called twice on iOS 8. (arielitovsky)
* **FIXED** an issue ([#348](https://github.com/mutualmobile/MMDrawerController/pull/348)) where the drawer height was incorrectly set when using a dummy status bar.
* **FIXED** an issue ([#324](https://github.com/mutualmobile/MMDrawerController/pull/324)) where we called removeFromParentViewController out of order. (long)
* **FIXED** an issue ([#306](https://github.com/mutualmobile/MMDrawerController/pull/306)) where the podspec incorrectly caused a duplicate reference warning. (klundberg)

##[0.5.7](https://github.com/mutualmobile/MMDrawerController/issues?q=milestone%3A0.5.7+is%3Aclosed) (Monday,  August 25th, 2014)
###Fixed
* **FIXED** an issue ([#271](https://github.com/mutualmobile/MMDrawerController/pull/271)) where state restoration would cause multiple calls to viewDidAppear. (pronebird)
* **FIXED** an issue ([#269](https://github.com/mutualmobile/MMDrawerController/pull/269)) where an internal method name was misnamed. (shoecart)

##[0.5.6](https://github.com/mutualmobile/MMDrawerController/issues?milestone=14&page=1&state=closed) (Monday,  June 9th, 2014)
###Fixed
* **FIXED** an issue ([#259](https://github.com/mutualmobile/MMDrawerController/pull/259)) where the side would rarely show up hidden when opening. (Eric Miller, Lars Anderson, Kevin Harwood)
* **FIXED** an issue ([#251](https://github.com/mutualmobile/MMDrawerController/pull/251)) where the completion block would not be called if you set the new center view controller with a full close animation while the drawer was closed. (ThuggishNuggets)
* **FIXED** an issue ([#246](https://github.com/mutualmobile/MMDrawerController/pull/246)) where user could interact with content while an animation completed. (jgallagher, Kevin Harwood)
* **FIXED** an issue ([#232](https://github.com/mutualmobile/MMDrawerController/pull/232)) where the drawer controller was not properly calling willMoveToParentViewController:nil when removing children from the drawer container view controller. (Josh Berlin, Kevin Harwood)
* **FIXED** an issue ([#222](https://github.com/mutualmobile/MMDrawerController/pull/222)) where a user interacting with during rotation would cause UI glitches. (Kevin Harwood, vkormushkin)
* **FIXED** an ([#220](https://github.com/mutualmobile/MMDrawerController/pull/220)) where we were setting the background color on the wrong view, which prevented setting a custom background color for the entire view. (Kevin Harwood, David Dulak, trawor)

##[0.5.5](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.5) (Wednesday, April 30, 2014)
###Fixed
* **FIXED** an issue ([#244](https://github.com/mutualmobile/MMDrawerController/pull/244)) where a user could continue to interact with the view while a pan gesture animation was ongoing. (Kevin Harwood, Patrick Hernandez)

##[0.5.4](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.4) (Tuesday, April 15, 2014)
###Fixed
* **FIXED** an issue ([#240](https://github.com/mutualmobile/MMDrawerController/pull/240)) where the center container view controller would be init'ed twice. (Lars Anderson)
* **FIXED** an issue ([#226](https://github.com/mutualmobile/MMDrawerController/pull/226)) where the side drawer would not be refreshed on a viewWill/DidAppear call. (kk-achu)
* **FIXED** an issue ([#224](https://github.com/mutualmobile/MMDrawerController/pull/224)) where we had some unreachable code. (tewha)


##[0.5.3](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.3) (Tuesday, February 18, 2014)
###Fixed
* **FIXED** an issue ([#219](https://github.com/mutualmobile/MMDrawerController/pull/219)) where you would get an unbalanced appearance method call if you set the center view controller to the same center view controller.

##[0.5.2](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.2) (Friday, January 31, 2014)
###New
* **Added Highlighting for iOS 7 Drawer Button Item** - Now supporting button highlighting. Also stream lined code path for iOS 6 menu button. ([#199](https://github.com/mutualmobile/MMDrawerController/pull/119)) (TomSwift)

###Fixed
* **FIXED** a Clang Analyzer issue ([#120](https://github.com/mutualmobile/MMDrawerController/pull/120)) found in Xcode 5. (klundberg)
* **FIXED** an issue ([#124](https://github.com/mutualmobile/MMDrawerController/pull/124)) where the navigation bar gestures would not work if a toolbar was displayed in the center view controller. (tbveralrud)
* **FIXED** an issue ([#152](https://github.com/mutualmobile/MMDrawerController/pull/152)) where two childControllerContainers view could be init'ed and added to the view hierarchy. (Kevin Harwood, JonasGessner)
* **FIXED** an issue ([#163](https://github.com/mutualmobile/MMDrawerController/pull/163)) where the navigation bar touch areas were smaller than they were supposed to be. (antonholmquist)
* **FIXED** an issue ([#177](https://github.com/mutualmobile/MMDrawerController/pull/177)) where disabling the shadow caused a performance issue in iOS 7. (Lars Anderson)
* **FIXED** an issue ([#211](https://github.com/mutualmobile/MMDrawerController/pull/211)) where the side drawer may become hidden if you try to interact with it during an animation. (Kevin Harwood, antonholmquist)
* **FIXED** an issue ([#212](https://github.com/mutualmobile/MMDrawerController/pull/212)) where the view controller appearance methods were not correctly send to the center view controller if you exchanged it while neither drawer was open. (Kevin Harwood, Club15CC)

##[0.5.1](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.1) (Wednesday, September 18, 2013)
###Fixed
* **FIXED** an issue ([#110](https://github.com/mutualmobile/MMDrawerController/pull/110)) where you could not compile for iOS 6 using Xcode 4.6.3.

##[0.5.0](https://github.com/mutualmobile/MMDrawerController/releases/tag/0.5.0) (Tuesday, September 17, 2013)
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
