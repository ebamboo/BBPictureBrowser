//
//  BBPictureBrowser.h
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/3/29.
//
//  https://github.com/ebamboo/BBPictureBrowser
//

#import <UIKit/UIKit.h>

@interface BBPictureBrowserPictureModel : NSObject

+ (nonnull instancetype)bb_modelWithImage:(nullable UIImage *)image webImage:(nullable NSString *)url;

@property (nonatomic, retain, readonly, nullable) UIImage *bb_image;
@property (nonatomic, copy, readonly, nullable) NSString *bb_webImageUrl;
// 无论以 image 还是 URL 方式提供图片，最终都会回去以缩略图进行展示
@property (nonatomic, retain, readonly, nullable) UIImage *bb_thumb;

@end

@class BBPictureBrowser;
@protocol BBPictureBrowserDelegate <NSObject>
@optional

/**
 图片浏览器关闭时，动画缩放到的视图。如果不实现则没有关闭动画
 */
- (nullable UIView *)bb_pictureBrowser:(nullable BBPictureBrowser *)browser animateToViewAtIndex:(NSInteger)index;

/**
 自定义顶部工具栏
 */
- (CGFloat)bb_pictureBrowserHeightForTopBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForTopBar:(nullable BBPictureBrowser *)browser;

/**
 自定义底部工具栏
 */
- (CGFloat)bb_pictureBrowserHeightForBottomBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForBottomBar:(nullable BBPictureBrowser *)browser;

/**
 图片浏览器展示了下标为 index 的图片
 */
- (void)bb_pictureBrowser:(nullable BBPictureBrowser *)browser didShowPictureAtIndex:(NSInteger)index topBar:(nullable UIView *)topBar bottomBar:(nullable UIView *)bottomBar;

@end

@interface BBPictureBrowser : UIView

// 传入需要展示的图片
// 设置代理可以监听和相应事件以及自定义 UI 和动画
// 显示动画开始位置视图
+ (nonnull instancetype)bb_browserWithPictures:(nonnull NSArray<BBPictureBrowserPictureModel *> *)pictures
                                      delegate:(nullable id<BBPictureBrowserDelegate>)delegate
                               animateFromView:(nullable UIView *)view;

- (void)bb_showOnView:(nonnull UIView *)onView atIndex:(NSInteger)index;
- (void)bb_close;

@property (nonatomic, assign, readonly) NSInteger bb_currentIndex;
@property (nonatomic, retain, readonly, nonnull) NSArray <BBPictureBrowserPictureModel *> *bb_pictureList;

@end
