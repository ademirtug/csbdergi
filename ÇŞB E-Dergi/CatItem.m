//
//  csbCatItem.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "CatItem.h"
#import "MagDLVC.h"
#import "MainVC.h"
#import "csbAppDelegate.h"
#import "MagVC.h"
#import <QuartzCore/QuartzCore.h>

@interface CatItem ()

@end

@implementation CatItem

@synthesize lbl_year, lbl_issue, lbl_month;
@synthesize cover;
@synthesize _year, _month, _pn;
@synthesize dlvc;
@synthesize img_data;
@synthesize activityIndicator;
@synthesize server_img_path;

-(id)initS:(NSUInteger) __year ay:(NSUInteger)__month dn:(NSUInteger)__pn
{
	self = [super init];
    
	_year = __year;
	_month = __month;
	_pn = __pn;
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.frame = CGRectMake(100, 130, 0, 0);
    
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.userInteractionEnabled = NO;


	[cover.layer setBorderColor: [[UIColor whiteColor] CGColor]];
	[cover.layer setBorderWidth: 2.0];
	
	
    lbl_year.text = [NSString stringWithFormat:@"%u", _year];
    lbl_month.text = [NSString stringWithFormat:@"%@", getMonthName(_month)];
    lbl_issue.text = [NSString stringWithFormat:@"Sayı %u", _pn];

	[self request_image];
    
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img_tappd:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[cover addGestureRecognizer:tapRecognizer];
	
	[self.view addSubview:activityIndicator];
}

-(void)img_tappd:(UITapGestureRecognizer *)sender
{
    if( is_cached( [NSString stringWithFormat:@"%u-%u.pdf", _year, _month] ) )
    {
		[self load_mag];
    }
    else
    {
		getmvc().dlvc = [[MagDLVC alloc]initS:_year m:_month pn:_pn ];
		[getmvc().dlvc.view setFrame:CGRectMake((getmvc().view.bounds.size.width-768)/2, 0, 768, 1004)];
			
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:getmvc().view cache:YES];
			
		[getmvc().dlvc viewWillAppear:YES];
		[getmvc().catv viewWillDisappear:YES];
			
		[getmvc().catv.view removeFromSuperview];
			
		[getmvc() addChildViewController:getmvc().dlvc];
		[getmvc().view insertSubview:getmvc().dlvc.view atIndex:0];
		[getmvc().dlvc didMoveToParentViewController:getmvc()];
			
			
		[getmvc().dlvc viewDidAppear:YES];
		[getmvc().catv viewDidDisappear:YES];
			
		[UIView commitAnimations];
    }
}

- (void)load_mag
{
	getmvc().magvc = [[MagVC alloc] initS:_year m:_month];
	[getmvc().magvc.view setFrame:getmvc().view.bounds];
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:getmvc().view cache:YES];
	
	[getmvc().catv viewWillDisappear:YES];
	[getmvc().magvc viewWillAppear:YES];
	
	[getmvc().catv.view removeFromSuperview];
	[getmvc().catv removeFromParentViewController];
	
	[getmvc() addChildViewController:getmvc().magvc];
	[getmvc().view insertSubview:getmvc().magvc.view atIndex:0];
	[getmvc().magvc didMoveToParentViewController:getmvc()];
	
	
	[getmvc().catv viewDidDisappear:YES];
	[getmvc().magvc viewDidAppear:YES];
	
	[UIView commitAnimations];
}

- (void)request_image
{
    @try 
    {
		NSString* thumb = [NSString stringWithFormat:@"%u-%u.png", _year, _month];
		
		if(is_cached(thumb))
		{
			self.view.userInteractionEnabled = YES;
			[cover setImage:[UIImage imageWithContentsOfFile:[GetApplicationCacheDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%u-%u.png", _year, _month]]]];
		}
		else 
		{
			if( !isWifiOn() && !isCarrierDataNetworkOn() )
				return;
			
			[activityIndicator startAnimating];
			
			
			img_data = [[NSMutableData alloc]init];
			NSURLRequest* request = Nil;
			NSURLConnection* cnn = Nil;

#ifdef DEBUG
			server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/dergiler/%u-%u.png";
#else
			server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi/dergiler/%u-%u.png";
#endif
			
			request = [NSURLRequest requestWithURL:
				[NSURL URLWithString:[NSString stringWithFormat:server_img_path, _year, _month]]
				cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
				
			cnn = [[NSURLConnection alloc]initWithRequest:request delegate:self];			
		}
    }
    @catch (NSException *exception) {
        NSLog(@"request_image have failed for reason: %@", exception);
    }
    @finally {
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data {
	[img_data appendData:_data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSString* pth = [GetApplicationCacheDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%u-%u.png", _year, _month]];
	
	NSError* error;
    [img_data writeToFile:pth options:kNilOptions error:&error];
	[cover setImage:[[UIImage alloc]initWithData:img_data]];
	[activityIndicator stopAnimating];
	self.view.userInteractionEnabled = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[self request_image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
