//
//  csbMagDLVCViewController.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/25/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MagDLVC : UIViewController

- (void)dl_click:(UITapGestureRecognizer *)sender;
- (void)nav_back:(UITapGestureRecognizer *)sender;
- (UIImage*) request_image;
- (id)initS:(NSUInteger)_year m:(NSUInteger)_month pn:(NSUInteger)_pn;


@property (strong, nonatomic) IBOutlet UIImageView* cover;
@property (strong, nonatomic) IBOutlet UILabel* lbl_year;
@property (strong, nonatomic) IBOutlet UILabel* lbl_month;
@property (strong, nonatomic) IBOutlet UILabel* lbl_issue;
@property (strong, nonatomic) IBOutlet UILabel* lbl_filesize;
@property (strong, nonatomic) IBOutlet UILabel* lbl_progress;
@property (strong, nonatomic) IBOutlet UIProgressView* progress;
@property (strong, nonatomic) IBOutlet UIButton* dl;
@property (strong, nonatomic) IBOutlet UIButton* vmag;
@property (strong, nonatomic) IBOutlet UIButton* cancel;



@property (strong, nonatomic) NSURLConnection* cnn;
@property (strong, nonatomic) NSURLRequest* request;
@property (strong, nonatomic) NSMutableData* pdf;
@property (strong, nonatomic) NSString* server_pdf_path;


@property (nonatomic) NSUInteger year, month, pub_num, filesize;

@end
