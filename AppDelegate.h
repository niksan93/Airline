//
//  AppDelegate.h
//  Airline
//
//  Created by Alexandr Nikanorov on 25.06.12.
//  Copyright (c) 2012 niksan93@yandex.ru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckinViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CheckinViewController *viewController;

@end
