//
//  pCatVC.m
//  ÇŞB E-Dergi
//
//  Created by Akın Demirtuğ on 10/2/12.
//  Copyright (c) 2012 Akın Demirtuğ. All rights reserved.
//

#import "pCatVC.h"
#import "utility.h"
#import "Catalog.h"
#import "pMainVC.h"
#import "pMagVC.h"
#import "pDLVC.h"

#import "AsyncReflection.h"


@interface pCatVC ()

@end

@implementation pCatVC

@synthesize carousel;
@synthesize info;
@synthesize server_img_path;
@synthesize isset;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	isset = NO;
	self.carousel.type = iCarouselTypeCoverFlow2;
	self.carousel.dataSource = self;
	self.carousel.delegate = self;
	getpmvc().back.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [self totalMonths];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{	
	Catalog* cat = getCat();
	int x = 0;
	
#if DEBUG
	server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi_debug/dergiler/%u-%u.png";
#else
	server_img_path = @"http://uygulamalar.csb.gov.tr/csbdergi/dergiler/%u-%u.png";
#endif
	
	NSArray* sorted_years = [[cat years] keysSortedByValueUsingComparator:^(id obj1, id obj2) {
		catalog_year* y1 = obj1;
		catalog_year* y2 = obj2;
		
		if ([y1 year] < [y2 year]) {
			return (NSComparisonResult)NSOrderedDescending;
		}
		if ([y1 year] > [y2 year]) {
			return (NSComparisonResult)NSOrderedAscending;
		}
		return (NSComparisonResult)NSOrderedSame;
	}];
	
	for(int e = 0; e < [sorted_years count]; e++)
	{
		catalog_year* cy = [[cat years] objectForKey:[sorted_years objectAtIndex:e]];
		if(x > index )
			break;
		
		NSArray* keys = [[cy months] keysSortedByValueUsingComparator:^(id obj1, id obj2) {
			catalog_month* m1 = obj1;
			catalog_month* m2 = obj2;
			
			if ([m1 month] < [m2 month]) {
				return (NSComparisonResult)NSOrderedDescending;
			}
			if ([m1 month] > [m2 month]) {
				return (NSComparisonResult)NSOrderedAscending;
			}
			return (NSComparisonResult)NSOrderedSame;
		}];
		
		bool found = false;
		for(int i = 0; i < [keys count]; i++)
		{
			if( x == index )
			{
				found = true;
				
				catalog_month* cm = [[cy months] objectForKey:[keys objectAtIndex:i]];
				
				if( isset == NO )
				{
					[self.info setText: [NSString stringWithFormat:@"%u - %@", cy.year, getMonthName([cm month])]];
					isset = YES;
				}
				view = [[AsyncReflection alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 180.0f, 240.0f)];
				((AsyncReflection*)view).infotext = [NSString stringWithFormat:@"%u - %@", cy.year, getMonthName([cm month])];
				
				((AsyncReflection*)view).year 	= cy.year;
				((AsyncReflection*)view).month 	= cm.month;
				((AsyncReflection*)view).pn 	= cm.pn;
				
				[((AsyncReflection*)view) setImageURL:
				 [NSURL URLWithString:[NSString stringWithFormat:server_img_path, [cy year], [cm month]]]];
				
				[view.layer setBorderColor: [[UIColor whiteColor] CGColor]];
				[view.layer setBorderWidth: 1.0];
				
				UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(img_tappd:)];
				[tapRecognizer setNumberOfTapsRequired:1];
				[view addGestureRecognizer:tapRecognizer];
				
				break;
			}
			x++;
		}
		if( found )
			break;
	}
	return view;
}

-(void)img_tappd:(UITapGestureRecognizer *)sender
{
	AsyncReflection* aiv = (AsyncReflection*)[carousel currentItemView];
	
    if( is_cached([NSString stringWithFormat:@"%u-%u.pdf", aiv.year, aiv.month]) )
    {
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:getpmvc().view cache:YES];
		
		[getpmvc().catv.view removeFromSuperview];
		[getpmvc().catv removeFromParentViewController];
		
		getpmvc().magv = [[pMagVC alloc]initS:aiv.year m:aiv.month];
		[getpmvc().magv.view setFrame:getpmvc().view.bounds];
		
		[getpmvc() addChildViewController:getpmvc().magv];
		[getpmvc().view insertSubview:getpmvc().magv.view atIndex:0];
		[getpmvc().magv didMoveToParentViewController:getpmvc()];
		
		[UIView commitAnimations];
    }
    else
    {
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:getpmvc().view cache:YES];
		
		[getpmvc().dlvc viewWillAppear:YES];
		
		[getpmvc().catv.view removeFromSuperview];
		[getpmvc().catv removeFromParentViewController];
		
		getpmvc().dlvc = [ [pDLVC alloc] initS:aiv.year m:aiv.month pn:aiv.pn ];

		[getpmvc() addChildViewController:getpmvc().dlvc];
		[getpmvc().view insertSubview:getpmvc().dlvc.view atIndex:0];
		[getpmvc().dlvc didMoveToParentViewController:getpmvc()];
				
		[UIView commitAnimations];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)__carousel
{
	AsyncReflection* rv = (AsyncReflection*)[__carousel currentItemView];
	[self.info setText: rv.infotext];
}

- (void)refresh
{	
	[carousel reloadData];
}

- (NSUInteger)totalMonths
{
	NSUInteger c = 0;
	
	for(catalog_year* cy in [[getCat() years] allValues] )
	{
		for (catalog_month* cm in [[cy months] allValues])
		{
			c++;
		}
	}
	return c;
}
@end
