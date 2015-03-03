//
//  cdl.m
//  edergi
//
//  Created by Akın Demirtuğ on 8/8/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "cdl.h"
#import "utility.h"

@implementation cdl

@synthesize cnn;

@synthesize data;
@synthesize url;
@synthesize success;




-(id) initS:(NSString*)file_url
{
	self = [super init];
	if(self)
	{
		success = false;
		url = file_url;
	}
	return self;
}

-(void)download{
	data = [[NSMutableData alloc] init];
	success = false;
	
	[cnn cancel];
	NSURLRequest* request = Nil;
	
	@try {
		
		request = [NSURLRequest requestWithURL:
				   [NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
		
		cnn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	}
	@catch (NSException *exception) {
		NSLog(@"cdl download başarısız %@", exception.reason);
	}
	@finally {
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
	[data appendData:_data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"retrieving cover is completed");
	success = true;
	
	NSArray* parts = [url componentsSeparatedByString: @"/"];
	NSString* fn = [GetApplicationCacheDirectory() stringByAppendingPathComponent:[parts objectAtIndex:[parts count]-1]];
	
	[data writeToFile:fn atomically:YES];

//	[[NSNotificationCenter defaultCenter] postNotificationName:AsyncImageLoadDidFinish
//														object:_target
//													  userInfo:[[userInfo copy] autorelease]];
	
	
	//[NSNotificationCenter defaultCenter] postNotificationName:<#(NSString *)#> object:<#(id)#> userInfo:<#(NSDictionary *)#> ;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	success = false;
	NSLog(@"cdl download fail");
}

@end
