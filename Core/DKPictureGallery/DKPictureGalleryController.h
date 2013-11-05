//
//  DKPictureGalleryController.h
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKPictureGalleryController.h"
#import "DKPictureWrapper.h"

@interface DKPictureGalleryController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate>{
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UISwipeGestureRecognizer *leftSwipeRecogn;
    UISwipeGestureRecognizer *rightSwipeRecogn;
    UIView *hintView;
    UIButton *nameLabel;
    IBOutlet    UIScrollView *scroll;
    UIImageView *currentImage;
    IBOutlet    UIActivityIndicatorView *netAct;
    BOOL imageOrientation;
    BOOL    isReadyForZoom;
    BOOL isChangingOrientation;
    BOOL isInBrowser;
    
    
    UIActionSheet *popupQuery;
    UIPopoverController *aPopoverController;
    UIActivityViewController    *activ;
    
    UIBarButtonItem *actionButton;
    
    NSMutableArray  *pics;
    
    int         picTag;
    int         picCount;
    
    CGFloat     scrollHeight;
    CGFloat     scrollWidth;
    
    NSMutableArray  *picsViews;
    NSMutableArray  *scrollViews;
    NSMutableArray  *netActs;
    
    BOOL navBarHidden;
    
    
    ///// new code ////

}

@property(nonatomic) UIInterfaceOrientation returnOrientaton;
@property(nonatomic,strong) DKPictureWrapper *picture;
@property(nonatomic, strong) NSMutableArray  *pics;
@property(nonatomic, strong) UIActivityViewController    *activity;


- (void)setCurrentPicture:(DKPictureWrapper *)pic
         AllPictures:(NSMutableArray   *)arr
        SetCurrentPosition:(int)num;


-   (id)  initWithPoster:(DKPictureWrapper *)pic;
-   (void)  setLable:(UILabel*)lable;
-   (void)  setScrollView:(UIScrollView*)tempScrollView;
-   (void)  screenTapped;
-   (void)  showNextPicture;
-   (void)  saveToAlbum;
-   (void)  confirmSave;

@end
