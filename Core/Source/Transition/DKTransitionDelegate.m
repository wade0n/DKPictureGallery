//
//  DKTransitionDelegate.m
//  PictureGallery
//
//  Created by Дмитрий Калашников on 27/06/14.
//  Copyright (c) 2014 Дмитрий Калашников. All rights reserved.
//

#import "DKTransitionDelegate.h"
#import "DKAnimationTransition.h"
@implementation DKTransitionDelegate


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    DKAnimationTransition *transitioning = [DKAnimationTransition new];
    return transitioning;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    DKAnimationTransition *transitioning = [DKAnimationTransition new];
    transitioning.reverse = YES;
    return transitioning;
}
@end
