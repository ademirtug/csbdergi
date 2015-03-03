//
//  Catalog.h
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/26/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "utility.h"

#import "catalog_month.h"
#import "catalog_year.h"




@interface Catalog : NSObject<NSCoding> {	
	NSMutableDictionary* years;
	
}

- (bool)update;
- (void)serialize;
- (void)deserialize:(NSDictionary*) dict;


@property (atomic, assign) BOOL updated_once;
@property (nonatomic, retain) NSMutableData* cat_data;
@property (nonatomic, retain) NSMutableDictionary* years;
@property (nonatomic, retain) NSDate* retrieved_at;
@property (nonatomic, assign) NSString* service_path;

@end



