//
//  YMTestView.h
//  YMReactiveCocoaDemo
//
//  Created by Max on 2019/3/18.
//  Copyright © 2019年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMTestView : UIView
@property (nonatomic,   copy) NSString *name;
- (void)changeName:(NSString *)newName;
- (void)buttonClick:(UIButton *)sender;
- (void)testRacDelegate:(NSString *)string number:(NSNumber *)number;
@end

NS_ASSUME_NONNULL_END
