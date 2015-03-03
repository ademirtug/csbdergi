#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>


@interface PDFScrollView ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) TiledPDFView *tiledPDFView;
@property (nonatomic, weak) TiledPDFView *oldTiledPDFView;

@end



@implementation PDFScrollView
{
    CGPDFPageRef _PDFPage;
    CGFloat _PDFScale;
}

@synthesize backgroundImageView=_backgroundImageView, tiledPDFView=_tiledPDFView, oldTiledPDFView=_oldTiledPDFView;



- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = NO;
		self.bounces = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor whiteColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = 0.5;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    }
    return self;
}

- (void)setPDFPage:(CGPDFPageRef)PDFPage;
{
    CGPDFPageRetain(PDFPage);
    CGPDFPageRelease(_PDFPage);
    _PDFPage = PDFPage;

    CGRect pageRect = CGPDFPageGetBoxRect(_PDFPage, kCGPDFMediaBox);
    _PDFScale = self.frame.size.width/pageRect.size.width;

    pageRect.size = CGSizeMake(pageRect.size.width*_PDFScale, pageRect.size.height*_PDFScale);
    
    
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    
    CGContextSaveGState(context);
	
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    

    CGContextScaleCTM(context, _PDFScale,_PDFScale);    
    CGContextDrawPDFPage(context, _PDFPage);
    CGContextRestoreGState(context);
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    if (self.backgroundImageView != nil) {
        [self.backgroundImageView removeFromSuperview];
    }
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.frame = pageRect;
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    TiledPDFView *tiledPDFView = [[TiledPDFView alloc] initWithFrame:pageRect scale:_PDFScale];
    [tiledPDFView setPage:_PDFPage];
    
    [self addSubview:tiledPDFView];
    self.tiledPDFView = tiledPDFView;
}


- (void)dealloc
{
    CGPDFPageRelease(_PDFPage);
}


#pragma mark -
#pragma mark Override layoutSubviews to center content


- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.tiledPDFView.frame;
    
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.tiledPDFView.frame = frameToCenter;
    self.backgroundImageView.frame = frameToCenter;
    
    self.tiledPDFView.contentScaleFactor = 1.0;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.tiledPDFView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	float scale = self.bounds.size.width / view.frame.size.width;
	
	[self setMinimumZoomScale:scale];
	

    [self.oldTiledPDFView removeFromSuperview];
    

    self.oldTiledPDFView = self.tiledPDFView;
    [self addSubview:self.oldTiledPDFView];
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{

    _PDFScale *= scale;
    

    CGRect pageRect = CGPDFPageGetBoxRect(_PDFPage, kCGPDFMediaBox);
    pageRect.size = CGSizeMake(pageRect.size.width*(_PDFScale*0.96), pageRect.size.height*_PDFScale);
    

    TiledPDFView *tiledPDFView = [[TiledPDFView alloc] initWithFrame:pageRect scale:_PDFScale];
    [tiledPDFView setPage:_PDFPage];
    

    [self addSubview:tiledPDFView];
    self.tiledPDFView = tiledPDFView;
}


@end
