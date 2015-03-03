#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PDFScrollView : UIScrollView <UIScrollViewDelegate> 

- (void)setPDFPage:(CGPDFPageRef)PDFPage;
@end
