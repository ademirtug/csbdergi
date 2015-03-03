//
//  catalog_month.h
//  csbedergi
//
//  Created by Akın Demirtuğ on 5/31/12.
//  Copyright 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface catalog_month : NSObject<NSCoding>

@property (nonatomic, strong) NSString *file;
@property (nonatomic, assign) NSUInteger month, pn, filesize;
@property (nonatomic, assign) BOOL islocalpdf, islocalimg;
@property (nonatomic, assign) NSDate* updated_at;




- (void)encodeWithCoder:(NSCoder *)coder;
- (id)initWithCoder:(NSCoder *)coder;
- (void)deserialize:(NSDictionary*) dict;

@end
