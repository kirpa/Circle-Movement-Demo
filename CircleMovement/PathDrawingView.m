#import "PathDrawingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PathDrawingView

@synthesize strokeColor, fillColor;

- (CGPathRef) path
{
    return _path;
}

- (void) setPath:(CGPathRef)path
{
    CGPathRelease(_path);
    _path = CGPathRetain(path);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextAddPath(ctx, _path);
    CGContextStrokePath(ctx);
}

- (id) init
{
    if (self = [super init])
    {
        self.fillColor = [UIColor clearColor];
        self.strokeColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) dealloc
{
    self.fillColor = nil;
    self.strokeColor = nil;
    CGPathRelease(_path);
    [super dealloc];
}


@end
