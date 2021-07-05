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
@property (nonatomic, retain, nullable) UIImage *bb_image;
@property (nonatomic, copy, nullable) NSString *bb_webImageUrl;

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

@property (nonatomic, weak, nullable) id <BBPictureBrowserDelegate> bb_delegate;
@property (nonatomic, retain, nonnull) NSArray <BBPictureBrowserPictureModel *> *bb_pictureList; // 数据源
@property (nonatomic, weak, nullable) UIView *bb_animateFromView; // 展示动画开始时的视图

- (void)bb_showOnView:(nullable UIView *)onView atIndex:(NSInteger)index;
- (NSInteger)bb_currentIndex;
- (void)bb_close;

@end
