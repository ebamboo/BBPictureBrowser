//
//  BBPictureBrowser.h
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/3/29.
//
//  https://github.com/ebamboo/BBPictureBrowser
//

#import <UIKit/UIKit.h>

@interface BBPictureModel : NSObject

- (nonnull instancetype)initWithLocalImage:(nullable UIImage *)local webImage:(nullable NSString *)web;
+ (nonnull instancetype)modelWithLocalImage:(nullable UIImage *)local webImage:(nullable NSString *)web;

@property (nullable, nonatomic, readonly) UIImage *bb_local;
@property (nullable, nonatomic, readonly) NSString *bb_web;

/// 本地图片和网络图片都会试图获取一个压缩图片进行展示
/// 只有在成功获取到压缩图片之后，才会真正展示图片
/// 本地图片使用 Apple 提供的压缩算法获取压缩图片
/// 网络图片使用 SDWebImage 提供的压缩算法获取压缩图片
@property (nullable, nonatomic, readonly) UIImage *bb_localThumb;
@property (nullable, nonatomic, readonly) UIImage *bb_webThumb;

@end

@class BBPictureBrowser;
@protocol BBPictureBrowserDelegate <NSObject>
@optional
/// 图片浏览器关闭动画
/// return：图片浏览器关闭时，动画缩放到的视图
/// 若返回 nil 则没有关闭动画
- (nullable UIView *)bb_pictureBrowser:(nullable BBPictureBrowser *)browser animateToViewAtIndex:(NSInteger)index;

/// 自定义顶部工具栏
/// 高度返回 UITableViewAutomaticDimension 时，表示自适应高度（参考 UITableViewCell 自适应高度）
- (CGFloat)bb_pictureBrowserHeightForTopBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForTopBar:(nullable BBPictureBrowser *)browser;

/// 自定义底部工具栏
/// 高度返回 UITableViewAutomaticDimension 时，表示自适应高度（参考 UITableViewCell 自适应高度）
- (CGFloat)bb_pictureBrowserHeightForBottomBar:(nullable BBPictureBrowser *)browser;
- (nullable UIView *)bb_pictureBrowserViewForBottomBar:(nullable BBPictureBrowser *)browser;

/// 图片浏览器展示了下标为 index 的图片
/// 调用 -bb_openOnView:atIndex: 方法时，也会试图调用本方法
- (void)bb_pictureBrowser:(nullable BBPictureBrowser *)browser didShowPictureAtIndex:(NSInteger)index topBar:(nullable UIView *)topBar bottomBar:(nullable UIView *)bottomBar;

@end

/// !!! 注意 !!!
/// 本地图片使用 Apple 提供的压缩算法
/// 网络图片使用 SDWebImage 提供的压缩算法
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
