
//  UIColor+Chameleon.m

/*
 
 The MIT License (MIT)
 
 Copyright (c) 2014-2015 Vicc Alexander.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

#import "UIColor+Chameleon.h"
#import <objc/runtime.h>

@implementation UIColor (Chameleon)

#pragma mark - Chameleon - Light Shades

+ (UIColor *)flatBlackColor {
    return hsb(0, 0, 17);
}

+ (UIColor *)flatBlueColor {
    return hsb(224, 50, 63);
}

+ (UIColor *)flatBrownColor {
    return hsb(24, 45, 37);
}

+ (UIColor *)flatCoffeeColor {
    return hsb(25, 31, 64);
}

+ (UIColor *)flatForestGreenColor {
    return hsb(138, 45, 37);
}

+ (UIColor *)flatGrayColor {
    return hsb(184, 10, 65);
}

+ (UIColor *)flatGreenColor {
    return hsb(145, 77, 80);
}

+ (UIColor *)flatLimeColor {
    return hsb(74, 70, 78);
}

+ (UIColor *)flatMagentaColor {
    return hsb(283, 51, 71);
}

+ (UIColor *)flatMaroonColor {
    return hsb(5, 65, 47);
}

+ (UIColor *)flatMintColor {
    return hsb(168, 86, 74);
}

+ (UIColor *)flatNavyBlueColor {
    return hsb(210, 45, 37);
}

+ (UIColor *)flatOrangeColor {
    return hsb(28, 85, 90);
}

+ (UIColor *)flatPinkColor {
    return hsb(324, 49, 96);
}

+ (UIColor *)flatPlumColor {
    return hsb(300, 45, 37);
}

+ (UIColor *)flatPowderBlueColor {
    return hsb(222, 24, 95);
}

+ (UIColor *)flatPurpleColor {
    return hsb(253, 52, 77);
}

+ (UIColor *)flatRedColor {
    return hsb(6, 74, 91);
}

+ (UIColor *)flatSandColor {
    return hsb(42, 25, 94);
}

+ (UIColor *)flatSkyBlueColor {
    return hsb(204, 76, 86);
}

+ (UIColor *)flatTealColor {
    return hsb(195, 55, 51);
}

+ (UIColor *)flatWatermelonColor {
    return hsb(356, 53, 94);
}

+ (UIColor *)flatWhiteColor {
    return hsb(192, 2, 95);
}

+ (UIColor *)flatYellowColor {
    return hsb(48, 99, 100);
}

#pragma mark - Chameleon - Dark Shades

+ (UIColor *)flatBlackColorDark {
    return hsb(0, 0, 15);
}

+ (UIColor *)flatBlueColorDark {
    return hsb(224, 56, 51);
}

+ (UIColor *)flatBrownColorDark {
    return hsb(25, 45, 31);
}

+ (UIColor *)flatCoffeeColorDark {
    return hsb(25, 34, 56);
}

+ (UIColor *)flatForestGreenColorDark {
    return hsb(135, 44, 31);
}

+ (UIColor *)flatGrayColorDark {
    return hsb(184, 10, 55);
}

+ (UIColor *)flatGreenColorDark {
    return hsb(145, 78, 68);
}

+ (UIColor *)flatLimeColorDark {
    return hsb(74, 81, 69);
}

+ (UIColor *)flatMagentaColorDark {
    return hsb(282, 61, 68);
}

+ (UIColor *)flatMaroonColorDark {
    return hsb(4, 68, 40);
}

+ (UIColor *)flatMintColorDark {
    return hsb(168, 86, 63);
}

+ (UIColor *)flatNavyBlueColorDark {
    return hsb(210, 45, 31);
}

+ (UIColor *)flatOrangeColorDark {
    return hsb(24, 100, 83);
}

+ (UIColor *)flatPinkColorDark {
    return hsb(327, 57, 83);
}

+ (UIColor *)flatPlumColorDark {
    return hsb(300, 46, 31);
}

+ (UIColor *)flatPowderBlueColorDark {
    return hsb(222, 28, 84);
}

+ (UIColor *)flatPurpleColorDark {
    return hsb(253, 56, 64);
}

+ (UIColor *)flatRedColorDark {
    return hsb(6, 78, 75);
}

+ (UIColor *)flatSandColorDark {
    return hsb(42, 30, 84);
}

+ (UIColor *)flatSkyBlueColorDark {
    return hsb(204, 78, 73);
}

+ (UIColor *)flatTealColorDark {
    return hsb(196, 54, 45);
}

+ (UIColor *)flatWatermelonColorDark {
    return hsb(358, 61, 85);
}

+ (UIColor *)flatWhiteColorDark {
    return hsb(204, 5, 78);
}

+ (UIColor *)flatYellowColorDark {
    return hsb(40, 100, 100);
}
@end
