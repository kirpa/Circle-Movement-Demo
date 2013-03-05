#import <UIKit/UIKit.h>

@class PathDrawingView;

@interface CMViewController : UIViewController
{
    UIImageView     *_image;
    BOOL            _isAnimating;
    BOOL            _drawPath;
}

@property (retain, nonatomic) PathDrawingView *pathView;

@end
