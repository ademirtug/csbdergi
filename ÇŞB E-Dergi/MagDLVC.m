//
//  csbMagDLVCViewController.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/25/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "MagDLVC.h"
#import "utility.h"
#import "MainVC.h"
#import "MagVC.h"
#import <QuartzCore/QuartzCore.h>

@interface MagDLVC ()

@end


@implementation MagDLVC

@synthesize lbl_year, lbl_filesize, lbl_issue, lbl_month, lbl_progress;
@synthesize cover;
@synthesize dl;
@synthesize vmag;
@synthesize cancel;
@synthesize progress;
@synthesize year, month, pub_num, filesize;
@synthesize cnn;
@synthesize request;
@synthesize pdf;
@synthesize server_pdf_path;


- (id)initS:(NSUInteger)_year m:(NSUInteger)_month pn:(NSUInteger)_pn
{
    self = [super initWithNibName:@"MagDLVC" bundle:Nil];
    if (self) {
        // Custom initialization
		year = _year;
		month = _month;
		pub_num = _pn;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dl_click:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[dl addGestureRecognizer:tapRecognizer];
	
	UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nav_back:)];
	[tapRecognizer2 setNumberOfTapsRequired:1];
	[getmvc().back addGestureRecognizer:tapRecognizer2];

	UITapGestureRecognizer *tapRecognizer3= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vmag_click:)];
	[tapRecognizer3 setNumberOfTapsRequired:1];
	[vmag addGestureRecognizer:tapRecognizer3];
	
	
	UITapGestureRecognizer *tapRecognizer4= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel_click:)];
	[tapRecognizer4 setNumberOfTapsRequired:1];
	[cancel addGestureRecognizer:tapRecognizer4];	
	
	cover.image = [self request_image];
	getmvc().back.hidden = NO;
	
	filesize = [getMonth(year, month) filesize];
	
	lbl_year.text = [NSString stringWithFormat:@"%u", year];
	lbl_issue.text = [NSString stringWithFormat:@"Sayı %u", pub_num];
	lbl_filesize.text = [NSString stringWithFormat:@"Boyut: %uKB", filesize/1024];
	lbl_month.text = getMonthName(month);
	
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
	
#if DEBUG
	server_pdf_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/dergiler/%u-%u.pdf";
#else
	server_pdf_path = @"http://uygulamalar.csb.gov.tr/csbdergi/dergiler/%u-%u.pdf";
#endif
	
	@try {
		pdf = [[NSMutableData alloc] init];
		request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: server_pdf_path, year, month] ] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
		
		cnn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
		if (cnn) {
			dl.hidden = YES;
			progress.hidden = NO;
			lbl_progress.hidden = NO;
			cancel.hidden = NO;
			getmvc().back.hidden = YES;
		}
	}
	@catch (NSException *exception){
	}
	@finally{
	}
}

-(void)vmag_click:(UITapGestureRecognizer *)sender
{
	@try 
	{
		getmvc().magvc = [[MagVC alloc] initS:year m:month];
		[getmvc().magvc.view setFrame:getmvc().view.bounds];
		
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:getmvc().view cache:YES];
		
		[getmvc().dlvc viewWillDisappear:YES];
		[getmvc().magvc viewWillAppear:YES];
		
		[getmvc().dlvc.view removeFromSuperview];
		[getmvc().catv removeFromParentViewController];
		
		[getmvc() addChildViewController:getmvc().magvc];
		[getmvc().view insertSubview:getmvc().magvc.view atIndex:0];
		[getmvc().magvc didMoveToParentViewController:getmvc()];
		
		
		[getmvc().dlvc viewDidDisappear:YES];
		[getmvc().magvc viewDidAppear:YES];
		
		[UIView commitAnimations];
	}
	@catch (NSException * e) {
		NSLog(@"");
	}	
}

-(void)cancel_click:(UITapGestureRecognizer *)sender
{
	@try 
	{
		[cnn cancel];
		[lbl_progress setText:[NSString stringWithFormat:@"0 KB / %u KB", (filesize / 1024)]];
		[progress setProgress: 0];
		
		progress.hidden = YES;
		lbl_progress.hidden = YES;
		
		cancel.hidden = YES;
		dl.hidden = NO;
		getmvc().back.hidden = NO;
	}
	@catch (NSException * e) {
		NSLog(@"");
	}	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)_data 
{
	[pdf appendData:_data];
	
	[lbl_progress setText:[NSString stringWithFormat:@"%u KB / %u KB", ([pdf length] / 1024), (filesize / 1024)]];
	
	[progress setProgress: ((float)[pdf length] / (float)filesize )];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"file download is complete, bytes received is %u",[pdf length]);
	
	dl.hidden = YES;
	vmag.hidden = NO;
	cancel.hidden = YES;
	getmvc().back.hidden = NO;
	
	save_mag(pdf, [NSString stringWithFormat:@"%u-%u.pdf", year, month] );
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	dl.hidden = NO;
	cancel.hidden = YES;
	getmvc().back.hidden = NO;
	
	NSLog(@"Connection failed! Error - %@",[error localizedDescription]);

	cnn = nil;
	request = nil;
	pdf = nil;
}

-(void)nav_back:(UITapGestureRecognizer *)sender
{

		[getmvc().catv.view setFrame:CGRectMake(0, 0, getmvc().view.bounds.size.width, getmvc().view.bounds.size.height)];
		[getmvc().catv rearrange:getmvc().view.bounds.size.width-360];
		
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:getmvc().view cache:YES]; 
		
		[getmvc().dlvc viewWillDisappear:YES];
		[getmvc().catv viewWillAppear:YES];


		[getmvc() addChildViewController:getmvc().catv];
		[getmvc().view addSubview:getmvc().catv.view];
		[getmvc().catv didMoveToParentViewController:getmvc()];
		
		
		[getmvc().dlvc.view removeFromSuperview];
		
		[getmvc().dlvc viewDidDisappear:YES];
		[getmvc().catv viewDidAppear:YES];
		
		[UIView commitAnimations];
		
		getmvc().back.gestureRecognizers = nil;
		getmvc().back.hidden = YES;	
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
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	getmvc().back.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
