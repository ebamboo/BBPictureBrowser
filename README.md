![BBPictureBrowser](https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/readme/title.png)
# BBPictureBrowser
一个轻量级的图片浏览器，支持本地图片和网络图片的展示，适用于 Swift 和 Objective-C。
# Preview
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
#import <BBPictureBrowser.h>
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
    @"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/jpeg/01.jpeg",
    @"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/gif/02.gif",
    @"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/jpeg/03.jpeg",
    @"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/gif/04.gif",
    @"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/jpeg/05.jpeg"];
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
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/gif/01.gif"],
    [BBPictureBrowserPictureModel bb_modelWithImage:[UIImage imageNamed:@"10"] webImage:nil],
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/gif/03.gif"],
    [BBPictureBrowserPictureModel bb_modelWithImage:[UIImage imageNamed:@"11"] webImage:nil],
    [BBPictureBrowserPictureModel bb_modelWithImage:nil webImage:@"https://gitee.com/ebamboo/media/raw/master/BBPictureBrowser/jpeg/05.jpeg"]
];

BBPictureBrowser *browser = [BBPictureBrowser new];
browser.bb_pictureList = pictureList;
[browser bb_showOnView:self.view.window atIndex:0];
```
#### 自定义 UI
#### 动画效果
# License
BBPictureBrowser is distributed under the MIT license. See LICENSE file for details.
