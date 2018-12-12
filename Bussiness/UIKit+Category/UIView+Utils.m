//
//  UIView+Utils.m
//  KKMY_U
//
//  Created by yangjuanping on 15/2/13.
//  Copyright (c) 2015年 Rogrand. All rights reserved.
//

#import "UIView+Utils.h"
#import <objc/runtime.h>


@implementation UIView (Utils)

- (void)setCornerRound:(float)aRound
{
    self.layer.cornerRadius = aRound;
    self.layer.masksToBounds = YES;
}

+ (instancetype)viewFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self  options:nil] objectAtIndex:0];
}

+ (instancetype)allocView
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:NSStringFromClass([self class]) ofType:@"nib"];
    if (filePath.length > 0) {
        return [self viewFromNib];
    } else {
        return [[super alloc] init];
    }
}
- (void)drawStrokeLine:(UIColor *)lineColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	[shapeLayer setBounds:self.bounds];
	[shapeLayer setPosition:CGPointMake((endPoint.x-startPoint.x)/2, (endPoint.y-startPoint.y)/2)];
	[shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
 // 设置虚线颜色为blackColor
	[shapeLayer setStrokeColor:[lineColor CGColor]];
 // 3.0f设置虚线的宽度
	[shapeLayer setLineWidth:1.0f];
	[shapeLayer setLineJoin:kCALineJoinRound];
 // 1=线的宽度 1=每条线的间距
	[shapeLayer setLineDashPattern:
	[NSArray arrayWithObjects:[NSNumber numberWithInt:1],
	 [NSNumber numberWithInt:2],nil]];
	// Setup the path
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, startPoint.x,startPoint.y);
	CGPathAddLineToPoint(path, NULL, endPoint.x,endPoint.y);
 
	[shapeLayer setPath:path];
	CGPathRelease(path);
	[[self layer] addSublayer:shapeLayer];
 // 可以把self改成任何你想要的UIView, 下图演示就是放到UITableViewCell中的 [[self layer] addSublayer:shapeLa
}
/**
 在视图上画指定角的圆弧，可同时指定多个角
 @param rect 指定的rect
 @param corners 指定的角
 */
- (void)drawCornerWithRect:(CGRect)rect roundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/**
 在视图上画指定角的圆弧，可同时指定多个角

 @param corners 指定的角
 */
- (void)drawCornerWithRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
/**
 在视图上画指定角的圆弧，可同时指定多个角
 
 @param corners 指定的角
 */
- (void)drawCornerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    [maskLayer setMasksToBounds:NO];
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}
/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 *
 *  @param frame frame
 *
 *  @return effectView
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    if(__CUR_IOS_VERSION>=80000){
        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = frame;
        return effectView;
    }else{
        return nil;
    }
}

@end
