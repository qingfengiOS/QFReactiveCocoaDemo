//
//  LoginViewModel.m
//  QFReactiveCocoaDemo
//
//  Created by qingfengiOS on 2018/5/21.
//  Copyright © 2018年 slwy. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel ()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) NSArray *requestData;

@end

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        _userNameSignal = RACObserve(self, useName);
        _passwordSignal = RACObserve(self, password);
        
        _sucessObject = [RACSubject subject];
        _failureObject = [RACSubject subject];
        _errorObject = [RACSubject subject];

    }
    return self;
}

- (id)isValid {
    RACSignal *validSignal = [RACSignal combineLatest:@[_userNameSignal, _passwordSignal] reduce:^id (NSString *userName, NSString *password) {
        return @(userName.length >= 3 && password.length >= 3);
    }];
    return validSignal;
}

- (void)login {
    _requestData = @[_useName, _password];
    
    //这里实现网络请求
    int res = arc4random_uniform(3);
    switch (res) {
        case 0:
            [_sucessObject sendNext:_requestData];
            break;
        case 1:
            [_failureObject sendNext:@"登录失败"];
            break;
        case 2:
            [_errorObject sendNext:@"登录报错"];
            break;
        default:
            break;
    }
    
    
    
}

@end
