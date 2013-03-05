#import "CMViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PathDrawingView.h"

@implementation CMViewController

static NSString *cAnimationKey = @"pathAnimation";

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
        [self stop];
}

- (void) stop
{
    CALayer *pLayer = _image.layer.presentationLayer;
    CGPoint currentPos = pLayer.position;
    [_image.layer removeAnimationForKey:cAnimationKey];
    _image.center = currentPos;
    _isAnimating = NO;
}

- (void) followThePath:(CGPathRef) path
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = 2.0f;
    pathAnimation.delegate = self;
    pathAnimation.calculationMode = kCAAnimationPaced;
    [_image.layer addAnimation:pathAnimation forKey:cAnimationKey];
}

- (CGPathRef) pathToPoint:(CGPoint) point
{
    CGPoint imagePos = _image.center;
    CGFloat xDist = (point.x - imagePos.x);
    CGFloat yDist = (point.y - imagePos.y);
    CGFloat radius = sqrt((xDist * xDist) + (yDist * yDist)) / 2;
    
    CGPoint center = CGPointMake(imagePos.x + radius, imagePos.y);
    CGFloat angle = atan2f(yDist, xDist);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, imagePos.x, imagePos.y);
    transform = CGAffineTransformRotate(transform, angle);
    transform = CGAffineTransformTranslate(transform, -imagePos.x, -imagePos.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, &transform, center.x, center.y, radius, M_PI, 0, YES);
    //CGPathAddArc(path, &transform, center.x, center.y, radius, 0, M_PI, YES);
    return path;
}

- (void) drawPath:(CGPathRef) path
{
    [self.pathView removeFromSuperview];
    self.pathView = [[PathDrawingView alloc] init];
    self.pathView.path = path;
    self.pathView.frame = self.view.frame;
    [self.view addSubview:self.pathView];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isAnimating)
        [self stop];
    _isAnimating = YES;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPathRef path = [self pathToPoint:touchPoint];
    [self followThePath:path];
    if (_drawPath)
        [self drawPath:path];
    
    CGPathRelease(path);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    _drawPath = NO;
    _isAnimating = NO;
	_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image.png"]];
    _image.center = CGPointMake(160, 240);
    [self.view addSubview:_image];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidUnload
{
    [_image release];
    self.pathView = nil;
}

@end
