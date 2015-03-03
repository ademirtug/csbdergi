//
//  catalog_year.m
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/31/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "catalog_year.h"

@implementation catalog_year

@synthesize months;
@synthesize year;

- (id)init
{
	self = [super init];
	months = [[NSMutableDictionary alloc]init];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {	
		[coder encodeInteger:year forKey:@"CYYear"];
        [coder encodeObject:months forKey:@"CYMonths"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	year = [coder decodeIntForKey:@"CYYear"];
	months = [coder decodeObjectForKey:@"CYMonths"];
	
    return self;
}


- (void) deserialize:(NSDictionary*) dict{
	
	year = [[dict objectForKey:@"year"] intValue];
	
	NSArray* arrmon = [dict objectForKey:@"months"];
	
	for (int i = 0; i < [arrmon count] ; ++i) {
		catalog_month* m = [[catalog_month alloc]init];
		
		[m deserialize:[arrmon objectAtIndex:i]];
		
		[months setObject:m forKey:[NSString stringWithFormat:@"%u",[m month]]];
		
	}
	
}


@end

