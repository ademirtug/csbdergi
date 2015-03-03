//
//  csbCatVC.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "CatItem.h"


@interface CatVC : UIViewController<UIScrollViewDelegate>


- (CGSize)contentSizeForPagingScrollView;

- (NSUInteger)imageCount;
- (NSUInteger)totalMonths;

- (void)refresh;
- (void)setupview;
- (void)rearrange:(int) xpos;

@property (strong, nonatomic) NSMutableArray* list_cit;
@property (strong, nonatomic) IBOutlet UIScrollView* pagingScrollView;
@property (strong, nonatomic) Catalog* cat;

@end
