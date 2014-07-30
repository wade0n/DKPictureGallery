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
    DKPictureGalleryController *gallery;
    UIViewController *otherController;
    
    UIView *container = [transitionContext containerView];
    UIImageView *imgView;
    UIImageView *minImgView;
    UIView *whiteView;
    if (self.reverse) {
        otherController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        gallery = (DKPictureGalleryController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [container addSubview:otherController.view];
        [container insertSubview:gallery.view aboveSubview:otherController.view];
        
        if (gallery.backTransitionSet) {
            minImgView =  [[UIImageView alloc] initWithFrame:gallery.startFrame];
            imgView = [[UIImageView alloc] initWithFrame:gallery.startFrame];
            
            if (gallery.transitionMinPic) {
               
                [minImgView setImage:gallery.transitionMinPic];
            }else{
                minImgView.hidden = YES;
            }
            
            
            if (gallery.transitionImage) {
                [imgView setImage:gallery.transitionImage];
            }else{
                imgView.hidden = YES;
            }
            
            minImgView.alpha = 0.0;
            imgView.alpha = 1.0;
            
            
            [container addSubview:minImgView];
            [container addSubview:imgView];
        }
        
        gallery.view.alpha = 1.0;
   
    }
    else {
        
        gallery = (DKPictureGalleryController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        otherController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        if (gallery.transitionSet) {
            imgView = [[UIImageView alloc] initWithFrame:gallery.startFrame];
            [imgView setImage:gallery.transitionImage];
            
            whiteView = [[UIView alloc] initWithFrame:container.frame];
            whiteView.backgroundColor = [UIColor whiteColor];
            whiteView.alpha = 0.0f;
            [container addSubview:whiteView];
            [container addSubview:imgView];
        }else{
            gallery.view.transform = CGAffineTransformMakeScale(0, 0);
            [container addSubview:gallery.view];

        }

        
    }
    
    [UIView animateKeyframesWithDuration:DKAnimatedTransitionDuration delay:0 options:0 animations:^{
        if (self.reverse) {
            if (gallery.backTransitionSet) {
                [imgView setFrame:gallery.endFrame];
                [minImgView setFrame:gallery.endFrame];
                
                [imgView setAlpha:0.0f];
                [minImgView setAlpha:1.0f];
               // [whiteView setAlpha:1.0f];
            }
            
            gallery.view.alpha = 0.0;
            
            
            
        }
        else {
            if (gallery.transitionSet) {
                [imgView setFrame:gallery.endFrame];
                [whiteView setAlpha:1.0f];
                
            }else{
                gallery.view.transform = CGAffineTransformIdentity;
            }
            
            
        }
    } completion:^(BOOL finished) {
        [whiteView removeFromSuperview];
        [imgView removeFromSuperview];
        [minImgView removeFromSuperview];
        [transitionContext completeTransition:finished];
    }];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return DKAnimatedTransitionDuration;
}
@end
