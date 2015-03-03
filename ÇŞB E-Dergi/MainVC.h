//
//  csbViewController.h
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatVC.h"
#import "Catalog.h"
#import "Reachability.h"

@class MagDLVC;
@class MagVC;
@class pCatVC;

@interface MainVC : UIViewController{

}

@property (strong, nonatomic) MagDLVC* dlvc;
@property (strong, nonatomic) CatVC* catv;
@property (strong, nonatomic) MagVC* magvc;


@property (strong, nonatomic) Catalog* cat;
@property (strong, nonatomic) IBOutlet UIButton* back;


@end
