//
//  ViewController.m
//  QFReactiveCocoaDemo
//
//  Created by qingfengiOS on 2018/5/14.
//  Copyright © 2018年 slwy. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (nonatomic, strong) LoginViewModel *loginViewModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self uppercaseString];
    
    [self signalSwitch];
    
    [self combineLatest];
    
    [self merge];
    
    [self bindViewModel];
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


//MARK:--MVVM+RAC登录实例
- (void)bindViewModel {
    NSLog(@"------------------------------------");
    _loginViewModel = [[LoginViewModel alloc]init];
    
    RAC(self.loginViewModel, useName) = _userNameTF.rac_textSignal;
    RAC(self.loginViewModel, password) = _passwordTF.rac_textSignal;
    RAC(self.loginBtn, enabled) = [self.loginViewModel isValid];
    
    [self.loginViewModel.sucessObject subscribeNext:^(id x) {
        NSLog(@"登录成功：%@",x);
    }];
    
    [self.loginViewModel.failureObject subscribeNext:^(id x) {
        NSLog(@"登录失败：%@",x);
    }];
    
    [self.loginViewModel.errorObject subscribeNext:^(id x) {
        NSLog(@"登录出错：%@",x);
    }];
    
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [self.loginViewModel login];
    }];
}

@end
