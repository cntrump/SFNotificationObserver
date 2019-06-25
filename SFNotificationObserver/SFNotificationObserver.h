//
//  SFNotificationObserver.h
//  SFNotificationObserver
//
//  Created by vvveiii on 2019/6/25.
//  Copyright © 2019 lvv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SFNotificationObserverBlock)(NSDictionary *userInfo);

@interface SFNotificationObserver : NSObject

+ (instancetype)observer;

- (instancetype)init;

- (void)addNotificationWithName:(NSString *)name block:(SFNotificationObserverBlock)block;
- (void)removeNotificationWithName:(NSString *)name;

@end
