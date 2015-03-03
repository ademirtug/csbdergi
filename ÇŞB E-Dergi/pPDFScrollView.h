#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface pPDFScrollView : UIScrollView <UIScrollViewDelegate>

- (void)setPDFPage:(CGPDFPageRef)PDFPage;
@end
