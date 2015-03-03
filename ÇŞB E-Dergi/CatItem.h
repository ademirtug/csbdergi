//
//  csbCatItem.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "utility.h"
#import "MagDLVC.h"

@interface CatItem : UIViewController{
    
    
}

- (id)initS:(NSUInteger) __year ay:(NSUInteger)__month dn:(NSUInteger)__pn;
- (void) request_image;
- (void)img_tappd:(UITapGestureRecognizer *)sender;
- (void)load_mag;



@property (strong, nonatomic) MagDLVC* dlvc;
@property (nonatomic) NSUInteger _year, _month, _pn;
@property (nonatomic, strong) IBOutlet UIImageView* cover;
@property (nonatomic, strong) IBOutlet UILabel* lbl_year;
@property (nonatomic, strong) IBOutlet UILabel* lbl_month;
@property (nonatomic, strong) IBOutlet UILabel* lbl_issue;
@property (nonatomic, strong) NSMutableData* img_data;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) NSString* server_img_path;


@end
