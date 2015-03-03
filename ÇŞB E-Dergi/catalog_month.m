//
//  catalog_month.m
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/31/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "catalog_month.h"



@implementation catalog_month

@synthesize  file;
@synthesize month, pn, filesize;
@synthesize islocalpdf, islocalimg;
@synthesize updated_at;


- (id)init
{
	self = [super init];

	file = [[NSString alloc] init];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:file forKey:@"CMFile"];
	
	[coder encodeInt:month forKey:@"CMMonth"];
	[coder encodeInt:pn forKey:@"CMPn"];
	[coder encodeInt:filesize forKey:@"CMFilesize"];
	
	[coder encodeObject:updated_at forKey:@"CMUpdatedAt"];
	
	[coder encodeBool:islocalpdf forKey:@"CMIsLocalPdf"];
	[coder encodeBool:islocalimg forKey:@"CMIsLocalImg"];	
}

- (id)initWithCoder:(NSCoder *)coder {
	
	self = [super init];
	
	file = [coder decodeObjectForKey:@"CMFile"];
	
	month = [coder decodeIntForKey:@"CMMonth"];
	pn = [coder decodeIntForKey:@"CMPn"];
	filesize = [coder decodeIntForKey:@"CMFilesize"];
	updated_at = [coder decodeObjectForKey:@"CMUpdatedAt"];
//	
//	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//	[formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
//
//	updated_at = [formatter dateFromString:[coder decodeObjectForKey:@"CMUpdatedAt"]];
	
	islocalpdf = [coder decodeBoolForKey:@"CMIsLocalPdf"];
	islocalimg = [coder decodeBoolForKey:@"CMIsLocalImg"];
	
    return self;
}

- (void) deserialize:(NSDictionary*) dict{
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
	
	updated_at = [formatter dateFromString:[dict objectForKey:@"updated_at"]];
	
	
	
	filesize = [[dict objectForKey:@"filesize"]intValue];
	month = [[dict objectForKey:@"month"]intValue];
	pn = [[dict objectForKey:@"pn"]intValue];
	
	islocalimg = false;
	islocalpdf = false;
}
@end

