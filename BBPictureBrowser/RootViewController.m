//
//  RootViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/2.
//

#import "RootViewController.h"
#import "BBPictureBrowser.h"
#import "CustomUIViewController.h"
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
        @[@"自定义视图"],
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
        // ---本地图片
        if (indexPath.row == 0) {
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
            return;
        }
        // ---网络图片
        if (indexPath.row == 1) {
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
            return;
        }
        // ---本地图片+网络图片
        if (indexPath.row == 2) {
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
            return;
        }
    }
    
    // 自定义 UI
    if (indexPath.section == 1) {
        [self.navigationController pushViewController:[CustomUIViewController new] animated:YES];
    }
    
    // 动画效果
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:[AnimationViewController new] animated:YES];
    }
}

@end
