//
//  ContentViewController.m
//  UIPageViewControllerDemo
//
//  Created by Uppal'z on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "pPPVC.h"
#import "pPDFScrollView.h"
#import "utility.h"
#import "pMainVC.h"

@implementation pPPVC


@synthesize sayfa;
@synthesize pdf;


-(id)initS:(NSUInteger) pn pdfref:(CGPDFDocumentRef) pdfdosya;
{
	self = [super initWithNibName:@"pPPVC" bundle:Nil];
	if(self)
	{
		sayfa = pn;
		pdf = pdfdosya;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	CGRect fr = getpmvc().view.frame;
//	CGRect bn = ;
//	
//	if( UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) )
//	{
//		
//	}
	
	[self setupView:getpmvc().view.bounds];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	
}
-(void)setupView:(CGRect) fr
{
	pPDFScrollView* psv = [[pPDFScrollView alloc]initWithFrame:fr];
	
	[psv setPDFPage:CGPDFDocumentGetPage(pdf, sayfa)];
	self.view = psv;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
