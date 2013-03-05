#import <UIKit/UIKit.h>

@interface PathDrawingView : UIView
{
    CGPathRef   _path;
}

@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGPathRef path;

@end
