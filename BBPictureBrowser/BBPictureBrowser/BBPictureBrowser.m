//
//  BBPictureBrowser.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/3/29.
//

#import "BBPictureBrowser.h"
#import <SDWebImage/SDWebImage.h>

#define     BBPictureBrowserBackgroundColor         [UIColor blackColor]
#define     BBPictureBrowserFailureImageName        @"__bb_picture_browser_error__"

#pragma mark - =======================================
#pragma mark -

@interface BBPictureModel ()

@property (nonatomic, retain) UIImage *localImage;
@property (nonatomic, copy) NSString *webImage;

@property (nonatomic, retain) UIImage *localThumb;
@property (nonatomic, retain) UIImage *webThumb;

@end

@implementation BBPictureModel

#pragma mark - public method

- (nonnull instancetype)initWithLocalImage:(nullable UIImage *)local webImage:(nullable NSString *)web {
    self = [super init];
    if (self) {
        _localImage = local;
        _webImage = web;
        [self downsampleLocalImage];
    }
    return self;
}

+ (nonnull instancetype)modelWithLocalImage:(nullable UIImage *)local webImage:(nullable NSString *)web {
    return [[BBPictureModel alloc] initWithLocalImage:local webImage:web];
}

- (UIImage *)bb_local {
    return _localImage;
}

- (NSString *)bb_web {
    return _webImage;
}

- (UIImage *)bb_localThumb {
    return _localThumb;
}

- (UIImage *)bb_webThumb {
    return _webThumb;
}

#pragma mark - private method

// 采样 thumb 任务队列
static NSOperationQueue *downsampleQueue;
+ (void)load {
    downsampleQueue = [NSOperationQueue new];
}

// 模型初始化时试图采样获取 thumb
- (void)downsampleLocalImage {
    if (_localImage) {
        CGFloat maxImagePixelSide = MAX(_localImage.size.width, _localImage.size.height) * _localImage.scale;
        CGFloat maxScreenPixelSide = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) * UIScreen.mainScreen.scale;
        if (maxImagePixelSide > maxScreenPixelSide) {
            __weak typeof(self) weakSelf = self;
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                weakSelf.localThumb = [weakSelf downsampleFor:weakSelf.localImage];
            }];
            [downsampleQueue addOperation:operation];
        } else {
            _localThumb = _localImage;
        }
    }
}

// 采样 thumb 过程（Apple 提供的压缩算法）
- (UIImage *)downsampleFor:(UIImage *)image {
    // 创建 CGImageSourceRef  注意：image 不能为空进而导致 imageSource 为空
    NSData *data = UIImagePNGRepresentation(image);
    NSDictionary *imageSourceOptions = @{ (__bridge id)kCGImageSourceShouldCache: @NO };
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, (__bridge CFDictionaryRef)imageSourceOptions);
    // 配置 downsampleOptions
    CGFloat side = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    CGFloat maxDimensionInPixels = side * UIScreen.mainScreen.scale;
    NSDictionary *downsampleOptions = @{
        (__bridge id)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
        (__bridge id)kCGImageSourceShouldCacheImmediately: @YES,
        (__bridge id)kCGImageSourceCreateThumbnailWithTransform: @YES,
        (__bridge id)kCGImageSourceThumbnailMaxPixelSize: @(maxDimensionInPixels)
    };
    // 采样取得 image
    CGImageRef tempImageRef = CGImageSourceCreateThumbnailAtIndex(imageSourceRef, 0, (__bridge CFDictionaryRef)downsampleOptions);
    UIImage *tempImage = [UIImage imageWithCGImage:tempImageRef];
    CGImageRelease(tempImageRef);
    CFRelease(imageSourceRef);
    return tempImage;
}

@end

#pragma mark - =======================================
#pragma mark -

@interface BBPictureBrowserCell : UICollectionViewCell <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) BBPictureModel *picture;
@property (nonatomic, assign) NSInteger cellStatus; //  0 - 加载图片成功；1 - 加载图片中；2 - 加载图片失败；
@property (nonatomic, copy) NSValue *lastBounds; // 记录最新的 bounds，如若变化则刷新布局

@property (nonatomic, copy) void (^singleActionHandler)(UITapGestureRecognizer *singleTap);
@property (nonatomic, copy) void (^panActionHandler)(UIPanGestureRecognizer *pan);


@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UIView *infoView;
@property (nonatomic, retain) UIActivityIndicatorView *loadingView;
@property (nonatomic, retain) UIImageView *failureView;

@end

@implementation BBPictureBrowserCell

#pragma mark - public method

