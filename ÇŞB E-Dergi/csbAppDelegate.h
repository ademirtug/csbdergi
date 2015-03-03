//
//  csbAppDelegate.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@class MainVC;

@interface csbAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;


@property (assign, atomic) bool isconnected;
@property (strong, atomic) Reachability *__hostReach, *__wifiReach, *__internetReach;
@property (assign, atomic) bool hostReach, wifiReach, cdnReach;



- (void) reachabilityChanged: (NSNotification* )note;

@end

