//
//  utility.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/23/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Catalog;
@class catalog_month;
@class csbAppDelegate;
@class MainVC;
@class pMainVC;

pMainVC* getpmvc();

bool isReachable();
BOOL isWifiOn();
BOOL isCarrierDataNetworkOn();



Catalog* getCat();
void catisupdated();
bool iscatupdatedonce();

catalog_month* getMonth(NSUInteger y, NSUInteger m);

csbAppDelegate* getappd();
MainVC* getmvc();
NSString* getMonthName(NSUInteger order);


NSString* GetApplicationDocumentsDirectory();
NSString* GetApplicationCacheDirectory();


BOOL save_mag(NSMutableData* pdf, NSString* fn);

bool is_exist(NSString* path);
bool is_in_doc(NSString* path);
bool is_cached(NSString* path);

bool isphone();
void excludeFromBackup(NSString* path);

NSDate* to_date(NSString* input);

