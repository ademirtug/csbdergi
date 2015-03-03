//
//  utility.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/23/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//


#import "utility.h"
#import "Catalog.h"
#import "csbAppDelegate.h"
#import "MainVC.h"
#import "pMainVC.h"

bool isReachable()
{
	csbAppDelegate* appd = getappd();
	return [appd hostReach];
}

BOOL isWifiOn(){
	csbAppDelegate* appd = getappd();
	return [appd wifiReach];
}

BOOL isCarrierDataNetworkOn(){
	csbAppDelegate* appd = getappd();
	return [appd cdnReach];
}

Catalog* getCat()
{
    static Catalog* cat = nil;
    
    if (cat == nil) {
		NSString *cf_path = [GetApplicationCacheDirectory() stringByAppendingPathComponent:@"catalog_f.plist"];
		cat = [NSKeyedUnarchiver unarchiveObjectWithFile:cf_path];
		
		if( cat == Nil ){
			cat = [[Catalog alloc]init];
		}
    }
    return cat;
}

void catisupdated()
{
	Catalog* c = getCat();
	c.updated_once = true;
}

bool iscatupdatedonce()
{
	Catalog* c = getCat();
	return c.updated_once;
}

catalog_month* getMonth(NSUInteger y, NSUInteger m)
{
	Catalog* cat = getCat();
	catalog_year* cy = [[cat years] objectForKey:[NSString stringWithFormat: @"%u", y]];
	return [[cy months] objectForKey:[NSString stringWithFormat: @"%u", m]];

}

csbAppDelegate* getappd(){
    return (csbAppDelegate*)[[UIApplication sharedApplication] delegate];
}

MainVC* getmvc(){
    return (MainVC*)[getappd() viewController];
}

pMainVC* getpmvc(){
    return (pMainVC*)[getappd() viewController];
}
NSString* getMonthName(NSUInteger order)
{
	NSLocale *trLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"tr_TR"];
    NSDateFormatter *df = [NSDateFormatter new];
	[df setLocale:trLocale];
	
	
	NSArray *monthNames = [df standaloneMonthSymbols ];
	return [monthNames objectAtIndex:(order - 1)];
}

NSString* GetApplicationDocumentsDirectory(){
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) objectAtIndex:0];

}
NSString* GetApplicationCacheDirectory(){
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) objectAtIndex:0];
}

BOOL save_mag(NSMutableData* pdf, NSString* fn)
{
	@try {
		[pdf writeToFile:[GetApplicationCacheDirectory() stringByAppendingPathComponent:fn] atomically:YES];
	}
	@catch (NSException *exception) {
		NSLog(@"pdf dosyası diske kaydedilemedi, %@", fn);
		return false;
	}
	@finally {
	}
	return true;
}

bool is_exist(NSString* path){
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
bool is_in_doc(NSString* path){
    return [[NSFileManager defaultManager] fileExistsAtPath:[GetApplicationDocumentsDirectory() stringByAppendingPathComponent:path]];
}
bool is_cached(NSString* path){
    return [[NSFileManager defaultManager] fileExistsAtPath:[GetApplicationCacheDirectory() stringByAppendingPathComponent:path]];
}

void excludeFromBackup(NSString* path)
{
	NSURL* URL = [NSURL URLWithString:path];
	if( [[NSFileManager defaultManager] fileExistsAtPath: [URL path]] )
	{
		NSError *error = nil;
		BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
						forKey: NSURLIsExcludedFromBackupKey error: &error];
		if(!success){
			NSLog(@"cant exclude file from backup %@", error);
		}
	}
}


bool isphone()
{
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}


NSDate* to_date(NSString* input)
{
	

}



