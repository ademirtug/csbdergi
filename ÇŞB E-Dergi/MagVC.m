//
//  ViewController.m
//  UIPageViewControllerDemo
//
//  Created by Uppal'z on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MagVC.h"
#import "utility.h"
#import "MainVC.h"
#import "PDFScrollView.h"
#import "EPPVC.h"

@implementation MagVC
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

#pragma mark - UIPageViewControllerDataSource Methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
	if(index == 0 )
	{
		EPPVC* ppvc = [[EPPVC alloc]init];
		return ppvc;
	}
	NSUInteger pc = CGPDFDocumentGetNumberOfPages(pdf);
	if( index >= pc )
		return Nil;


	PPVC* ppvc = [[PPVC alloc] initS:index  pdfref:pdf];
	return ppvc;
}

- (NSUInteger)indexOfViewController:(PPVC *)ppvc
{
	return ppvc.sayfa;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerBeforeViewController:(UIViewController *)cur_ppvc;
{
	int ci = ((PPVC*)cur_ppvc).sayfa;
	
	if( ci <= 1 && self.pageViewController.doubleSided == NO )
		return Nil;
	
	PPVC* ppvc = [self viewControllerAtIndex:((PPVC*)cur_ppvc).sayfa-1];
	return ppvc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	   viewControllerAfterViewController:(UIViewController *)cur_ppvc
{
	PPVC* ppvc = [self viewControllerAtIndex:((PPVC*)cur_ppvc).sayfa+1];
	return ppvc;
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController
                   spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
		
		PPVC* cp = (PPVC*)currentViewController;
		if(cp.sayfa == 0)
			currentViewController = [self viewControllerAtIndex:1];
		
        NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
		
		[((PPVC*)currentViewController) setupView:CGRectMake(0, 0, 768, 1004)];
		

        self.pageViewController.doubleSided = NO;
        
        return UIPageViewControllerSpineLocationMin;
    }
    else
    {
        NSArray *viewControllers = self.pageViewController.viewControllers;
		
        UIViewController *currentViewController = [self.pageViewController.viewControllers objectAtIndex:0];
		[((PPVC*)currentViewController) setupView:CGRectMake(0, 0, 1024/2, 748)];
		
        NSUInteger currentIndex = ((PPVC *)currentViewController).sayfa;
		
		if(currentIndex == 1)
		{
			currentViewController = [self viewControllerAtIndex:0];
			//[((PPVC*)currentViewController) setupView:CGRectMake(0, 0, 1024/2, 748)];
			
			UIViewController *nextViewController = [self viewControllerAtIndex:1];
			[((PPVC*)nextViewController) setupView:CGRectMake(0, 0, 1024/2, 748)];
			
			viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
		}
		else if(currentIndex %2 == 1)
        {
            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            [((PPVC*)previousViewController) setupView:CGRectMake(0, 0, 1024/2, 748)];
			viewControllers = [NSArray arrayWithObjects:previousViewController, currentViewController, nil];
        }
        else
        {
			UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            [((PPVC*)nextViewController) setupView:CGRectMake(0, 0, 1024/2, 748)];
			viewControllers = [NSArray arrayWithObjects:currentViewController, nextViewController, nil];
        }
		

        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
		self.pageViewController.doubleSided = YES;
        return UIPageViewControllerSpineLocationMid;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.frame = getmvc().view.bounds;
	
	
	NSDictionary *options = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey] : nil;
	
 
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl                                                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageViewController.view.frame = getmvc().view.bounds;

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    

	NSArray *viewControllers = Nil;
	UIViewController *p1 = Nil;
	if( (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) )
	{
		p1 = [[EPPVC alloc]init];
		UIViewController *p2 = [self viewControllerAtIndex:1];
		viewControllers = [NSArray arrayWithObjects:p1, p2, nil];
		self.pageViewController.doubleSided = YES;
	}
	else
	{
		p1 = [self viewControllerAtIndex:1];
		viewControllers = [NSArray arrayWithObject:p1];
	}

    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO 
                                     completion:nil];
    
    [self addChildViewController:self.pageViewController];
    
    [self.view addSubview:self.pageViewController.view];

    [self.pageViewController didMoveToParentViewController:self];
    
	self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
	
	getmvc().back.hidden = NO;
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nav_back:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[getmvc().back addGestureRecognizer:tapRecognizer];
}

-(void)nav_back:(UITapGestureRecognizer *)sender
{

	[getmvc().catv.view setFrame:CGRectMake(0, 0, getmvc().view.bounds.size.width, getmvc().view.bounds.size.height)];
	[getmvc().catv rearrange:getmvc().view.bounds.size.width-360];
		
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:getmvc().view cache:YES];
		
	[getmvc().magvc viewWillDisappear:YES];
	[getmvc().catv viewWillAppear:YES];
		
		
	[getmvc() addChildViewController:getmvc().catv];
	[getmvc().view addSubview:getmvc().catv.view];
	[getmvc().catv didMoveToParentViewController:getmvc()];
		
		
	[getmvc().magvc.view removeFromSuperview];
		
	[getmvc().magvc viewDidDisappear:YES];
	[getmvc().catv viewDidAppear:YES];
		
	[UIView commitAnimations];
	
	getmvc().magvc = Nil;
	getmvc().back.gestureRecognizers = nil;
	getmvc().back.hidden = YES;
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
