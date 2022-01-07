//
//  CustomUIViewController.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2021/7/2.
//

#import "CustomUIViewController.h"
#import "BBPictureBrowser.h"

@interface CustomUIViewController () <BBPictureBrowserDelegate>

@property (nonatomic, retain) NSArray <NSString *> *nameList;

@end

@implementation CustomUIViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义 UI";
    _nameList = @[@"01", @"02", @"03", @"04", @"05",
                  @"06", @"07", @"08", @"09", @"10",
                  @"11", @"12", @"13", @"14", @"15"];
}

- (IBAction)showPictures:(id)sender {
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
