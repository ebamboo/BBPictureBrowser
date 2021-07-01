//
//  BBPictureBrowser.h
//  BBCommonKits
//
//  Created by 征国科技 on 2021/3/29.
//

#import <UIKit/UIKit.h>

@interface BBPictureBrowserPictureModel : NSObject
@property (nonatomic, retain, nullable) UIImage *bb_image;
@property (nonatomic, copy, nullable) NSString *bb_webImageUrl;
@end

@protocol BBPictureBrowserDelegate <NSObject>
@optional

/**
 图片浏览器关闭时动画缩放到的视图
 如果不实现则没有关闭动画
 */
- (nullable UIView *)bb_pictureBrowserAnimateToViewAtIndex:(NSInteger)index;

/**
 自定义顶部工具栏
 */
- (CGFloat)bb_pictureBrowserHeightForTopBar;
- (nullable UIView *)bb_pictureBrowserViewForTopBar;

/**
 自定义底部工具栏
 */
- (CGFloat)bb_pictureBrowserHeightForBottomBar;
- (nullable UIView *)bb_pictureBrowserViewForBottomBar;

/**
 图片浏览器展示了下标为 index 的图片
 */
- (void)bb_pictureBrowserDidShowPictureAtIndex:(NSInteger)index;

@end

@interface BBPictureBrowser : UIView

@property (nonatomic, weak, nullable) id <BBPictureBrowserDelegate> bb_delegate;
@property (nonatomic, retain, nonnull) NSArray <BBPictureBrowserPictureModel *> *bb_pictureList;
@property (nonatomic, weak, nullable) UIView *bb_animateFromView;

- (void)bb_show;
- (void)bb_showAtIndex:(NSInteger)index;
- (void)bb_showOnView:(nullable UIView *)onView;
- (void)bb_showOnView:(nullable UIView *)onView atIndex:(NSInteger)index;

@end
