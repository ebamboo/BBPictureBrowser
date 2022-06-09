//
//  TestBottomToolsView.m
//  BBPictureBrowser
//
//  Created by ebamboo on 2022/6/9.
//

#import "TestBottomToolsView.h"

@interface TestBottomToolsView ()

@property (strong, nonatomic) IBOutlet UIView *selfView;

@end

@implementation TestBottomToolsView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"TestBottomToolsView" owner:self options:nil];
    [self addSubview:_selfView];
}

- (void)layoutSubviews {
    _selfView.frame = self.bounds;
}

@end
