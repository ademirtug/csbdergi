#import <UIKit/UIKit.h>


@interface TiledPDFView : UIView

- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale;
- (void)setPage:(CGPDFPageRef)newPage;

@end
