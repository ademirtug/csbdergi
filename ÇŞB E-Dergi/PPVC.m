//
//  csbPPVC.m
//  edergi
//
//  Created by Akın Demirtuğ on 8/1/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "PPVC.h"
#import "PDFScrollView.h"
#import "utility.h"
#import "MainVC.h"

@interface PPVC ()

@end

@implementation PPVC


@synthesize sayfa;
@synthesize pdf;


-(id)initS:(NSUInteger) pn pdfref:(CGPDFDocumentRef) pdfdosya;
{
	self = [super initWithNibName:@"PPVC" bundle:Nil];
	if(self)
	{
		sayfa = pn;
		pdf = pdfdosya;
	}
	return self;
}
-(void)dealloc
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];

	CGRect fr = self.view.frame;
	if (getmvc().view.bounds.size.height == 748) {
		fr.size.width = 1024/2;
		fr.size.height = 748;
	}
	[self setupView:fr];
	
}

-(void)setupView:(CGRect) fr
{
	PDFScrollView* psv = [[PDFScrollView alloc]initWithFrame:fr];

	[psv setPDFPage:CGPDFDocumentGetPage(pdf, sayfa)];
	self.view = psv;
}

@end
