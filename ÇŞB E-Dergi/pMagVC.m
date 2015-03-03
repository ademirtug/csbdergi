//
//  ViewController.m
//  UIPageViewControllerDemo
//
//  Created by Uppal'z on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "pMagVC.h"
#import "pPPVC.h"
#import "utility.h"
#import "pMainVC.h"
#import "pCatVC.h"

@implementation pMagVC
@synthesize pageViewController;
@synthesize pdf_path;
@synthesize pdf;
@synthesize pdfURL;
@synthesize year, month;

- (id)initS:(NSUInteger)_year m:(NSUInteger)_month
{
    self = [super initWithNibName:@"MagVC" bundle:Nil];
    if (self) {
		year = _year;
		month = _month;
		pdf_path = [GetApplicationCacheDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%u-%u.pdf", year, month ]];
		pdfURL = (__bridge_retained CFURLRef)[[NSURL alloc] initFileURLWithPath:pdf_path];
		pdf = CGPDFDocumentCreateWithURL(pdfURL);
    }
    return self;
}

- (void)dealloc{
	CFBridgingRelease(pdfURL);
	CFBridgingRelease(pdf);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIPageViewControllerDataSource Methods


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
	NSUInteger pc = CGPDFDocumentGetNumberOfPages(pdf);
	if( index >= pc )
		return Nil;
	
	
	pPPVC* ppvc = [[pPPVC alloc] initS:index  pdfref:pdf];
	return ppvc;
}

- (NSUInteger)indexOfViewController:(pPPVC *)ppvc
{
	return ppvc.sayfa;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerBeforeViewController:(UIViewController *)cur_ppvc;
{
	int ci = ((pPPVC*)cur_ppvc).sayfa;
	
	if( ci <= 1 && self.pageViewController.doubleSided == NO )
		return Nil;
	
	pPPVC* ppvc = [self viewControllerAtIndex:((pPPVC*)cur_ppvc).sayfa-1];
	return ppvc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	   viewControllerAfterViewController:(UIViewController *)cur_ppvc
{
	pPPVC* ppvc = [self viewControllerAtIndex:((pPPVC*)cur_ppvc).sayfa+1];
	return ppvc;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	getpmvc().back.hidden = NO;
	

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl 
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
 
	UIViewController *p1 = [self viewControllerAtIndex:1];
	NSArray *viewControllers = [NSArray arrayWithObject:p1];	
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    

    [self addChildViewController:self.pageViewController];
    
  
    [self.view addSubview:self.pageViewController.view];


    [self.pageViewController didMoveToParentViewController:self];    


    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 2, 2);
    self.pageViewController.view.frame = pageViewRect;
    
 
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
	
	getpmvc().back.hidden = NO;
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nav_back:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[getpmvc().back addGestureRecognizer:tapRecognizer];

}
-(void)nav_back:(UITapGestureRecognizer *)sender
{
	[getpmvc().catv.view setFrame:CGRectMake(0, 0, getpmvc().view.bounds.size.width, getpmvc().view.bounds.size.height)];
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:getpmvc().view cache:YES];
	
	[getpmvc().magv.view removeFromSuperview];
	[getpmvc().magv removeFromParentViewController];
	
	[getpmvc() addChildViewController:getpmvc().catv];
	[getpmvc().view addSubview:getpmvc().catv.view];
	[getpmvc().catv didMoveToParentViewController:getpmvc()];
	
	
	[UIView commitAnimations];
	
	getpmvc().magv = Nil;
	getpmvc().back.gestureRecognizers = nil;
	getpmvc().back.hidden = YES;
}


@end
