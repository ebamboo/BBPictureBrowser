//
//  RootViewController.m
//  BBPictureBrowser
//
//  Created by 征国科技 on 2021/7/2.
//

#import "RootViewController.h"

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
    _sectionTitleList = @[@"简单使用", @"自定义UI", @"动画效果"];
    _dataSource = @[
        @[@"展示本地图片", @"展示网络图片", @"展示本地图片+网络图片"],
        @[@"自定义视图"],
        @[@"展示时的动画效果", @"关闭时的动画效果", @"关闭时的动画效果---收缩到指定cell的子视图"]
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
}

@end