- (void)setPicture:(BBPictureModel *)picture {
    _picture = picture;
    //  0 - 加载图片成功；1 - 加载图片中；2 - 加载图片失败；
    [self setCellStatus:1];
    
    if (picture.localThumb) {
        [self setCellStatus:0];
        _imageView.image = picture.localThumb;
        [self resetScrollView];
        return;
    }
    
    if (picture.localImage) {
        picture.localThumb = [picture downsampleFor:picture.localImage];
        [self setCellStatus:0];
        _imageView.image = picture.localThumb;
        [self resetScrollView];
        return;
    }
    
    if (picture.webImage) {
        CGFloat maxScreenPixelSide = MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) * UIScreen.mainScreen.scale;
        CGSize maxPixelSize = CGSizeMake(maxScreenPixelSide, maxScreenPixelSide);
        __weak typeof(self) weakSelf = self;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:picture.webImage]
                      placeholderImage:nil
                               options:SDWebImageAvoidAutoSetImage
                               context:@{SDWebImageContextImageThumbnailPixelSize: @(maxPixelSize)}
                              progress:nil
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                picture.webThumb = image;
                [weakSelf setCellStatus:0];
                weakSelf.imageView.image = image;
                [weakSelf resetScrollView];
            } else {
                [weakSelf setCellStatus:2];
            }
        }];
        return;
    }
}

- (void)setCellStatus:(NSInteger)cellStatus {
    _cellStatus = cellStatus;
    //  0 - 加载图片成功；1 - 加载图片中；2 - 加载图片失败；
    if (cellStatus == 0) {
        _infoView.hidden = YES;
        return;
    } else {
        _infoView.hidden = NO;
        if (cellStatus == 1) {
            [_loadingView startAnimating];
            _failureView.hidden = YES;
            return;
        }
        if (cellStatus == 2) {
            [_loadingView stopAnimating];
            _failureView.hidden = NO;
            return;
        }
    }
}

#pragma mark - life circle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // =================== 图片展示 ======================
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.backgroundColor = BBPictureBrowserBackgroundColor;
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.contentView addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_imageView];
        
        // =================== 提示信息 ======================
        
        _infoView = [[UIView alloc] init];
        _infoView.backgroundColor = BBPictureBrowserBackgroundColor;
        [self.contentView addSubview:_infoView];
        
        _loadingView = [[UIActivityIndicatorView alloc] init];
        _loadingView.frame = CGRectMake(0, 0, 60, 60);
        if (@available(iOS 13.0, *)) {
            _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        } else {
            _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        }
        _loadingView.hidesWhenStopped = YES;
        _loadingView.color = [UIColor whiteColor];
        [_infoView addSubview:_loadingView];
        
        _failureView = [[UIImageView alloc] init];
        _failureView.contentMode = UIViewContentModeScaleAspectFit;
        _failureView.tintColor = [UIColor whiteColor];
        _failureView.bounds = CGRectMake(0, 0, 37, 37);
        _failureView.image = [[UIImage imageNamed:BBPictureBrowserFailureImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_infoView addSubview:_failureView];
        
        // =================== 添加手势 ======================
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleAction:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 2;
        pan.delegate = self;
        [_imageView addGestureRecognizer:pan];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [singleTap requireGestureRecognizerToFail:pan];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (![_lastBounds isEqualToValue:@(self.bounds)]) {
        // record bounds
        _lastBounds = @(self.bounds);
        // setup scroll view
        _scrollView.frame = self.bounds;
        [self resetScrollView];
        // setup info view
        _infoView.frame = self.bounds;
        _loadingView.center = _infoView.center;
        _failureView.center = _infoView.center;
    }
}

#pragma mark - 手势事件

- (void)singleAction:(UITapGestureRecognizer *)singleTap {
    _singleActionHandler(singleTap);
}

- (void)doubleAction:(UITapGestureRecognizer *)doubleTap {
    if (_scrollView.zoomScale != _scrollView.maximumZoomScale) {
        [_scrollView setZoomScale:_scrollView.maximumZoomScale animated:YES];
    } else {
        [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:YES];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    _panActionHandler(pan);
}

#pragma mark - UIGestureRecognizerDelegate

// pan 手势和 scroll view 滑动冲突处理
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (_scrollView.zoomScale == _scrollView.minimumZoomScale) {
            CGPoint offset = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:_scrollView];
            // 若果纵向滑动，则响应 pan 手势，否则不响应 pan 手势
            return fabs(offset.y) > fabs(offset.x);
        } else {
            return NO;
        }
    }
    return YES;
}

