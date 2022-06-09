//
//  CustomAutoUIViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2022/6/9.
//

#import "CustomAutoUIViewController.h"
#import "BBPictureBrowser.h"
#import "TestBottomToolsView.h"

@interface CustomAutoUIViewController () <BBPictureBrowserDelegate>

@property (nonatomic, retain) NSArray <NSString *> *nameList;

@end

@implementation CustomAutoUIViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工具栏高度自适应";
    _nameList = @[@"01", @"02", @"03", @"04", @"05",
                  @"06", @"07", @"08", @"09", @"10",
                  @"11", @"12", @"13", @"14", @"15"];
}

- (IBAction)showPictureAction:(id)sender {
    NSMutableArray *pictureList = [NSMutableArray array];
    for (NSString *name in _nameList) {
        BBPictureModel *model = [BBPictureModel modelWithLocalImage:[UIImage imageNamed:name] webImage:nil];
        [pictureList addObject:model];
    }
    BBPictureBrowser *browser = [BBPictureBrowser browserWithPictures:pictureList delegate:self animateFromView:nil];
    [browser bb_openOnView:self.view.window atIndex:0];
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

- (CGFloat)bb_pictureBrowserHeightForBottomBar:(BBPictureBrowser *)browser {
    return UITableViewAutomaticDimension;
}

- (UIView *)bb_pictureBrowserViewForBottomBar:(BBPictureBrowser *)browser {
    TestBottomToolsView *bottomBar = [TestBottomToolsView new];
    return bottomBar;
}

- (void)bb_pictureBrowser:(BBPictureBrowser *)browser didShowPictureAtIndex:(NSInteger)index topBar:(UIView *)topBar bottomBar:(TestBottomToolsView *)bottomBar {
    bottomBar.titleLabel.text = [NSString stringWithFormat:@"正在展示第%@张图片", @(index+1)];
    bottomBar.descriptionLabel.text = ^{
        NSString *tempStr = @"";
        NSInteger count = arc4random() % 200;
        for (NSInteger i = 0; i < count; i++) {
            tempStr = [tempStr stringByAppendingString:@"正"];
        }
        return tempStr;
    }();
}

@end
