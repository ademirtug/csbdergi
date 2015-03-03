//
//  csbCatVC.m
//  edergi
//
//  Created by Akın Demirtuğ on 7/20/12.
//  Copyright (c) 2012 Çevre ve Şehircilik Bakanlığı. All rights reserved.
//

#import "CatVC.h"
#import "utility.h"


@interface CatVC ()

@end

@implementation CatVC
@synthesize pagingScrollView;
@synthesize cat;
@synthesize list_cit;

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self refresh];
}

- (void)setupview
{
	cat = getCat();
	
	list_cit = [[NSMutableArray alloc]init];
    
    pagingScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    pagingScrollView.pagingEnabled = NO;
	pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.delegate = self;
	
    self.view = pagingScrollView;
    
	NSUInteger x = 10;
	NSUInteger y = 0;
	BOOL isl = YES;
    
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

        
		for(int i = 0; i < [keys count]; i++) 
		{
			catalog_month* cm = [[cy months] objectForKey:[keys objectAtIndex:i]]; 
			CatItem* cit = [[CatItem alloc] initS:[cy year] ay:[cm month] dn:[cm pn]];
            
			[list_cit addObject:cit];
			
			[[cit view] setFrame: CGRectMake(x, 10 + ( 310 * y ), 350 , 275)];
			
			if( x == 10 )
			{
				CGRect bounds = pagingScrollView.bounds;
				x = bounds.size.width - 360;
			}
			else 
            {
				x = 10;
			}
            
			y = isl ? y : y+1;
			isl = !isl;
			
			[pagingScrollView addSubview:cit.view];
		}
	}
}

- (void)refresh
{
	if( [self.view subviews] != Nil )
	{
		for (int i = 0; i < [[self.view subviews] count]; i++ ) {
			[[[self.view subviews] objectAtIndex:i] removeFromSuperview];
		}
	}	
	[self setupview];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	NSLog(@"willrotate....");

	int x = 768-360;
	if( UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
		x = 1004 - 360;

	[self rearrange:x];

}

-(void)rearrange:(int) xpos
{
	if( [self.view subviews] != Nil )
	{
		for (int i = 0; i < [[self.view subviews] count]; i++ ) {
			if(i & 1)
			{
				UIView* cover = [[self.view subviews] objectAtIndex:i];
				CGRect cf = cover.frame;
				[cover setFrame:CGRectMake(xpos, cf.origin.y, 350, 275)];
			}
		}
	}
}

- (CGSize)contentSizeForPagingScrollView {
	CGRect bounds = pagingScrollView.bounds;
	return CGSizeMake(bounds.size.width, 10+(310 * [self imageCount]));
}

- (NSUInteger)totalMonths
{
	NSUInteger c = 0;
	
	for(catalog_year* cy in [[cat years] allValues] )
	{
		for (catalog_month* cm in [[cy months] allValues]) 
		{
			c++;
		}
	}
	return c;
}

- (NSUInteger)imageCount {
	NSUInteger c = [self totalMonths];
	
	if( c == 0 )
		return 1;
	else if( c & 1 )
		return (c/2)+1;
	else
		return c/2;
}

@end
