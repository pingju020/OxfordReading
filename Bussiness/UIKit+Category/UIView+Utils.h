//
//  UIView+Utils.h
//  KKMY_U
//
//  Created by yangjuanping on 15/2/13.
//  Copyright (c) 2015年 Rogrand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

- (void)setCornerRound:(float)aRound;

+ (instancetype)allocView;
/**
 *  在 view 上画虚线，制定颜色和位置
 *
 *  @param lineColor  虚线颜色
 *  @param startPoint 开始位置
 *  @param endPoint   结束位置
 */
- (void)drawStrokeLine:(UIColor *)lineColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/**
 在视图上画指定角的圆弧，可同时指定多个角
 @param rect 指定的rect
 @param corners 指定的角
 */
- (void)drawCornerWithRect:(CGRect)rect roundingCorners:(UIRectCorner)corners;
/**
 在视图上画指定角的圆弧，可同时指定多个角
 
 @param corners 指定的角
 */
- (void)drawCornerWithRoundingCorners:(UIRectCorner)corners;

/**
 在视图上画指定角的圆弧，可同时指定多个角
 
 @param corners 指定的角
 */
- (void)drawCornerWithRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
/**
 *  创建一张实时模糊效果 View (毛玻璃效果)
 *
 *  @param frame frame
 *
 *  @return effectView
 */
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;
@end
