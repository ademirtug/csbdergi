//
//  csbViewController.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "MainVC.h"
#import "CatVC.h"
#import "utility.h"
#import "MagVC.h"
#import "MagDLVC.h"
#import "pCatVC.h"



@interface MainVC ()

@end

@implementation MainVC

@synthesize cat;

@synthesize catv;
@synthesize magvc;
@synthesize dlvc;


@synthesize back;




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSLog(@"MainVC::viewDidload is executing");

	catv = [[CatVC alloc]init];
	[self addChildViewController:catv];
	[self.view addSubview:catv.view];
	[catv didMoveToParentViewController:self];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view.autoresizesSubviews = YES;
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}


-(BOOL)shouldAutorotate
{
	return YES;
}
-(NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}
@end
