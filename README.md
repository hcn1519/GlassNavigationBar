<p align="center">
  <img width="430" src="./images/glassNavigation.png">
</p>

#  Glass Navigation Bar

[![Build](https://travis-ci.com/hcn1519/GlassNavigationBar.svg?branch=master)](https://travis-ci.com/hcn1519/GlassNavigationBar)
[![Swift 4.1](https://img.shields.io/badge/Swift-4.1-%23FB613C.svg)](https://developer.apple.com/swift/)


## Feature

## Demo

<table class="tg">
  <tr>
    <th>Demo1</th>
    <th>Demo2</th>
  </tr>
  <tr>
    <td><img style="max-width: 200px" src="./images/gNav2.gif"></td>
    <td><img style="max-width: 200px" src="./images/gNav1.gif"></td>
  </tr>
</table>

## Installation

### CocoaPods

You can install the latest release version of CocoaPods with the following command

```bash
$ gem install cocoapods
```

Simply add the following line to your Podfile:

```ruby
pod "GlassNavigationBar"
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

`GlassNavigationBar` is written in Swift 4.1, and compatible with iOS 9.0+.

## How To Use

### Quick Start

1. Make your `navigationController` use `GlassNavigationController` instead of `UINavigationController`.

* If you use `storyboard`, Set the class of `navigationController` as `GlassNavigationController`.
* If you create your navigationController programatically, use `GlassNavigationController` instance instad of `UINavigationController` instance.

2. Use `setNavbarTheme(isTransparent: scrollView:)` for your navigationBar basic theme.

```swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let navbarController = self.navigationController as? GlassNavigationController {
        navbarController.setNavbarTheme(isTransparent: true, scrollView: scrollView, color: .green,
                                        tintColor: .yellow, hideBottomHairline: true, contentHeight: 600)
    }
}
```

3. Make your scrollview to put on your navigationBar.

```swift

override func viewDidLoad() {
    super.viewDidLoad()

    scrollView.delegate = self
    if let navbarController = self.navigationController as? GlassNavigationController {
        navbarController.extendedLayoutIncludesOpaqueBars(self)
        navbarController.scrollViewAboveNavigation(scrollView: scrollView)
    }
}

```

4. Set `UIScrollViewDelegate` to change your navigationBar's background color based on scroll.

```swift
extension ScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.scrollViewDidScroll(scrollView)
        }
    }
}
```

That's it. Build and run your app! 🎉🎉

### Property of GlassNavigationController

So far `GlassNavigationController` has 4 properties for you to use.

```swift
open var contentHeight: CGFloat?
```
`contentHeight` is the maximum height for navigation bar's alpha value. For example, if you set your `contentHeight` to 600, your navigationBar's alpha will be `1`, when your `scrollView.contentOffset.y` is 600.

If you don't set `contentHeight`, the default value will be `scrollView.contentSize.height`.

```swift
open var color: UIColor
```

`color` is for your navigationBar's background color.

```swift
open var isTransparent: Bool
```

`isTransparent` is for your navigationBar's transparency. If you set `isTransparent` to `true`, your navigationBar become transparent.

```swift
open var hideNavigationBottomLine: Bool
```

`UINavigationBar` has default bottomline. If you want to hide it, `hideNavigationBottomLine` to `true`.


![scrollViewAbove](./images/scrollviewAbove.png)
## License
