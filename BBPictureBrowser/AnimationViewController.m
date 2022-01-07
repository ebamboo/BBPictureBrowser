//
//  AnimationViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/2.
//

#import "AnimationViewController.h"
#import "BBPictureBrowser.h"
#import "PictrueCollectionViewCell.h"

@interface AnimationViewController () <BBPictureBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSArray <NSString *> *nameList;

@end

@implementation AnimationViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动画效果";
    [_collectionView registerNib:[UINib nibWithNibName:@"PictrueCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PictrueCollectionViewCell"];
    _nameList = @[@"01", @"02", @"03", @"04", @"05",
                  @"06", @"07", @"08", @"09", @"10",
                  @"11", @"12", @"13", @"14", @"15",
                  @"16", @"17", @"18", @"19", @"20"
    ];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_collectionView reloadData];
}
#pragma mark - collection view 基础

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _nameList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictrueCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictrueCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_nameList[indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSMutableArray *pictureList = [NSMutableArray array];
    for (NSString *name in _nameList) {
        BBPictureModel *model = [BBPictureModel modelWithLocalImage:[UIImage imageNamed:name] webImage:nil];
        [pictureList addObject:model];
    }
    
    BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:self animateFromView:[collectionView cellForItemAtIndexPath:indexPath]];
    [browser bb_openOnView:self.view.window atIndex:indexPath.item];
}

#pragma mark - collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.bounds.size.width;
    CGFloat w = (width - 20) / 3;
    return CGSizeMake(w, w);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}

#pragma mark - BBPictureBrowserDelegate

- (nullable UIView *)bb_pictureBrowser:(nullable BBPictureBrowser *)browser animateToViewAtIndex:(NSInteger)index {
    // 设置返回动画
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    NSArray <NSIndexPath *> *indexPathList = [_collectionView indexPathsForVisibleItems];
    BOOL flag = NO; // 判断下标为 index 的图片是否正在展示
    for (NSIndexPath *item in indexPathList) {
        if (item.item == index) {
            flag = YES;
            break;
        }
    }
    if (flag) {
        return [_collectionView cellForItemAtIndexPath:indexPath];
    } else {
        ///
        /// 下标为 index 的图片不在列表展示时，有两种方案选择
        //
        
        // 方案一、返回 nil，没有动画效果
        return nil;
        // 方案二、滑动 collection view，使相应的 cell 居中展示，返回 cell，然后在进行关闭动画
//        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
//        return [_collectionView cellForItemAtIndexPath:indexPath];
        
    }
}

@end
