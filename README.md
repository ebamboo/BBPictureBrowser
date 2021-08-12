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
* 本地图片
```
NSArray *nameList = @[@"01", @"02", @"03", @"04", @"05"];
NSMutableArray *pictureList = [NSMutableArray array];
for (NSString *name in nameList) {
    BBPictureBrowserPictureModel *model = [BBPictureBrowserPictureModel new];
    model.bb_image = [UIImage imageNamed:name];
    [pictureList addObject:model];
}

BBPictureBrowser *browser = [BBPictureBrowser new];
browser.bb_pictureList = pictureList;
[browser bb_showOnView:self.view.window atIndex:0];
```
* 网络图片
```
NSArray *urlList = @[
    @"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/01.jpeg",
    @"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/02.gif",
    @"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/03.jpeg",
    @"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/04.gif",
    @"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/05.jpeg"
];
NSMutableArray *pictureList = [NSMutableArray array];
for (NSString *url in urlList) {
    BBPictureBrowserPictureModel *model = [BBPictureBrowserPictureModel new];
    model.bb_webImageUrl = url;
    [pictureList addObject:model];
}

BBPictureBrowser *browser = [BBPictureBrowser new];
browser.bb_pictureList = pictureList;
[browser bb_showOnView:self.view.window atIndex:2];
```
* 本地图片+网络图片
```
NSArray *pictureList = @[
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/01.gif"],
    [BBPictureBrowserPictureModel bb_modelWithImage:[UIImage imageNamed:@"10"] webImage:nil],
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/03.gif"],
    [BBPictureBrowserPictureModel bb_modelWithImage:[UIImage imageNamed:@"11"] webImage:nil],
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/05.jpeg"]
];

BBPictureBrowser *browser = [BBPictureBrowser new];
browser.bb_pictureList = pictureList;
[browser bb_showOnView:self.view.window atIndex:0];
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
# License
BBPictureBrowser is distributed under the MIT license. See LICENSE file for details.

