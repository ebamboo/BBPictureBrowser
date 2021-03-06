//
//  RootViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/2.
//

#import "RootViewController.h"
#import "BBPictureBrowser.h"
#import "CustomUIViewController.h"
#import "CustomAutoUIViewController.h"
#import "AnimationViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray <NSString *> *sectionTitleList;
@property (nonatomic, retain) NSArray <NSArray <NSString *> *> *dataSource;

@end

@implementation RootViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"BBPictureBrowser";
    _sectionTitleList = @[@"简单使用", @"自定义 UI", @"动画效果"];
    _dataSource = @[
        @[@"展示本地图片", @"展示网络图片", @"展示本地图片+网络图片"],
        @[@"自定义视图", @"自定义高度自适应视图"],
        @[@"动画效果"]
    ];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitleList[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 简单使用
    if (indexPath.section == 0) {
        // --- 本地图片
        if (indexPath.row == 0) {
            NSArray *pictureList = @[
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"little"] webImage:nil],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"02"] webImage:nil],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"03"] webImage:nil],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"04"] webImage:nil],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"05"] webImage:nil]
            ];
            BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:nil animateFromView:nil];
            [browser bb_openOnView:self.view.window atIndex:0];
            return;
        }
        // --- 网络图片
        if (indexPath.row == 1) {
            NSArray *pictureList = @[
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/01.jpeg"],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/02.gif"],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/03.jpeg"],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/04.gif"],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/05.jpeg"]
            ];
            BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:nil animateFromView:nil];
            [browser bb_openOnView:self.view.window atIndex:2];
            return;
        }
        // --- 本地图片+网络图片
        if (indexPath.row == 2) {
            NSArray *pictureList = @[
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/01.gif"],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"10"] webImage:nil],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/gif/03.gif"],
                [BBPictureModel modelWithLocalImage:[UIImage imageNamed:@"11"] webImage:nil],
                [BBPictureModel modelWithLocalImage:nil webImage:@"https://gitee.com/ebamboo/Assets/raw/master/BBPictureBrowser/jpeg/05.jpeg"]
            ];
            BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:nil animateFromView:nil];
            [browser bb_openOnView:self.view.window atIndex:0];
            return;
        }
    }
    // 自定义 UI
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[CustomUIViewController new] animated:YES];
            return;
        }
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[CustomAutoUIViewController new] animated:YES];
            return;
        }
    }
    // 动画效果
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:[AnimationViewController new] animated:YES];
    }
}

@end
