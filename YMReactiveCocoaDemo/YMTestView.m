//
//  YMTestView.m
//  YMReactiveCocoaDemo
//
//  Created by Max on 2019/3/18.
//  Copyright © 2019年 Max. All rights reserved.
//

#import "YMTestView.h"

@interface YMTestView ()
@property (nonatomic, strong) UIButton *button;

@end

@implementation YMTestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"按钮" forState:UIControlStateNormal];
        [self.button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [self addSubview:self.button];
        self.button.frame = CGRectMake(10, 15, 60, 50);
        [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)changeName:(NSString *)newName {
    _name = newName;
}
- (void)buttonClick:(UIButton *)sender {
    NSLog(@"TestView中button点击了");
    [self testRacDelegate:@"这是个参数" number:@1];
}
- (void)testRacDelegate:(NSString *)string number:(NSNumber *)number {
    NSLog(@"testRacDelegate调用了");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
