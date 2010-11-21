//
// Code Source: goo.gl/e5mJ0
//

#import "ShadowView.h"

@implementation ShadowView


#define SHADOW_HEIGHT 20.0


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        
        CGFloat colors[] = {
            0.0, 0.0, 0.0, 0.5,
            1.0, 1.0, 1.0, 0.0
        };
        
        gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
        
        CGColorSpaceRelease(rgb);
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    if (rect.size.height <= 0.0 || rect.size.width <= 0.0) {
        // Not visible, nothing to be drawn.
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Setup top most gradient parameters and clipping mask.
    CGPoint startPoint = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint endPoint = CGPointMake(0.0, SHADOW_HEIGHT);
    CGRect clipRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, SHADOW_HEIGHT);
    
    // Draw top most gradient within clipped rect. Look at Quartz Demo for details.
    CGContextSaveGState(context);
    CGContextClipToRect(context, clipRect);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    // Setup bottom most gradient parameters and clipping mask. 
    startPoint = CGPointMake(rect.origin.x, rect.size.height);
    endPoint = CGPointMake(rect.origin.x, rect.size.height - SHADOW_HEIGHT);
    clipRect = CGRectMake(rect.origin.x, rect.size.height - SHADOW_HEIGHT, rect.size.width, SHADOW_HEIGHT);
    
    // Draw bottom most gradient within clipped rect. Look at Quartz Demo for details.
    CGContextSaveGState(context);
    CGContextClipToRect(context, clipRect);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
}


- (void)setFrame:(CGRect)rect {
    [super setFrame:rect];
    
    if (rect.size.height > 0.0 && rect.size.width > 0.0) {
        [self setNeedsDisplay];
    }
}


- (void)dealloc {
    CGGradientRelease(gradient);
    [super dealloc];
}


@end