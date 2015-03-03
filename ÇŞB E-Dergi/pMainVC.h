//
//  pMainVC.h
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/2/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pCatVC;
@class pDLVC;
@class pMagVC;

@interface pMainVC : UIViewController

@property (strong, nonatomic) pCatVC* catv;
@property (strong, nonatomic) pDLVC* dlvc;
@property (strong, nonatomic) pMagVC* magv;

@property (strong, nonatomic) IBOutlet UIButton *back;

@end
