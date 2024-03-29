//
//  SFNotificationObserver.m
//  SFNotificationObserver
//
//  Created by vvveiii on 2019/6/25.
//  Copyright © 2019 lvv. All rights reserved.
//

#import "SFNotificationObserver.h"

@interface SFNotificationObserver () {
    NSNotificationCenter *_nc;
    NSRecursiveLock *_lock;
    NSMutableDictionary<NSString *, SFNotificationObserverBlock> *_nameMap;
}

@end

@implementation SFNotificationObserver

+ (instancetype)observer {
    return [[self alloc] init];
}

- (void)dealloc {
    [_nameMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, SFNotificationObserverBlock  _Nonnull obj, BOOL * _Nonnull stop) {
        [self->_nc removeObserver:self name:key object:nil];
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = [[NSRecursiveLock alloc] init];
        _nc = NSNotificationCenter.defaultCenter;
        _nameMap = NSMutableDictionary.dictionary;
    }

    return self;
}

- (void)removeNotificationWithName:(NSString *)name {
    if (!name) {
        return;
    }

    [_lock lock];

    SFNotificationObserverBlock block = _nameMap[name];
    if (block) {
        [_nameMap removeObjectForKey:name];
        [_nc removeObserver:self name:name object:nil];
    }

    [_lock unlock];
}

- (void)addNotificationWithName:(NSString *)name block:(SFNotificationObserverBlock)block {
    if (!name || !block) {
        return;
    }

    [_lock lock];
    _nameMap[name] = [block copy];
    [_lock unlock];

    [_nc addObserver:self selector:@selector(handleNotification:) name:name object:nil];
}

- (void)handleNotification:(NSNotification *)notification {
    NSString *name = notification.name;
    NSDictionary *userInfo = notification.userInfo;

    [_lock lock];
    SFNotificationObserverBlock block = _nameMap[name];
    [_lock unlock];

    if (block) {
        block(userInfo);
    }
}

@end
