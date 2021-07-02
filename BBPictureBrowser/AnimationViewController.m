//
//  AnimationViewController.m
//  BBPictureBrowser
//
//  Created by 征国科技 on 2021/7/2.
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
        BBPictureBrowserPictureModel *model = [BBPictureBrowserPictureModel new];
        model.bb_image = [UIImage imageNamed:name];
        [pictureList addObject:model];
    }
    
    BBPictureBrowser *browser = [BBPictureBrowser new];
    browser.bb_delegate = self;
    browser.bb_pictureList = pictureList;
    browser.bb_animateFromView = [collectionView cellForItemAtIndexPath:indexPath];
    [browser bb_showOnView:self.view.window atIndex:indexPath.item];
}

#pragma mark - collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat w = (screenW - 20) / 3;
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
    return nil;
}

@end
