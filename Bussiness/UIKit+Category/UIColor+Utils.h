//
//  UIColor+Utils.h
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2012年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define HexRGB(hex)             [UIColor colorFromHexRGB:(hex)]
#define RGBA(r,g,b,a)			[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define RGB(r,g,b)				RGBA(r,g,b,1)
@interface UIColor (Utils)

/**
 *	@brief	RGB值转换为UIColor对象
 *
 *	@param 	inColorString 	RGB值，如“＃808080”这里只需要传入“808080”
 *
 *	@return	UIColor对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
