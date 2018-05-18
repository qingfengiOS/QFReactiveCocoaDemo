//
//  ViewController.m
//  QFReactiveCocoaDemo
//
//  Created by 李一平 on 2018/5/14.
//  Copyright © 2018年 slwy. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self uppercaseString];
    
    [self signalSwitch];
    
    [self combineLatest];
    
    [self merge];
}

- (void)uppercaseString {
    NSLog(@"------------------------------------");
    /*
    RACSequence *sequence = [@[@"you",@"are",@"beautiful"] rac_sequence];
    RACSignal *signal = sequence.signal;
    RACSignal *capitalizeSignal = [signal map:^id _Nullable(NSString *value) {
        return [value capitalizedString];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"signal -- %@",x);
    }];
    
    [capitalizeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"capitalizeSignal -- %@",x);
    }];
    */
    [[[@[@"you",@"are",@"beautiful"] rac_sequence].signal map:^id _Nullable(id  _Nullable value) {
        return [value capitalizedString];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"capitalizedSignal --- %@", x);
    }];
    
}

- (void)signalSwitch {
    NSLog(@"------------------------------------");
    //创建3个自定义信号
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //开关信号
    RACSignal *switchList = [signalOfSignal switchToLatest];
    //map
    [[switchList map:^id _Nullable(id  _Nullable value) {
        return [@"https//www." stringByAppendingFormat:@"%@", value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //通过开关打开baidu
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu.com"];
    [google sendNext:@"google.com"];
    
    //通过开关打开google
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com/"];
    [google sendNext:@"google.com/"];
    /*
     通过Switch我们可以控制那个信号量起作用，并且可以在信号量之间进行切换。也可以这么理解，把Switch看成另一段水管，Switch对接那个水管，就流那个水管的水，这样比喻应该更为贴切一些
     */
}

- (void)combineLatest {
    NSLog(@"------------------------------------");
    RACSubject *first = [RACSubject subject];
    RACSubject *second = [RACSubject subject];
    
    [[RACSignal combineLatest:@[first, second] reduce:^(NSString *first, NSString *second) {
        return [first stringByAppendingString:second];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [first sendNext:@"1"];
    [first sendNext:@"2"];
    [second sendNext:@"A"];
    [first sendNext:@"3"];
    [second sendNext:@"B"];
    /*
     信号量的合并说白了就是把两个水管中的水合成一个水管中的水。但这个合并有个限制，当两个水管中都有水的时候才合并。如果一个水管中有水，另一个水管中没有水，那么有水的水管会等到无水的水管中来水了，在与这个水管中的水按规则进行合并。
     */
}

- (void)merge {
    NSLog(@"------------------------------------");
    RACSubject *first = [RACSubject subject];
    RACSubject *second = [RACSubject subject];
    RACSubject *third = [RACSubject subject];
    
    [[RACSignal merge:@[first, second, third]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [first sendNext:@"first"];
    [second sendNext:@"second"];
    [third sendNext:@"third"];
    /*
     信号合并就理解起来就比较简单了，merge信号量规则比较简单，就是把多个信号量，放入数组中通过merge函数来合并数组中的所有信号量为一个。类比一下，合并后，无论哪个水管中有水都会在merge产生的水管中流出来的。
     */
}
@end
