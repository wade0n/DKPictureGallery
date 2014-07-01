//
//  DKAnimationTransition.m
//  Pods
//
//  Created by Дмитрий Калашников on 27/06/14.
//
//

#import "DKAnimationTransition.h"
#import "DKPictureGalleryController.h"


static NSTimeInterval const DKAnimatedTransitionDuration = 0.5f;
static NSTimeInterval const DKAnimatedTransitionDurationForMarco = 0.15f;

@implementation DKAnimationTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DKPictureGalleryController *toViewController = (DKPictureGalleryController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    UIImageView *imgView;
    UIView *whiteView;
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    }
    else {
        if (toViewController.transitionSet) {
            imgView = [[UIImageView alloc] initWithFrame:toViewController.startFrame];
            [imgView setImage:toViewController.transitionImage];
            
            whiteView = [[UIView alloc] initWithFrame:container.frame];
            whiteView.backgroundColor = [UIColor whiteColor];
            whiteView.alpha = 0.0f;
            [container addSubview:whiteView];
            [container addSubview:imgView];
        }else{
            toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
            [container addSubview:toViewController.view];

        }

        
    }
    
    [UIView animateKeyframesWithDuration:DKAnimatedTransitionDuration delay:0 options:0 animations:^{
        if (self.reverse) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        }
        else {
            if (toViewController.transitionSet) {
                [imgView setFrame:toViewController.endFrame];
                [whiteView setAlpha:1.0f];
                
            }else{
                toViewController.view.transform = CGAffineTransformIdentity;
            }
            
            
        }
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
        [imgView removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return DKAnimatedTransitionDuration;
}
@end