#pragma mark - scrollView

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 设置 image view 位置
    // 当内容大于 bounds 时，居于内容中心，当内容小于 bounds 时，居于 bounds 中心
    CGFloat centerX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? scrollView.bounds.size.width / 2 : scrollView.contentSize.width / 2;
    CGFloat centerY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? scrollView.bounds.size.height / 2 : scrollView.contentSize.height / 2;
    _imageView.center = CGPointMake(centerX, centerY);
}

#pragma mark - private method

// 使 scroll view 恢复初始状态并设置该状态下
// scroll view 的 content size 和 image view 的 frame
- (void)resetScrollView {
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:NO];
    CGSize size = _imageView.image.size;
    if (size.width > self.bounds.size.width || size.height > self.bounds.size.height) {
        CGSize imageSize = _imageView.image.size;
        CGSize usaleSize = self.bounds.size;
        if (imageSize.height * usaleSize.width / imageSize.width > usaleSize.height) { // 图片高比较 "大"
            size = CGSizeMake(imageSize.width * usaleSize.height / imageSize.height, usaleSize.height);
        } else { // 图片宽比较 "大"
            size = CGSizeMake(usaleSize.width, imageSize.height * usaleSize.width / imageSize.width);
        }
    }
    _scrollView.contentSize = size;
    _imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    _imageView.center = _scrollView.center;
}

@end

#pragma mark - =======================================
#pragma mark -

@interface BBPictureBrowser () <UICollectionViewDataSource, UICollectionViewDelegate>

// store property
@property (nonatomic, retain) NSArray <BBPictureModel *> *pictureList;
@property (nonatomic, weak) id <BBPictureBrowserDelegate> delegate;
@property (nonatomic, weak) UIView *animateFromView;
@property (nonatomic, assign) NSInteger currentIndex;

// UICollectionView
@property (nonatomic, retain) UICollectionView *collectionView;

// 工具栏，由开发者通过协议提供
@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, retain) UIView *topBar;
@property (nonatomic, assign) CGFloat bottomBarHeight;
@property (nonatomic, retain) UIView *bottomBar;

@end

@implementation BBPictureBrowser

#pragma mark - public method

- (void)bb_openOnView:(nonnull UIView *)onView atIndex:(NSInteger)index {
    // 数据安全检查配置
    if (_pictureList.count == 0) {
        return;
    }
    _currentIndex = index;
    if (index < 0) {
        _currentIndex = 0;
    }
    if (index > _pictureList.count - 1) {
        _currentIndex = _pictureList.count - 1;
    }
    // 添加 UI 并刷新布局
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowserHeightForTopBar:)]) {
        _topBarHeight = [_delegate bb_pictureBrowserHeightForTopBar:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowserViewForTopBar:)]) {
        _topBar = [_delegate bb_pictureBrowserViewForTopBar:self];
    }
    if (_topBar) {
        [self addSubview:_topBar];
        _topBar.translatesAutoresizingMaskIntoConstraints = NO;
        [[_topBar.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor] setActive:YES];
        [[_topBar.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor] setActive:YES];
        [[_topBar.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor] setActive:YES];
        if (_topBarHeight == UITableViewAutomaticDimension) {} else {
            [[_topBar.heightAnchor constraintEqualToConstant:_topBarHeight] setActive:YES];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowserHeightForBottomBar:)]) {
        _bottomBarHeight = [_delegate bb_pictureBrowserHeightForBottomBar:self];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowserViewForBottomBar:)]) {
        _bottomBar = [_delegate bb_pictureBrowserViewForBottomBar:self];
    }
    if (_bottomBar) {
        [self addSubview:_bottomBar];
        _bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
        [[_bottomBar.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor] setActive:YES];
        [[_bottomBar.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor] setActive:YES];
        [[_bottomBar.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor] setActive:YES];
        if (_bottomBarHeight == UITableViewAutomaticDimension) {} else {
            [[_bottomBar.heightAnchor constraintEqualToConstant:_bottomBarHeight] setActive:YES];
        }
    }
    [onView addSubview:self];
    [self layoutIfNeeded];
    // 显示动画
    UIImage *animateImage = _pictureList[_currentIndex].localImage;
    if (!animateImage) {
        animateImage = [SDImageCache.sharedImageCache imageFromCacheForKey:_pictureList[_currentIndex].webImage];
    }
    self.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:0.0];
    _collectionView.hidden = YES;
    _topBar.hidden = YES;
    _bottomBar.hidden = YES;
    if (_animateFromView && animateImage) {
        UIImageView *animationView = [[UIImageView alloc] init];
        animationView.clipsToBounds = YES;
        animationView.contentMode = UIViewContentModeScaleAspectFill;
        animationView.frame = [_animateFromView convertRect:_animateFromView.bounds toView:self];
        animationView.image = animateImage;
        [self addSubview:animationView];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            animationView.frame = [weakSelf frameForShowAnimationViewAtEndWithImage:animateImage];
            self.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:1.0];
        } completion:^(BOOL finished) {
            weakSelf.collectionView.hidden = NO;
            weakSelf.topBar.hidden = NO;
            weakSelf.bottomBar.hidden = NO;
            [animationView removeFromSuperview];
        }];
    } else {
        self.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:1.0];
        _collectionView.hidden = NO;
        _topBar.hidden = NO;
        _bottomBar.hidden = NO;
    }
    // 展示了下标为 index 的图片回调
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowser:didShowPictureAtIndex:topBar:bottomBar:)]) {
        [_delegate bb_pictureBrowser:self didShowPictureAtIndex:_currentIndex topBar:_topBar bottomBar:_bottomBar];
    }
}

