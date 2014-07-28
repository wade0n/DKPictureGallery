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
#import "AMBLurView.h"

@class DKPictureScroll;



@protocol DKPictureGalleryDataSource <NSObject>   //define delegate protocol
- (NSInteger)numberOfPictures;
- (NSDictionary *)dictinaryForItem:(NSInteger)itemPosition;
- (NSString *)textForItem:(NSInteger)itemPosition;
//define delegate method to be implemented within another class
@end //end protocol

@protocol DKPictureGalleryDelegate <NSObject>
- (void)changePictureToItem:(NSInteger)itemPosition;
- (UIImage *)getImageBackFromDismissTransition;
- (void)didSelectPictureAtPosition:(int)position Sender:(id)sender;
@end

@interface DKPictureGalleryController : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
    UITapGestureRecognizer *singleTap;
    UITapGestureRecognizer *doubleTap;
    UISwipeGestureRecognizer *leftSwipeRecogn;
    UISwipeGestureRecognizer *rightSwipeRecogn;
    IBOutlet UIView *hintView;
    IBOutlet UIButton *nameLabel;
    IBOutlet    UIScrollView *scroll;
    UIImageView *_currentImage;
    IBOutlet    UIActivityIndicatorView *netAct;
    BOOL imageOrientation;
    BOOL    isReadyForZoom;
    BOOL isChangingOrientation;
    BOOL isInBrowser;
    BOOL navBarHidden;
    BOOL initialNavBarHidden;
    
    
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
    
    
    
    UIColor *defaultColor;
   
    ///// new code ////
    
     AMBlurView *blurView;
    
    DKPictureScroll *_curScroll;
    UIActivityIndicatorView *_curAct;
    DKPictureScroll *_orientationChangeScroll;
    UIImageView *_orientationChangeImage;
    UIActivityIndicatorView *_orientationChangeAct;
    
    ///// new storyboard View
    
    IBOutlet UICollectionView *_collectionView;
    
    IBOutlet UIToolbar *_toolBar;
    IBOutlet AMBlurView *_statusBlurView;
    IBOutlet UIBarButtonItem *_navTitle;
    IBOutlet NSLayoutConstraint *hintViewButtomOffset;
    IBOutlet UIView *_navBarView;
    IBOutlet NSLayoutConstraint *navViewTopOffset;
    
    IBOutlet UIImageView *backImageView;
}

@property(nonatomic) UIInterfaceOrientation returnOrientaton;
@property(nonatomic,strong) DKPictureWrapper *picture;
@property(nonatomic, strong) NSMutableArray  *pics;
@property(nonatomic, strong) UIActivityViewController    *activity;
@property(nonatomic, copy) void (^selectedPicture)(int selectedNumber);
@property(nonatomic) BOOL transitionSet;
@property(nonatomic) CGRect startFrame;
@property(nonatomic) CGRect endFrame;
@property(nonatomic, strong) UIImage *transitionImage;
@property (nonatomic, weak) id <DKPictureGalleryDataSource> dataSource;
@property(nonatomic, weak) id <DKPictureGalleryDelegate> delegate;

- (void)setCurrentPicture:(DKPictureWrapper *)pic
              AllPictures:(NSMutableArray   *)arr
       SetCurrentPosition:(int)num;

- (void)setPictureNum:(int)number
      withImagesCount:(int)imagesCount
      withMinImageArr:(NSMutableArray *)minImageArr
        withUrlStrArr:(NSMutableArray *)urlStrArr
       withUrlShowArr:(NSMutableArray *)urlShowStrArr
          withDateUrl:(NSMutableArray *)dateArr
         withTitleArr:(NSMutableArray *)titleArr
     withTitleShowArr:(NSMutableArray *)titleShowArr
       withSnippetArr:(NSMutableArray *)snippetArr
      withFileSizeArr:(NSMutableArray *)fileSizesArr
        withFormatArr:(NSMutableArray *)formatArr
         withWidthArr:(NSMutableArray *)widthArr
        withHeightArr:(NSMutableArray *)heightArr
            withIdArr:(NSMutableArray *)idArr
          withNameArr:(NSMutableArray *)nameArr
     withOriginUrlStr:(NSMutableArray *)originUrlStrArr
           withSource:(NSMutableArray *)sourceArr;

- (void)setCollectionPictureNum:(int)number
                withImagesCount:(int)imagesCount
                withMinImageArr:(NSMutableArray *)minImageArr
                  withUrlStrArr:(NSMutableArray *)urlStrArr
                 withUrlShowArr:(NSMutableArray *)urlShowStrArr
                    withDateUrl:(NSMutableArray *)dateArr
                   withTitleArr:(NSMutableArray *)titleArr
               withTitleShowArr:(NSMutableArray *)titleShowArr
                 withSnippetArr:(NSMutableArray *)snippetArr
                withFileSizeArr:(NSMutableArray *)fileSizesArr
                  withFormatArr:(NSMutableArray *)formatArr
                   withWidthArr:(NSMutableArray *)widthArr
                  withHeightArr:(NSMutableArray *)heightArr
                      withIdArr:(NSMutableArray *)idArr
                    withNameArr:(NSMutableArray *)nameArr
               withOriginUrlStr:(NSMutableArray *)originUrlStrArr
                     withSource:(NSMutableArray *)sourceArr;

-   (void)setScrollView:(UIScrollView*)tempScrollView;
-   (void)screenTapped;
-   (void)saveToAlbum;
-   (void)confirmSave;
-   (void)setPicNum:(int)position;
-   (IBAction)dismiss:(id)sender;
-   (IBAction)saveToAlbum:(id)sender;

- (void)setTransitionRect:(CGRect)startFrame andImage:(UIImage *)startImage finishFrame:(CGRect)endFrame;
- (void)insertNewPictures:(int)pictureAmount;
@end
