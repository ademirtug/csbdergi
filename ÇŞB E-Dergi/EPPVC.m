//
//  EPPVC.m
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/1/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import "EPPVC.h"
#import "utility.h"
#import "MainVC.h"

@interface EPPVC ()

@end

@implementation EPPVC

- (id)init
{
    self = [super init];
    if (self) {
        self.sayfa = 0;
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.contentMode =  UIViewContentModeScaleToFill;

	CGRect fr = self.view.frame;
	if (getmvc().view.bounds.size.height == 748) {
		fr.size.width = 1024/2;
		fr.size.height = 748;
	}
	[self setupView:fr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setupView:(CGRect) fr
{
	self.view.backgroundColor = [UIColor whiteColor];
	
//	UIImage* img = [UIImage imageNamed:@"Default-Portrait~ipad"];
//	UIImageView* imgv = [[UIImageView alloc ] initWithImage:img];
//	imgv.contentMode = UIViewContentModeScaleToFill;
	
//	[self.view addSubview:imgv];
}
@end
