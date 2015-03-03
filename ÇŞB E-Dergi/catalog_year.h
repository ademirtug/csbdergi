//
//  catalog_year.h
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/31/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "catalog_month.h"



@interface catalog_year : NSObject<NSCoding>
{
	NSMutableDictionary* months;
	NSInteger year;
}

@property (assign) NSInteger year;
@property (nonatomic, retain) NSMutableDictionary* months;



- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
- (void)deserialize:(NSDictionary*) dict;

@end
