//
//  pMainVC.m
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/2/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import "pMainVC.h"
#import "pCatVC.h"
#import "pDLVC.h"

@interface pMainVC ()

@end

@implementation pMainVC
@synthesize catv;
@synthesize dlvc;
@synthesize back;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	catv = [[pCatVC alloc]init];
	[self addChildViewController:catv];
	[self.view addSubview:catv.view];
	[catv didMoveToParentViewController:self];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view.autoresizesSubviews = YES;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
