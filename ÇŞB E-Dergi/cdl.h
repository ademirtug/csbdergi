//
//  cdl.h
//  edergi
//
//  Created by Akın Demirtuğ on 8/8/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadQueue;

@interface cdl : NSObject


@property (nonatomic, strong) NSURLConnection* cnn;

@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, assign) bool success;




- (void)download;

-(id) initS:(NSString*)file_url ;


@end
