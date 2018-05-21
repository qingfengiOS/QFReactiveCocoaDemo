//
//  LoginViewModel.h
//  QFReactiveCocoaDemo
//
//  Created by qingfengiOS on 2018/5/21.
//  Copyright © 2018年 slwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewModel : NSObject

@property (nonatomic, copy) NSString *useName;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) RACSubject *sucessObject;
@property (nonatomic, strong) RACSubject *failureObject;
@property (nonatomic, strong) RACSubject *errorObject;

- (id)isValid;

- (void)login;

@end
