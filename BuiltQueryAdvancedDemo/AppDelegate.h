//
//  AppDelegate.h
//  AdvancedQueryTutorial
//
//  Created by Akshay Mhatre on 25/03/14.
//  Copyright (c) 2014 raweng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) BuiltApplication *builtApplication;
@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate*)sharedInstance;
@end
