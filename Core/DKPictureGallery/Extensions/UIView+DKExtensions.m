//
//  UIView+DKExtensions.m
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import "UIView+DKExtensions.h"

@implementation UIView (DKExtensions)

+(CGRect)getScreenframeForCurrentOrientation
{
    return [UIView getScreenframeForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

+(CGRect)getScreenframeForOrientation:(UIInterfaceOrientation)_orientation
{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds; //implicitly in Portrait orientation.
    
    if (UIInterfaceOrientationIsLandscape(_orientation))
    {
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    return fullScreenRect;
}
@end
