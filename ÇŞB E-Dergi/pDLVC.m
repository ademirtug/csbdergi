//
//  pDLVC.m
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/8/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import "pDLVC.h"
#import "utility.h"
#import "pMainVC.h"
#import "Catalog.h"
#import "AsyncReflection.h"
#import "pCatVC.h"
#import "pMagVC.h"

@interface pDLVC ()

@end

@implementation pDLVC


@synthesize lblyear, lblmonth, lblfilesize, lblissue, lblprogress;
@synthesize dl, cancel, display;
@synthesize cover;
@synthesize year, month, pub_num, filesize;
@synthesize cnn;
@synthesize pdf;
@synthesize request;
@synthesize progress;
@synthesize server_pdf_path;
@synthesize server_img_path;


- (id)initS:(NSUInteger)_year m:(NSUInteger)_month pn:(NSUInteger)_pn
{
    self = [super initWithNibName:@"pDLVC" bundle:Nil];
    if (self) {
		year = _year;
		month = _month;
		pub_num = _pn;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[getpmvc().dlvc.view setFrame:CGRectMake((getpmvc().view.bounds.size.width-320)/2, 0, 320, 460)];
	
	[self setupView];	
}

-(void)setupView
{
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dl_click:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[dl addGestureRecognizer:tapRecognizer];
	
	UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nav_back:)];
	[tapRecognizer2 setNumberOfTapsRequired:1];
	[getpmvc().back addGestureRecognizer:tapRecognizer2];
	
	UITapGestureRecognizer *tapRecognizer3= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(display_click:)];
	[tapRecognizer3 setNumberOfTapsRequired:1];
	[display addGestureRecognizer:tapRecognizer3];
	
	UITapGestureRecognizer *tapRecognizer4= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel_click:)];
	[tapRecognizer4 setNumberOfTapsRequired:1];
	[cancel addGestureRecognizer:tapRecognizer4];
	
	getpmvc().back.hidden = NO;

#if DEBUG
	server_pdf_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/dergiler/%u-%u.pdf";
#else
	server_pdf_path = @"http://uygulamalar.csb.gov.tr/csbdergi/dergiler/%u-%u.pdf";
#endif

#if DEBUG
	server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/dergiler/%u-%u.png";
#else
	server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi/dergiler/%u-%u.png";
#endif
	
	[((AsyncReflection*)cover) setImageURL:
	 [NSURL URLWithString:[NSString stringWithFormat:server_img_path, year, month]]];
	
	filesize = [getMonth(year, month) filesize];
	
	lblyear.text = [NSString stringWithFormat:@"%u", year];
	lblissue.text = [NSString stringWithFormat:@"Sayı %u", pub_num];
	lblfilesize.text = [NSString stringWithFormat:@"Boyut: %uKB", filesize/1024];
	lblmonth.text = getMonthName(month);
	
	[cover.layer setBorderColor: [[UIColor whiteColor] CGColor]];
	[cover.layer setBorderWidth: 2.0];
}

-(void)dl_click:(UITapGestureRecognizer *)sender
{
	if( !isWifiOn() && !isCarrierDataNetworkOn() )
	{
		UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Uyarı" message:@"Cihazınız internete bağlı değil." delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil,nil];
		[av show];
		return;
	}
	
	pdf = [[NSMutableData alloc] init];
	request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: server_pdf_path, year, month] ] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
		
	cnn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
	if (cnn) {
		dl.hidden = YES;
		progress.hidden = NO;
		lblprogress.hidden = NO;
		cancel.hidden = NO;
		getpmvc().back.hidden = YES;
	}
}

-(void)cancel_click:(UITapGestureRecognizer *)sender
{
	@try
	{
		[cnn cancel];
		[lblprogress setText:[NSString stringWithFormat:@"0 KB / %u KB", (filesize / 1024)]];
		[progress setProgress: 0];
		
		progress.hidden = YES;
		lblprogress.hidden = YES;
		
		cancel.hidden = YES;
		dl.hidden = NO;
		getpmvc().back.hidden = NO;
	}
	@catch (NSException * e) {
		NSLog(@"");
	}
}

-(void)display_click:(UITapGestureRecognizer *)sender
{
	getpmvc().back.gestureRecognizers = nil;
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:getpmvc().view cache:YES];

	[getpmvc().dlvc.view removeFromSuperview];
	[getpmvc().dlvc removeFromParentViewController];
	
	getpmvc().magv = [[pMagVC alloc]initS:year m:month];
	[getpmvc().magv.view setFrame:getpmvc().view.bounds];
	
	[getpmvc() addChildViewController:getpmvc().magv];
	[getpmvc().view insertSubview:getpmvc().magv.view atIndex:0];
	[getpmvc().magv didMoveToParentViewController:getpmvc()];
	
	[UIView commitAnimations];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data
{
	[pdf appendData:_data];
	[lblprogress setText:[NSString stringWithFormat:@"%u KB / %u KB", ([pdf length] / 1024), (filesize / 1024)]];
	[progress setProgress: ((float)[pdf length] / (float)filesize )];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"file download is complete, bytes received is %u",[pdf length]);
	
	dl.hidden = YES;
	display.hidden = NO;
	cancel.hidden = YES;
	getpmvc().back.hidden = NO;
	
	save_mag(pdf, [NSString stringWithFormat:@"%u-%u.pdf", year, month] );
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	dl.hidden = NO;
	cancel.hidden = YES;
	getpmvc().back.hidden = NO;
	
	NSLog(@"Connection failed! Error - %@",[error localizedDescription]);
	
	cnn = nil;
	request = nil;
	pdf = nil;
}

-(void)nav_back:(UITapGestureRecognizer *)sender
{
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:getpmvc().view cache:YES];

	[getpmvc().dlvc.view removeFromSuperview];
	[getpmvc().dlvc removeFromParentViewController];
	
	[getpmvc().catv.view setFrame:getpmvc().view.bounds];
	
	[getpmvc() addChildViewController:getpmvc().catv];
	[getpmvc().view insertSubview:getpmvc().catv.view atIndex:0];
	[getpmvc().catv didMoveToParentViewController:getpmvc()];

	[UIView commitAnimations];
	
	getpmvc().back.gestureRecognizers = nil;
	getpmvc().back.hidden = YES;
}

- (UIImage*) request_image
{
    UIImage* img = nil;
    
    @try
    {
		if( is_cached([NSString stringWithFormat:@"%u-%u.png", year, month]))
		{
			img = [UIImage imageWithContentsOfFile:[GetApplicationCacheDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%u-%u.png", year, month ]]];
		}
    }
    @catch (NSException *exception) {
        NSLog(@"request_image have failed for reason: %@", exception);
    }
    @finally {
        NSLog(@"request_image have completed for year:%u, month: %u", year, month);
    }
	
	return img;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
	getpmvc().back.hidden = YES;
}
@end
