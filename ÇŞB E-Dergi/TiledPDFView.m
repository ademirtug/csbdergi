#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TiledPDFView
{
    CGPDFPageRef pdfPage;
    CGFloat myScale;
}


- (id)initWithFrame:(CGRect)frame scale:(CGFloat)scale
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];

        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 3;
        tiledLayer.tileSize = CGSizeMake(512.0, 512.0);
        
        myScale = scale;
    }
    return self;
}

+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (void)setPage:(CGPDFPageRef)newPage
{
    CGPDFPageRelease(self->pdfPage);
    self->pdfPage = CGPDFPageRetain(newPage);
}

-(void)drawRect:(CGRect)r
{
}

-(void)drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
    
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context, CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height) );
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
   
    CGContextScaleCTM(context, myScale, myScale);    
    CGContextDrawPDFPage(context, pdfPage);
    CGContextRestoreGState(context);
}


- (void)dealloc
{
    CGPDFPageRelease(pdfPage);    
}


@end
