//
//  pCatVC.h
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/2/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface pCatVC : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UILabel* info;
@property (nonatomic) BOOL isset;
@property (nonatomic, assign) NSString* server_img_path;


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)__carousel;
@end