- (void)bb_close {
    BBPictureBrowserCell *cell = (BBPictureBrowserCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]];
    if (cell.singleActionHandler) {
        cell.singleActionHandler(nil);
    }
}

- (NSInteger)bb_currentIndex {
    return _currentIndex;
}

- (NSArray<BBPictureModel *> *)bb_pictureList {
    return _pictureList;
}

#pragma mark - life circle

- (nonnull instancetype)initWithPictures:(nonnull NSArray<BBPictureModel *> *)pictures
                                delegate:(nullable id<BBPictureBrowserDelegate>)delegate
                         animateFromView:(nullable UIView *)view {
    self = [super init];
    if (self) {
        _pictureList = [pictures copy];
        _delegate = delegate;
        _animateFromView = view;
    }
    return self;
}

+ (nonnull instancetype)browserWithPictures:(nonnull NSArray<BBPictureModel *> *)pictures
                                   delegate:(nullable id<BBPictureBrowserDelegate>)delegate
                            animateFromView:(nullable UIView *)view {
    return [[BBPictureBrowser alloc] initWithPictures:pictures delegate:delegate animateFromView:view];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsSelection = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = BBPictureBrowserBackgroundColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_collectionView registerClass:[BBPictureBrowserCell class] forCellWithReuseIdentifier:@"BBPictureBrowserCell"];
        [self insertSubview:_collectionView atIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // self
    self.frame = self.superview.bounds;
    // collection view
    CGRect collectionFrame = self.bounds;
    collectionFrame.size.width += 10;
    _collectionView.frame = collectionFrame;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    flowLayout.itemSize = self.bounds.size;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _pictureList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BBPictureBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BBPictureBrowserCell" forIndexPath:indexPath];
    [cell setPicture:_pictureList[indexPath.item]];
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    cell.singleActionHandler = ^(UITapGestureRecognizer *singleTap) {
        UIView *toView = nil;
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bb_pictureBrowser:animateToViewAtIndex:)]) {
            toView = [weakSelf.delegate bb_pictureBrowser:weakSelf animateToViewAtIndex:indexPath.item];
        }
        if (toView && weakCell.imageView.image) {
            weakSelf.collectionView.hidden = YES;
            weakSelf.topBar.hidden = YES;
            weakSelf.bottomBar.hidden = YES;
            UIImageView *animationView = [[UIImageView alloc] init];
            animationView.clipsToBounds = YES;
            animationView.contentMode = UIViewContentModeScaleAspectFill;
            animationView.frame = [weakCell.imageView convertRect:weakCell.imageView.bounds toView:self];
            animationView.image = weakCell.imageView.image;
            [weakSelf addSubview:animationView];
            [UIView animateWithDuration:0.3 animations:^{
                animationView.frame = [toView convertRect:toView.bounds toView:weakSelf];
                weakSelf.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:0.0];
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.alpha = 0.0;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
            }];
        }
    };
    __block UIImageView *animationView = nil;
    __block CGSize animationViewOriginSize = CGSizeZero;
    __block UIView *toView = nil;
    cell.panActionHandler = ^(UIPanGestureRecognizer *pan) { // cell 中已经保证 pan 手势发生的条件：图片有图且非缩放状态下
        if (pan.state == UIGestureRecognizerStateBegan) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bb_pictureBrowser:animateToViewAtIndex:)]) {
                toView = [weakSelf.delegate bb_pictureBrowser:weakSelf animateToViewAtIndex:indexPath.item];
            }
            weakSelf.collectionView.hidden = YES;
            weakSelf.topBar.hidden = YES;
            weakSelf.bottomBar.hidden = YES;
            animationView = [[UIImageView alloc] init];
            animationView.clipsToBounds = YES;
            animationView.contentMode = UIViewContentModeScaleAspectFill;
            animationView.frame = [weakCell.imageView convertRect:weakCell.imageView.bounds toView:weakSelf];
            animationView.image = weakCell.imageView.image;
            animationViewOriginSize = animationView.frame.size;
            [weakSelf addSubview:animationView];
            // 设置 animationView 锚点位于手势位置
            CGPoint panLacationInAnimationView = [pan locationInView:animationView];
            animationView.layer.anchorPoint = CGPointMake(panLacationInAnimationView.x / animationView.bounds.size.width, panLacationInAnimationView.y / animationView.bounds.size.height);
            animationView.center = [pan locationInView:animationView.superview];
        } else if (pan.state == UIGestureRecognizerStateChanged) {
            CGPoint offset = [pan translationInView:weakSelf];
            // 设置当前位置相对原位置的缩放比例
            CGFloat scale = 1 - fabs(offset.y) / weakSelf.bounds.size.height;
            if (scale < 0.2) {
                scale = 0.2;
            }
            animationView.bounds = CGRectMake(0, 0, animationViewOriginSize.width * scale, animationViewOriginSize.height * scale);
            animationView.center = [pan locationInView:animationView.superview];
            weakSelf.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:scale];
        } else if (   pan.state == UIGestureRecognizerStateCancelled
                   || pan.state == UIGestureRecognizerStateEnded
                   || pan.state == UIGestureRecognizerStateRecognized
                   || pan.state == UIGestureRecognizerStateFailed) {
            CGPoint offset = [pan translationInView:weakSelf];
            if (fabs(offset.y) > 200) { // 拖动足够大的距离，那么就关闭图片浏览器
                if (toView) {
                    [UIView animateWithDuration:0.3 animations:^{
                        animationView.frame = [toView convertRect:toView.bounds toView:weakSelf];
                        weakSelf.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:0.0];
                    } completion:^(BOOL finished) {
                        [weakSelf removeFromSuperview];
                    }];
                } else {
                    [weakSelf removeFromSuperview];
                }
            } else { // 拖动距离太小，恢复原状态
                [animationView removeFromSuperview];
                animationView = nil;
                animationViewOriginSize = CGSizeZero;
                toView = nil;
                weakSelf.backgroundColor = [BBPictureBrowserBackgroundColor colorWithAlphaComponent:1.0];
                weakSelf.collectionView.hidden = NO;
                weakSelf.topBar.hidden = NO;
                weakSelf.bottomBar.hidden = NO;
            }
        }
    };
    return cell;
}

