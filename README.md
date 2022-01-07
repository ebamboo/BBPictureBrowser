![BBPictureBrowser](https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/readme/title.png)
# BBPictureBrowser
一个轻量级的图片浏览器，支持本地图片和网络图片的展示，适用于 Swift 和 Objective-C。
# Preview
* 基本功能

![基本功能](https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/readme/1.gif)
* 图片缩放

![图片缩放](https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/readme/2.gif)
* 自定义 UI

![自定义 UI](https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/readme/3.gif)
* 动画效果

![动画效果](https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/readme/4.gif)
# Installation
#### Requirements
* Xcode 8 or higher
* iOS 11.0 or higher
* ARC
#### Cocoapods
```
pod 'BBPictureBrowser'
```
#### Manually
1. 下载 BBPictureBrowser。
2. 添加 "BBPictureBrowser/BBPictureBrowser" 文件夹到项目中。
# Use
#### 导入文件
* Swift 中在需要引用的地方 
```
import BBPictureBrowser
```
* Objective-C 中在需要引用的地方
```
#import "BBPictureBrowser.h"
```
#### 简单使用
* 本地图片+网络图片
```
            NSArray *pictureList = @[
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/01.gif"],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"10"] webImage:nil],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/03.gif"],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"11"] webImage:nil],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/05.jpeg"]
            ];
            BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:nil animateFromView:nil];
            [browser bb_openOnView:self.view.window atIndex:0];
```
#### 自定义 UI
* 自定义顶部视图，实现以下协议
```
- (CGFloat)bb_pictureBrowserHeightForTopBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForTopBar:(nullable BBPictureBrowser *)browser;
```
* 自定义底部视图，实现以下协议
```
- (CGFloat)bb_pictureBrowserHeightForBottomBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForBottomBar:(nullable BBPictureBrowser *)browser;
```
#### 动画效果
* 开启显示时的动画
```
browser.bb_animateFromView = someView;
```
* 实现关闭时的动画，需要实现以下协议
```
- (nullable UIView *)bb_pictureBrowser:(nullable BBPictureBrowser *)browser animateToViewAtIndex:(NSInteger)index;
```
# API
* Delegate
```
@class BBPictureBrowser;
@protocol BBPictureBrowserDelegate <NSObject>
@optional
/// 图片浏览器关闭动画
/// return：图片浏览器关闭时，动画缩放到的视图
/// 若返回 nil 则没有关闭动画
- (nullable UIView *)bb_pictureBrowser:(nullable BBPictureBrowser *)browser animateToViewAtIndex:(NSInteger)index;

/// 自定义顶部工具栏
- (CGFloat)bb_pictureBrowserHeightForTopBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForTopBar:(nullable BBPictureBrowser *)browser;

/// 自定义底部工具栏
- (CGFloat)bb_pictureBrowserHeightForBottomBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForBottomBar:(nullable BBPictureBrowser *)browser;

/// 图片浏览器展示了下标为 index 的图片
- (void)bb_pictureBrowser:(nullable BBPictureBrowser *)browser didShowPictureAtIndex:(NSInteger)index topBar:(nullable UIView *)topBar bottomBar:(nullable UIView *)bottomBar;

@end
```
* Class
```
@interface BBPictureBrowser : UIView

/// 构造器
/// @param pictures 要展示的图片
/// @param delegate 设置代理可以监听和响应事件、实现自定义 UI 和关闭动画
/// @param view 图片浏览器打开时动画开始位置视图，若为 nil 则没有打开动画
- (nonnull instancetype)initWithPictures:(nonnull NSArray<BBPictureModel *> *)pictures delegate:(nullable id<BBPictureBrowserDelegate>)delegate animateFromView:(nullable UIView *)view;
+ (nonnull instancetype)browserWithPictures:(nonnull NSArray<BBPictureModel *> *)pictures delegate:(nullable id<BBPictureBrowserDelegate>)delegate animateFromView:(nullable UIView *)view;

- (void)bb_openOnView:(nonnull UIView *)onView atIndex:(NSInteger)index;
- (void)bb_close;

@property (nonatomic, readonly) NSInteger bb_currentIndex;
@property (nonatomic, readonly, nonnull) NSArray <BBPictureModel *> *bb_pictureList;

@end
```
# License
BBPictureBrowser is distributed under the MIT license. See LICENSE file for details.

