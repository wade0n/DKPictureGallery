//
//  UIView+DKExtensions.h
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DKExtensions)

// screen convinience methods
+(CGRect)getScreenframeForCurrentOrientation;
+(CGRect)getScreenframeForOrientation:(UIInterfaceOrientation)_orientation;
@end
