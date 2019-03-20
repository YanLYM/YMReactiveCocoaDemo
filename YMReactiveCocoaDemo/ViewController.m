//
//  ViewController.m
//  YMReactiveCocoaDemo
//
//  Created by Max on 2019/3/15.
//  Copyright © 2019年 Max. All rights reserved.
//

#import "ViewController.h"
#import "YMTestView.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) YMTestView *testView;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic, strong) RACSignal *signal;

@end

@implementation ViewController
- (void)dealloc {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.yellowColor;
//    [self replaceDelegate];
    self.age = 25;
//    [self signalUse];
//    [self replaceTargetAction];
//    [self replaceKVO];
//    [self subject];
//    [self dependSeveralRequest];
//    [self ractupleUse];
//    [self KVO];
//    [self avoidCycleReference];
//    [self arrayTuple];
//    [self multicastConnection];
//    [self racObseve];
    [self observeTextFieldText];
}

- (void)event_buttonClick:(UIButton *)sender {
    NSLog(@"Button被点击了");
    _age = 33;
}
// RACSignal使用步骤：
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 - (void)sendNext:(id)value

- (void)signalUse{
    
    
    //三步骤:创建信号,订阅信号,发送信号
    
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //保存起来 就不会被取消订阅
//        _subscriber = subscriber;
        //3.发送信号
        [subscriber sendNext:@1];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
        
    }];
    
    //如果要取消就拿到 RACDisposable
    //2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    //取消订阅
    [disposable dispose];
}

/**
 替代代理
 */
- (void)replaceDelegate {
    self.testView = [[YMTestView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.testView];
    //testRacDelegate:number: 为YMTestView中定义方法，当调用该方法时将会执行以下回调,其中RACTuple * _Nullable x为一个元组，参数取决于testRacDelegate:number:方法传递的参数
    [[self.testView rac_signalForSelector:@selector(testRacDelegate:number:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSArray *allObjects = [x allObjects];
        NSLog(@"x : %@",allObjects);
    }];
}
/**
 事件监听
 */
- (void)replaceTargetAction {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setTitle:@"按钮" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(100, 100, 100, 50);
    [self.button addTarget:self action:@selector(event_buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"x:::%@",x);
    }];
}

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value

//:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
- (void)subject {
    //创建信号
    RACSubject *subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二%@",x);
    }];
    //发送信号
    [subject sendNext:@"111"];
}
// RACReplaySubject使用步骤:
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.可以先订阅信号，也可以先发送信号。
// 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 2.2 发送信号 sendNext:(id)value
- (void)replaySubject{
    
    //创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    //发送信号
    [replaySubject sendNext:@"222"];
    
    [replaySubject sendNext:@"333"];
    
    //订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    
    //如果想一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    
}

- (void)replaceKVO {
    [[self rac_valuesForKeyPath:@"name" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
/**
 代替通知
 */

- (void)replaceNotification {
    //这个用法就和系统一样了，只是把监听处理的代码聚合在一起，不需要另外写一个方法，提高代码阅读性。
    //我这里是监听了一个键盘弹起的一个通知。
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"键盘起来了：%@",x);
    }];
}
/**
 处理几个信号完成后统一处理事件
 */
- (void)dependSeveralRequest {
    //创建信号1
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //请求1
        //...
        //请求完成
        [subscriber sendNext:@{@"内容1":@"请求1完成了"}];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //请求2
        //...
        //请求完成
        [subscriber sendNext:@{@"内容2":@"请求2完成了"}];
        return nil;
    }];
    [self rac_liftSelector:@selector(request1WithContent:request2WithContent:) withSignals:signalA,signalB, nil];
}
-(void)request1WithContent:(NSDictionary *)content1 request2WithContent:(NSDictionary *)content2 {
    NSLog(@"请求1内容：%@",content1);
    NSLog(@"请求2内容：%@",content2);
}
/**
 RACTuple 元组使用
 */
- (void)ractupleUse {
    /**
     元组
     */
    RACTuple * tuple = RACTuplePack(@"AAA",@2,@3);//使用RACTuplePack宏来快速创建
    NSLog(@"TUPLE:%@",tuple);
    
    //使用RACTupleUnpack宏快速解包
    RACTupleUnpack(NSString *string1,NSNumber *num2,NSNumber *num3) = tuple;
    NSLog(@"string1:%@",string1);
    NSLog(@"num2:%@",num2);
    NSLog(@"num3:%@",num3);
    
    //使用下标的方式来获取
    NSLog(@"第0个:%@",tuple[0]);
}
/**
 宏定义RACObserve  相当于kvo使用
 */
- (void)KVO {
    //2、KVO
    /**
     @param self 是viewController
     @param age self的一个属性
     */
    [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
        NSLog(@"x:%@",x);
    }];
}
/**
 避免循环引用
 */
- (void)avoidCycleReference {
    //3、把一个对象转换成弱指针
    @weakify(self);//self 是viewController 在block外面使用@weakify
    self.signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //在block里面再使用@strongify
        @strongify(self);
        NSLog(@"%@,",self.view);
        return nil;
    }];

}
/*
 RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 */
- (void)arrayTuple{
    
    NSArray *array = @[@1,@2,@3];
    
    [array.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}
// RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
// 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
// RACMulticastConnection使用步骤:
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.创建连接 RACMulticastConnection *connect = [signal publish];
// 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
// 4.连接 [connect connect]
// 5.发送信号


// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.
- (void)multicastConnection {
    
    //1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"请求一次");
        
        //5.发送信号
        [subscriber sendNext:@"2"];
        
        return nil;
    }];
    
    //2.把信号转化为连接类
    RACMulticastConnection *connection = [signal publish];

    //3.订阅连接类信号

    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];

    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];

    //4.链接信号
    [connection connect];
    
}
/**
 RACObserve(obj, name):监听某个对象的某个属性,返回的是信号。
 */
- (void)racObseve {
    [RACObserve(self, age) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}
// 监听文本框的文字改变
- (void)observeTextFieldText {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 100, 60)];
    textField.backgroundColor = UIColor.whiteColor;
    textField.placeholder = @"请输入";
    [self.view addSubview:textField];
    [textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

@end
