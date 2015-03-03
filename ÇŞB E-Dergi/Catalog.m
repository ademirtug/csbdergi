//
//  Catalog.m
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/26/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "Catalog.h"
#import "MainVC.h"
#import "CatVC.h"



@implementation Catalog

@synthesize years;
@synthesize retrieved_at;
@synthesize cat_data;
@synthesize updated_once;
@synthesize service_path;

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	
	retrieved_at = [coder decodeObjectForKey:@"CRetrievedAt"];
	years = [coder decodeObjectForKey:@"CYears"];
	updated_once = false;
	
    return self;
}

- (bool)update{
	
	if( !isWifiOn() && !isCarrierDataNetworkOn() )
		return false;
	
#ifdef DEBUG
	service_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/channel.ashx?cmd=get_cat";	
#else
	service_path = @"http://uygulamalar.csb.gov.tr/csbdergi/channel.ashx?cmd=get_cat";
#endif
	
	cat_data = [[NSMutableData alloc] init];
	NSURLRequest* request = Nil;
	NSURLConnection* cnn = Nil;
	bool success = false;

	@try {
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:service_path]
					cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
		
		cnn = [NSURLConnection connectionWithRequest:request delegate:self];
		success = true;
	}
	@catch (NSException *exception) {
		NSLog(@"cat update başarısız %@", exception.reason);
	}
	@finally {
	}
	return success;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data {
	[cat_data appendData:_data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"retrieving cat_data is completed");

	@try {
		if( !iscatupdatedonce() )
			catisupdated();
		
		NSError* err = [[NSError alloc]init];
		NSDictionary* dcat = Nil;
		NSArray* dyears = Nil;
		years = [[NSMutableDictionary alloc]init];
		
		dcat = [NSJSONSerialization JSONObjectWithData:cat_data options:kNilOptions error:&err];
		
		retrieved_at = [dcat objectForKey:@"retrieved_at"];
		
		dyears = [dcat objectForKey:@"years"];
		
		for (NSUInteger i = 0; i < [dyears count]; ++i) {
			catalog_year* y = [[catalog_year alloc]init];
			[y deserialize: [dyears objectAtIndex:i]];
			
			[years setObject:y forKey:[NSString stringWithFormat:@"%u", [y year]]];
		}
		
		
		NSArray* sorted_years = [years allKeys];
		
		
		for(int e = 0; e < [sorted_years count]; e++)
		{
			catalog_year* cy = [years objectForKey:[sorted_years objectAtIndex:e]];
			
			NSArray* keys = [[cy months] allKeys];
			
			for(int i = 0; i < [keys count]; i++)
			{
				catalog_month* cm = [[cy months] objectForKey:[keys objectAtIndex:i]];
			
				@try
				{
					NSDictionary *attributes = [[NSFileManager defaultManager]
						attributesOfItemAtPath:[GetApplicationCacheDirectory() stringByAppendingPathComponent:
						[NSString stringWithFormat:@"%u-%u.png", cy.year, cm.month]] error:nil];
				
					if( attributes == Nil)
						continue;
					
					NSDate* date = [attributes objectForKey:@"NSFileModificationDate"];
					
					NSComparisonResult cr = [date compare:cm.updated_at];
					
					if( cr == NSOrderedDescending )
						continue;
				
				
					[[NSFileManager defaultManager] removeItemAtPath:[GetApplicationCacheDirectory() stringByAppendingPathComponent:
						[NSString stringWithFormat:@"%u-%u.png", cy.year, cm.month]] error:Nil];
					
					
					[[NSFileManager defaultManager] removeItemAtPath:[GetApplicationCacheDirectory() stringByAppendingPathComponent:
						[NSString stringWithFormat:@"%u-%u.pdf", cy.year, cm.month]] error:Nil];
			
				}
				@catch(NSException *ie) {
					NSLog(@"catalog::connectiondidfinishlaunching halted at file deletion %@", ie.reason);
				}
			}
		}
		
		
		[self serialize];
		
		
		
		MainVC* mvc = getmvc();
		if( mvc.catv != Nil )
		{
			[mvc.catv refresh];
		}
	}
	@catch (NSException *exception) {
		NSLog(@"catalog::connectiondidfinishlaunching halted %@", exception.reason);
	}
	@finally {
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
}

- (void)serialize{
    NSString *cf_path = [GetApplicationCacheDirectory() stringByAppendingPathComponent:@"catalog_f.plist"];
	[NSKeyedArchiver archiveRootObject:self toFile:cf_path];
	excludeFromBackup(cf_path);
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:years forKey:@"CYears"];
	[coder encodeObject:retrieved_at forKey:@"CRetrievedAt"];
}

- (void) deserialize:(NSDictionary*) dict{
}


@end










