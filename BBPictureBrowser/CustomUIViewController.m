//
//  CustomUIViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/2.
//

#import "CustomUIViewController.h"
#import "BBPictureBrowser.h"
#import "PictrueCollectionViewCell.h"

@interface CustomUIViewController () <BBPictureBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSArray <NSString *> *nameList;

@end

@implementation CustomUIViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义 UI";
    [_collectionView registerNib:[UINib nibWithNibName:@"PictrueCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PictrueCollectionViewCell"];
    _nameList = @[@"01", @"02", @"03", @"04", @"05",
                  @"06", @"07", @"08", @"09", @"10",
                  @"11", @"12", @"13", @"14", @"15"];
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

- (CGFloat)bb_pictureBrowserHeightForTopBar:(nullable BBPictureBrowser *)browser {
    return 44.0;
}

- (nullable UIView *)bb_pictureBrowserViewForTopBar:(nullable BBPictureBrowser *)browser {
    UIView *topBar = [UIView new];
    topBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 0, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    if (@available(iOS 14.0, *)) {
        [btn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            [browser bb_close];
        }] forControlEvents:UIControlEventTouchUpInside];
    } else {
        // Fallback on earlier versions
    }
    [topBar addSubview:btn];
    return topBar;
}

- (CGFloat)bb_pictureBrowserHeightForBottomBar:(nullable BBPictureBrowser *)browser {
    return 44.0;
}

- (nullable UIView *)bb_pictureBrowserViewForBottomBar:(nullable BBPictureBrowser *)browser {
    UIView *bottomBar = [UIView new];
    bottomBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    // 下标
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(15, 0, 60, 44);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"";
    label.tag = 100;
    [bottomBar addSubview:label];
    // 操作
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    btn.frame = CGRectMake(screenW - 60, 0, 44, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    if (@available(iOS 14.0, *)) {
        [btn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }] forControlEvents:UIControlEventTouchUpInside];
    } else {
        // Fallback on earlier versions
    }
    [bottomBar addSubview:btn];
    return bottomBar;
}

- (void)bb_pictureBrowser:(nullable BBPictureBrowser *)browser didShowPictureAtIndex:(NSInteger)index topBar:(nullable UIView *)topBar bottomBar:(nullable UIView *)bottomBar {
    UILabel *label = (UILabel *)[bottomBar viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%@ / %@", @(index + 1).stringValue, @(_nameList.count).stringValue];
}

@end