#pragma mark - scroll view

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat indexF = scrollView.contentOffset.x / scrollView.bounds.size.width;
        _currentIndex = (NSUInteger)(indexF + 0.5);
        if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowser:didShowPictureAtIndex:topBar:bottomBar:)]) {
            [_delegate bb_pictureBrowser:self didShowPictureAtIndex:_currentIndex topBar:_topBar bottomBar:_bottomBar];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat indexF = scrollView.contentOffset.x / scrollView.bounds.size.width;
    _currentIndex = (NSUInteger)(indexF + 0.5);
    if (_delegate && [_delegate respondsToSelector:@selector(bb_pictureBrowser:didShowPictureAtIndex:topBar:bottomBar:)]) {
        [_delegate bb_pictureBrowser:self didShowPictureAtIndex:_currentIndex topBar:_topBar bottomBar:_bottomBar];
    }
}

#pragma mark - private method

// 显示动画结束时，动画视图的 frame
- (CGRect)frameForShowAnimationViewAtEndWithImage:(UIImage *)image {
    CGSize size = image.size;
    if (size.width > self.bounds.size.width || size.height > self.bounds.size.height) {
        CGSize imageSize = image.size;
        CGSize usaleSize = self.bounds.size;
        if (imageSize.height * usaleSize.width / imageSize.width > usaleSize.height) { // 图片高比较 "大"
            size = CGSizeMake(imageSize.width * usaleSize.height / imageSize.height, usaleSize.height);
        } else { // 图片宽比较 "大"
            size = CGSizeMake(usaleSize.width, imageSize.height * usaleSize.width / imageSize.width);
        }
    }
    return CGRectMake(
                      (self.bounds.size.width - size.width) / 2,
                      (self.bounds.size.height - size.height) / 2,
                      size.width,
                      size.height
                      );
}

@end
