//
//  csbAppDelegate.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "csbAppDelegate.h"

#import "MainVC.h"
#import "pMainVC.h"

@implementation csbAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize isconnected;
@synthesize __hostReach, __wifiReach, __internetReach;
@synthesize hostReach, wifiReach, cdnReach;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    

    if( isphone() )
	{
		self.viewController = [[pMainVC alloc] initWithNibName:@"pMainVC" bundle:nil];
	}
	else
	{
		self.viewController = [[MainVC alloc] initWithNibName:@"MainVC" bundle:nil];	
	}

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	isconnected = false;
	hostReach = false;
	wifiReach = false;
	cdnReach = false;

	
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	__hostReach = [Reachability reachabilityWithHostName: @"www.google.com.tr"];
	[__hostReach startNotifier];
	
    return YES;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

	dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
		bool dc = false;
		switch (netStatus)
		{
			case NotReachable:
			{
				dc = true;
				cdnReach = false;
				wifiReach = false;
				hostReach = false;
				
				break;
			}
			case ReachableViaWWAN:
			{
				cdnReach = true;
				break;
			}
			case ReachableViaWiFi:
			{
				wifiReach = true;
				break;
			}
		}

		isconnected = !dc;
		
		dispatch_async( dispatch_get_main_queue(), ^{

			if(isconnected)
			{
				Catalog* _cat = getCat();
				[_cat update];
			}
			else
			{
				UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Internet bağlantınız mevcut değil." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil,nil];
				[av show];
			}
		});
	});
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
