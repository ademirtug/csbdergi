//
//  pDLVC.h
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/8/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class AsyncReflection;

@interface pDLVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblissue, *lblyear, *lblmonth, *lblfilesize, *lblprogress;
@property (strong, nonatomic) IBOutlet UIButton *dl, *display, *cancel;
@property (strong, nonatomic) IBOutlet AsyncReflection* cover;
@property (strong, nonatomic) IBOutlet UIProgressView* progress;

@property (strong, nonatomic) NSURLConnection* cnn;
@property (strong, nonatomic) NSURLRequest* request;
@property (strong, nonatomic) NSMutableData* pdf;
@property (strong, nonatomic) NSString* server_pdf_path;
@property (strong, nonatomic) NSString* server_img_path;

@property (nonatomic) NSUInteger year, month, pub_num, filesize;

- (void)dl_click:(UITapGestureRecognizer *)sender;
- (void)nav_back:(UITapGestureRecognizer *)sender;
- (UIImage*) request_image;
- (id)initS:(NSUInteger)_year m:(NSUInteger)_month pn:(NSUInteger)_pn;
@end
