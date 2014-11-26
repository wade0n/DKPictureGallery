 //
//  DKPictureGalleryController.m
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import "DKPictureGalleryController.h"
#import "UIView+DKExtensions.h"
#import "NSString+DKStringHTML.h"
#import "UIImageView+WebCache.h"
#import "DKConstants.h"
#import "DKPictureScroll.h"
#import "DKTransitionDelegate.h"







@interface DKPictureGalleryController ()

@end


#define HINT_TRANSFORM_HIDDEN_YES    CGAffineTransformMakeTranslation(0.0, 130.0)
#define HINT_TRANSFORM_HIDDEN_NO   CGAffineTransformMakeTranslation(0.0, 0.0)
#define TIMER   0.2
#define INFO_BAR_TIMER 0.5//UINavigationControllerHideShowBarDuration




@implementation DKPictureGalleryController

@synthesize pics = _pics;

- (void)setPictureIndex:(int)picPosition Animated:(BOOL)animated{
    picTag = picPosition;
//    if (animated) {
//        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:picPosition inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
//    }
}
- (void)setTransitionRect:(CGRect)startFrame andImage:(UIImage *)startImage finishFrame:(CGRect)endFrame{
    if (startImage) {
        _startFrame = startFrame;
        
        _transitionImage = startImage;
        
        
        float screenWidth;
        float screenHeight;
        float scaledImageWidth ;
        float scaledImageHeight;
        
        if(endFrame.size.width > SCREEN_SIZE_WIDTH   ||  endFrame.size.height > (SCREEN_SIZE_HEIGHT)){
            float widthScale =  SCREEN_SIZE_WIDTH / endFrame.size.width;
            float heightScale = (SCREEN_SIZE_HEIGHT)/ endFrame.size.height;
            float resultScale = (widthScale < heightScale) ? widthScale : heightScale;
            
            
            scaledImageWidth = endFrame.size.width * resultScale;
            scaledImageHeight = endFrame.size.height * resultScale;
            screenWidth = ( SCREEN_SIZE_WIDTH - scaledImageWidth ) / 2;
            screenHeight = ( SCREEN_SIZE_HEIGHT - scaledImageHeight ) / 2 ;
            
            
        }
        else{
            screenWidth = (SCREEN_SIZE_WIDTH - endFrame.size.width)/2;
            screenHeight = (SCREEN_SIZE_HEIGHT   - endFrame.size.height)/2 ;
            scaledImageWidth = endFrame.size.width ;
            scaledImageHeight = endFrame.size.height;
        }
        
        _endFrame = CGRectMake(screenWidth, screenHeight, scaledImageWidth, scaledImageHeight);

        DKPictureWrapper *curPic = [pics objectAtIndex:picTag];
        if (curPic && !curPic.minPic) {
            curPic.minPic = startImage;
        }
        _transitionSet = YES;
    }else{
       _transitionSet = NO;
    }

}


- (void)setCollectionPictureNum:(int)number withImagesCount:(int)imagesCount withMinImageArr:(NSMutableArray *)minImageArr withUrlStrArr:(NSMutableArray *)urlStrArr withUrlShowArr:(NSMutableArray *)urlShowStrArr withDateUrl:(NSMutableArray *)dateArr withTitleArr:(NSMutableArray *)titleArr withTitleShowArr:(NSMutableArray *)titleShowArr withSnippetArr:(NSMutableArray *)snippetArr withFileSizeArr:(NSMutableArray *)fileSizesArr withFormatArr:(NSMutableArray *)formatArr withWidthArr:(NSMutableArray *)widthArr withHeightArr:(NSMutableArray *)heightArr withIdArr:(NSMutableArray *)idArr withNameArr:(NSMutableArray *)nameArr withOriginUrlStr:(NSMutableArray *)originUrlStrArr withSource:(NSMutableArray *)sourceArr{
    NSMutableArray *picWrapperArr = [NSMutableArray new];
    DKPictureWrapper *picture;
    
    for (int i = 0; i < imagesCount; i++ ) {
        
        DKPictureWrapper *curPic = [DKPictureWrapper new];
        
        if (i < minImageArr.count) {
            
            curPic.minPic = [minImageArr objectAtIndex:i];
        }
        if (i < urlStrArr.count) {
            curPic.urlStr = [urlStrArr objectAtIndex:i];
        }
        
        if (i < urlShowStrArr.count) {
            
            curPic.urlShowStr = [urlShowStrArr objectAtIndex:i];
        }
        
        if (i < dateArr.count) {
            
            curPic.date = [dateArr objectAtIndex:i];
        }
        
        if (i < titleArr.count) {
            
            curPic.title = [titleArr objectAtIndex:i];
        }
        
        if (i < titleShowArr.count) {
            
            curPic.titleShow = [titleShowArr objectAtIndex:i];
        }
        
        if (i < snippetArr.count) {
            curPic.snippet = [snippetArr objectAtIndex:i];
        }
        
        if (i < fileSizesArr.count) {
            curPic.fileSize =  [(NSString*)[fileSizesArr objectAtIndex:i] intValue];
        }
        
        if (i < formatArr.count) {
            curPic.format = [formatArr objectAtIndex:i];
        }
        
        if (i < widthArr.count) {
            
            curPic.picWidth = [(NSString*)[widthArr objectAtIndex:i] intValue];
            
        }
        
        if (i < heightArr.count) {
            
            curPic.picHeight = [(NSString*)[heightArr objectAtIndex:i] intValue];
        }
        
        if (i < idArr.count) {
            
            curPic.picId = [idArr objectAtIndex:i];
            
        }
        
        if (i < nameArr.count) {
            
            curPic.name = [nameArr objectAtIndex:i];
        }
        
        if (i < originUrlStrArr.count) {
            
            curPic.originUrl = [originUrlStrArr objectAtIndex:i];
        }
        
        if (i < minImageArr.count) {
            
            curPic.minPic = [minImageArr objectAtIndex:i];
        }
        
        if (i < sourceArr.count) {
            
        }
        
        if (curPic && i == number && self.transitionSet) {
            curPic.minPic = self.transitionImage;
        }
        
        [picWrapperArr addObject:curPic];
        
        
    }
     //[self setCurrentPicture:picture AllPictures:picWrapperArr SetCurrentPosition:number];
    
    picTag = 0;
    if (number) {
        picTag = number;
    }
    pics = picWrapperArr;
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:number inSection:0]  atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}



- (void)setPictureNum:(int)number withImagesCount:(int)imagesCount withMinImageArr:(NSMutableArray *)minImageArr withUrlStrArr:(NSMutableArray *)urlStrArr withUrlShowArr:(NSMutableArray *)urlShowStrArr withDateUrl:(NSMutableArray *)dateArr withTitleArr:(NSMutableArray *)titleArr withTitleShowArr:(NSMutableArray *)titleShowArr withSnippetArr:(NSMutableArray *)snippetArr withFileSizeArr:(NSMutableArray *)fileSizesArr withFormatArr:(NSMutableArray *)formatArr withWidthArr:(NSMutableArray *)widthArr withHeightArr:(NSMutableArray *)heightArr withIdArr:(NSMutableArray *)idArr withNameArr:(NSMutableArray *)nameArr withOriginUrlStr:(NSMutableArray *)originUrlStrArr withSource:(NSMutableArray *)sourceArr{
    
    
    NSMutableArray *picWrapperArr = [NSMutableArray new];
    DKPictureWrapper *picture;
    
    for (int i = 0; i < imagesCount; i++ ) {
        
        DKPictureWrapper *curPic = [DKPictureWrapper new];
        
        if (i < minImageArr.count) {
            curPic.minPic = [minImageArr objectAtIndex:i];
        }
        if (i < urlStrArr.count) {
            curPic.urlStr = [urlStrArr objectAtIndex:i];
        }
        
        if (i < urlShowStrArr.count) {
            
            curPic.urlShowStr = [urlShowStrArr objectAtIndex:i];
        }
        
        if (i < dateArr.count) {
            
            curPic.date = [dateArr objectAtIndex:i];
        }
        
        if (i < titleArr.count) {
            
            curPic.title = [titleArr objectAtIndex:i];
        }
        
        if (i < titleShowArr.count) {
            
            curPic.titleShow = [titleShowArr objectAtIndex:i];
        }
        
        if (i < snippetArr.count) {
            curPic.snippet = [snippetArr objectAtIndex:i];
        }
        
        if (i < fileSizesArr.count) {
            curPic.fileSize =  [(NSString*)[fileSizesArr objectAtIndex:i] intValue];
        }
        
        if (i < formatArr.count) {
            curPic.format = [formatArr objectAtIndex:i];
        }
        
        if (i < widthArr.count) {
            
            curPic.picWidth = [(NSString*)[widthArr objectAtIndex:i] intValue];
            
        }
        
        if (i < heightArr.count) {
            
            curPic.picHeight = [(NSString*)[heightArr objectAtIndex:i] intValue];
        }
        
        if (i < idArr.count) {
            
            curPic.picId = [idArr objectAtIndex:i];
            
        }
        
        if (i < nameArr.count) {
            
            curPic.name = [nameArr objectAtIndex:i];
        }
        
        if (i < originUrlStrArr.count) {
            
            curPic.originUrl = [originUrlStrArr objectAtIndex:i];
        }
        
        if (i < minImageArr.count) {
            
            curPic.minPic = [minImageArr objectAtIndex:i];
        }
        
        if (i < sourceArr.count) {
            
        }
        
        if (curPic && i == number) {
            picture = curPic;
        }
        
        [picWrapperArr addObject:curPic];
        
        
    }
    //[self setCurrentPicture:picture AllPictures:picWrapperArr SetCurrentPosition:number];
    pics = picWrapperArr;
    
    [_collectionView reloadData];
}


#pragma mark lifeCicle 

- (void)finishTransition{
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishTransitionAtPosition:)]) {
        [self.delegate finishTransitionAtPosition:picTag];
    }
}

- (DKPictureScroll *)getCurrentScroll{
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]];
    DKPictureScroll *minScroll = (DKPictureScroll *)[cell viewWithTag:11];
    
    return minScroll;
}

- (UIImageView  *)getCurrentimage{
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]];
    DKPictureScroll *minScroll = (DKPictureScroll *)[cell viewWithTag:11];
    UIImageView *picView = (UIImageView *)[minScroll viewWithTag:12];
    
    return  picView;
}

- (void)enableScrollLock{
//    if (self.dataSource) {
//        picCount = [self.dataSource numberOfPictures];
//    }
//    if (picCount) {
//        _navTitle.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
//        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]  atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        
//    }
    _scrollLock = NO;
}

- (void)setCurrentPicture:(DKPictureWrapper *)pic
              AllPictures:(NSMutableArray   *)arr
       SetCurrentPosition:(int)num{
    
    
    _currentImage = [[UIImageView alloc]  init];
    
    pics = arr;
    picTag = num;
    picCount = (int)arr.count;
    _picture = pic;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    ///adjusting scrollView ot input pictures
    
   
    
    ///
    // [self setScrollView:scroll];
    
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    
    doubleTap = [[UITapGestureRecognizer   alloc]  initWithTarget:self action:@selector(doubleTapped)];
    [doubleTap   setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
 
    [nameLabel.titleLabel setNumberOfLines:6];
    [nameLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.82] forState:UIControlStateNormal];
    [nameLabel setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
    [nameLabel addTarget:self action:@selector(openPicUrl) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setButton:nameLabel];
    
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 120, self.view.frame.size.width, 120)];
    hintView.backgroundColor = [UIColor clearColor];
    [hintView   setTransform:HINT_TRANSFORM_HIDDEN_YES];
    [hintView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    [self.view addSubview:hintView];
    
    
        //blurView.blurTintColor = self.navigationController.navigationBar.tintColor;
    //blurView.backgroundColor = [UIColor redColor];
    blurView = [[AMBlurView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAX(SCREEN_SIZE_HEIGHT, SCREEN_SIZE_WIDTH), hintView.frame.size.height+1)];
    [hintView addSubview:blurView];
    
    
    
    self.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];

    actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(saveToAlbum)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"SPLocalize", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"Save", @"SPLocalize", nil), nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")){
        
    }
    else{
        
        
        if(_picture.minPic) {
            [_currentImage setImage:_picture.minPic];
        }
        else{
            [_currentImage setImage:[UIImage  imageNamed:@"widgets-news_load_image@2x"]];
        }
        
        
        
        NSString *textToShare = @"I just found this in sputnik.ru";
        UIImage *imageToShare = _currentImage.image;
        
        
        NSArray *activityItems = @[textToShare];
        
        activ = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
        
#ifdef TESTING
        activ.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo]; //or whichever you don't need
#endif
        
        if (UI_USER_INTERFACE_IDIOM()   ==  UIUserInterfaceIdiomPad) {
            aPopoverController = [[UIPopoverController alloc] initWithContentViewController:[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil]];
        }
        
        
    }
    
    
    
  
    
}


-   (void) setButton:(UIButton *)button{
    
    NSMutableString *info;
    
    if (self.dataSource) {
        info =[NSMutableString stringWithFormat:@"«%@»\n", [self.dataSource textForItem:picTag]];
    
    }else{
        DKPictureWrapper    *picWR = [pics   objectAtIndex:picTag];
        
        NSString    *nameStr = [NSString    new];
        
        if ([picWR.name stripHTMLMarkup].length > PICS_COLLECTION_IMAGE_TITLE_LENGTH) {
            nameStr = [[picWR.name stripHTMLMarkup] substringWithRange:NSMakeRange(0, PICS_COLLECTION_IMAGE_TITLE_LENGTH)];
            nameStr = [NSString stringWithFormat:@"%@...",nameStr];
        }
        else{
            nameStr = [picWR.name stripHTMLMarkup];
        }
        
        
        
        
        info = [NSMutableString stringWithFormat:@"«%@»\n", nameStr];
        
        NSString    *snipStr = [NSString    new];
        
        //    if ([picWR.snippet stripHTMLMarkup].length > PICS_COLLECTION_IMAGE_TITLE_LENGTH) {
        //        snipStr = [[picWR.snippet stripHTMLMarkup] substringWithRange:NSMakeRange(0, PICS_COLLECTION_IMAGE_TITLE_LENGTH)];
        //        snipStr = [NSString stringWithFormat:@"%@...\n",snipStr];
        //
        //    }
        //    else{
        //        snipStr = [picWR.snippet stripHTMLMarkup];
        //    }
        
        
        if (picWR.format && picWR.format.length > 0) {
            snipStr = [snipStr stringByAppendingFormat:@"Формат:%@ \n",picWR.format];
        }
        [info appendFormat:@"%@",snipStr];
        
        [info appendFormat:@"%@: %ix%i \n", @"Размер", picWR.picWidth, picWR.picHeight];
        NSString    *sizeStr = [NSString    stringWithFormat:@"%@: %ix%i", @"Размер", picWR.picWidth, picWR.picHeight];
        NSArray *range = [picWR.urlShowStr componentsSeparatedByString:@"/"];
        
        NSString *str = nil;
        if ([range count] > 2)
            str = [range objectAtIndex:2];
        
        [info   appendFormat:@"%@: %@",@"URL",str];
        NSString *url = [NSString   stringWithFormat:@"%@: %@",@"Источник",str];
        
        
        //CGSize  expSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(button.frame.size.width,9999) lineBreakMode:button.titleLabel.lineBreakMode];
        
        //[button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, expSize.width, button.frame.size.height)];

    }
    
    [button setTitle:info forState:UIControlStateNormal];
    //[button setTitle:info forState:UIControlStateNormal];
    
    //CGSize  expSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAX(MAX([nameStr sizeWithFont:button.titleLabel.font].width, [snipStr sizeWithFont:button.titleLabel.font].width), MAX([sizeStr sizeWithFont:button.titleLabel.font].width, [url sizeWithFont:button.titleLabel.font].width)),9999) lineBreakMode:button.titleLabel.lineBreakMode];
    //CGSize  expSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(button.titleLabel.frame.size.width,9999) lineBreakMode:button.titleLabel.lineBreakMode];
    
    
}

-   (void) setScrollView:(UIScrollView*)tempScrollView{
//    if (tempScrollView.tag == 13) {
//        
//        
//        scrollWidth = SCREEN_SIZE_WIDTH ;
//        scrollHeight    =    SCREEN_SIZE_HEIGHT;
//        
//        [tempScrollView  setFrame:CGRectMake(0,  0, SCREEN_SIZE_WIDTH+10, SCREEN_SIZE_HEIGHT )];
//        
//        picsViews   =   [[NSMutableArray alloc]  init];
//        scrollViews =   [[NSMutableArray alloc]  init];
//        netActs      =   [[NSMutableArray alloc]  init];
//        
//        scroll = tempScrollView;
//        scroll.backgroundColor = [UIColor clearColor];
//        //
//        
//        //
//        //    D_Log(@"width %f height %f",scrollWidth,scrollHeight);
//        //    int localTag = picTag;
//        //
//        DKPictureWrapper *postArr       = [[DKPictureWrapper    alloc]  init];
//        DKPictureWrapper *prePic        = [[DKPictureWrapper alloc]  init];
//        DKPictureWrapper *prePrePic     = [[DKPictureWrapper  alloc]  init];
//        DKPictureWrapper *nextPic       = [[DKPictureWrapper alloc]  init];
//        DKPictureWrapper *nextNextPic   = [[DKPictureWrapper    alloc]  init];
//        
//        postArr    =   [pics    objectAtIndex:picTag];
//        
//        
//        if (picTag == pics.count-1) {
//            nextPic =   [pics objectAtIndex:0];
//            
//        }
//        else{
//            nextPic = [pics  objectAtIndex:picTag+1];
//        }
//        
//        if (picTag  ==  pics.count-2) {
//            nextNextPic = [pics objectAtIndex:0];
//        }
//        
//        else{
//            nextNextPic = [pics objectAtIndex:picTag];
//        }
//        
//        if (picTag  ==  0) {
//            prePic  =   [pics   objectAtIndex:pics.count-1];
//        }
//        else{
//            prePic  =   [pics objectAtIndex:picTag-1];
//        }
//        
//        if (picTag == 1) {
//            prePrePic = [pics objectAtIndex:pics.count-1];
//        }
//        else{
//            prePrePic   =   [pics objectAtIndex:picTag];
//        }
//        
//        
//        tempScrollView.contentSize = CGSizeMake(picCount * (SCREEN_SIZE_WIDTH + PICS_COLLECTION_SCROLL_IMAGE_DIVIDER), 0);
//        
//        CGRect frame = CGRectMake(0, 0 ,tempScrollView.frame.size.width , SCREEN_SIZE_HEIGHT );
//        frame.origin.x =tempScrollView.frame.size.width*picTag;
//        frame.origin.y = 0;
//        
//        tempScrollView.pagingEnabled = YES;
//        [tempScrollView setScrollEnabled:YES];
//        
//        //[tempScrollView setContentOffset:CGPointMake(, 0)];
//        [tempScrollView setContentOffset:CGPointMake(scroll.frame.size.width*picTag, 0)];
//        
//        
//        
//        for (int i = 0; i < pics.count; i++) {
//            
//            DKPictureWrapper  *picCur = [pics    objectAtIndex:i];
//            UIImageView *picView = [[UIImageView alloc]  initWithImage:picCur.minPic];
//            
//            
//            UIScrollView * minScroll = [[UIScrollView    alloc]  init];
//            [minScroll setDelegate:self];
//            
//            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//            
//            
//            
//            float screenWidth;
//            float screenHeight;
//            float scaledImageWidth ;
//            float scaledImageHeight;
//            
//            if(picCur.picWidth > scrollWidth   ||  picCur.picHeight > (SCREEN_SIZE_HEIGHT)){
//                float widthScale =  scrollWidth / picCur.picWidth;
//                float heightScale = (scrollHeight)/ picCur.picHeight;
//                float resultScale = (widthScale < heightScale) ? widthScale : heightScale;
//                
//                
//                scaledImageWidth = picCur.picWidth * resultScale;
//                scaledImageHeight = picCur.picHeight * resultScale;
//                screenWidth = ( scrollWidth - scaledImageWidth ) / 2;
//                screenHeight = ( scrollHeight - scaledImageHeight ) / 2 ;
//                
//                
//            }
//            else{
//                screenWidth = (scrollWidth - picCur.picWidth)/2;
//                screenHeight = (scrollHeight   - picCur.picHeight)/2 ;
//                scaledImageWidth = picCur.picWidth ;
//                scaledImageHeight = picCur.picHeight;
//            }
//            
//            float   divider =   0.0f;
//            
//            divider =   PICS_COLLECTION_SCROLL_IMAGE_DIVIDER*i;
//            
//            
//            [minScroll setFrame:CGRectMake(SCREEN_SIZE_WIDTH*i +divider , - NAVIGATION_BAR_SIZE - INTERFACE_ORIENTATION_SENSETIVE_VALUE(STATUS_BAR_SIZE, 8), SCREEN_SIZE_WIDTH,tempScrollView.frame.size.height )];
//            
//            [minScroll setBackgroundColor:[UIColor clearColor]];
//            [tempScrollView addSubview:minScroll];
//            
//            [picView setFrame:CGRectMake(screenWidth, screenHeight , scaledImageWidth, scaledImageHeight)];
//            
//            
//            
//            
//            
//            //[minScroll setCenter:CGPointMake(minScroll.center.x, tempScrollView.center.y)];
//            [picsViews addObject:picView];
//            //[picView setCenter:CGPointMake(320/2, 436/2)];
//            
//            [act setFrame:CGRectMake(SCREEN_SIZE_WIDTH/2 - act.frame.size.width/2, SCREEN_SIZE_HEIGHT/2- act.frame.size.height/2, act.frame.size.width, act.frame.size.width)];
//            
//            [act setHidesWhenStopped:YES];
//           
//            [act stopAnimating];
//            
//            //[picView setCenter:CGPointMake(SCREEN_SIZE_WIDTH*i +divider + SCREEN_SIZE_WIDTH/2, scrollHeight/2)];
//            //[tempScrollView addSubview:picView]
//            // [minScroll   addSubview:act];
//            [minScroll   addSubview:picView];
//            [minScroll   addSubview:act];
//            
//            [minScroll setContentSize:CGSizeMake(SCREEN_SIZE_WIDTH, tempScrollView.frame.size.height )];
//            
//            //[picView setCenter:CGPointMake(minScroll.center.x, minScroll.center.y)];
//            minScroll.maximumZoomScale   = 4.0f;
//            minScroll.minimumZoomScale  =   1.0f;
//            minScroll.scrollEnabled =   YES;
//            minScroll.showsHorizontalScrollIndicator = YES;
//            minScroll.showsVerticalScrollIndicator = YES;
//            minScroll.scrollsToTop = NO;
//            minScroll.bounces = NO;
//            
//            
//            
//            [scrollViews    addObject:minScroll];
//            [netActs    addObject:act];
//            
//            
//        }
//        
//        currentImage = [picsViews   objectAtIndex:picTag];
//        
//        [self changePage];
//        [self screenTapped];
//        
//        tempScrollView.scrollEnabled = YES;
//        tempScrollView.maximumZoomScale = 2.0;
//        tempScrollView.minimumZoomScale = 1.0;
//        tempScrollView.zoomScale = 1.0;
//        
//        
//        tempScrollView.pagingEnabled = YES;
//        
//        
//        
//    }
//    
}

- (void)changePage{
    
    DKPictureWrapper    *postArr = [[DKPictureWrapper    alloc]  init];
    DKPictureWrapper    *prePic   =   [[DKPictureWrapper alloc]  init];
    DKPictureWrapper    *prePrePic = [[DKPictureWrapper  alloc]  init];
    DKPictureWrapper    *nextPic  =   [[DKPictureWrapper alloc]  init];
    DKPictureWrapper    *nextNextPic = [[DKPictureWrapper    alloc]  init];
    
    UIScrollView    *preScroll;
    UIScrollView    *nextScroll;
    
    UIActivityIndicatorView *nextAct;
    UIActivityIndicatorView *preAct;
    UIActivityIndicatorView *curAct;
    
    postArr    =   [pics    objectAtIndex:picTag];
    
    
    
    UIImageView *curImage = [picsViews  objectAtIndex:picTag];
    UIImageView *nextImage = nil ;
    UIImageView *preImage = nil;
    UIImageView *nextNextImage =  nil;
    UIImageView *prePreImage = nil;
    
    if (picTag == pics.count-1) {
        nextPic     =   [pics objectAtIndex:0];
        nextImage   =   [picsViews objectAtIndex:0];
        
    }
    else{
        nextPic = [pics  objectAtIndex:picTag+1];
        nextImage = [picsViews  objectAtIndex:picTag +1];
    }
    
    
    if (picTag  ==  0) {
        prePic  =   [pics   objectAtIndex:picTag];
        preImage    =   [picsViews objectAtIndex:picTag];
    }
    else{
        prePic  =   [pics objectAtIndex:picTag-1];
        preImage  = [picsViews  objectAtIndex:picTag-1];
    }
    
    
    if (pics.count > 3) {
        
        
        if (picTag  ==  pics.count-2) {
            nextNextPic     =   [pics objectAtIndex:0];
            nextNextImage   =   [picsViews  objectAtIndex:0];
        }
        
        else{
            nextNextPic     = [pics objectAtIndex:[pics indexOfObject:nextPic]+1];
            nextNextImage   = [picsViews    objectAtIndex:[pics indexOfObject:nextPic]+1];
        }
        
        if (picTag == 1) {
            prePrePic = [pics objectAtIndex:picTag];
            prePreImage = [picsViews  objectAtIndex:picTag];
        }
        else{
            prePrePic   =   [pics objectAtIndex:picTag];
            prePreImage =   [picsViews  objectAtIndex:picTag];
        }
        
        
        
    }
    
    if(picCount > 1){
        if(picTag > 0){
            preScroll = [scrollViews objectAtIndex:picTag -1];
            [preScroll setZoomScale:1.0f];
        }
        if (picTag < (picCount -1)){
            nextScroll = [scrollViews    objectAtIndex:picTag+1];
            [nextScroll setZoomScale:1.0f];
        }
    }
    
    
    _currentImage = curImage;
    
    curAct  = [netActs   objectAtIndex:picTag];
    nextAct = [netActs   objectAtIndex:[pics   indexOfObject:nextPic]];
    preAct  = [netActs   objectAtIndex:[pics   indexOfObject:prePic]];
    
    
    if (self.navigationController.navigationBar.frame.origin.y < 0) {
        [curAct setColor:[UIColor whiteColor]];
        [nextAct setColor:[UIColor whiteColor]];
        [preAct setColor:[UIColor whiteColor]];
    }
    else{
        [curAct setColor:[UIColor grayColor]];
        [nextAct setColor:[UIColor grayColor]];
        [preAct setColor:[UIColor grayColor]];
        
    }

    
    [curAct startAnimating];
    [nextAct startAnimating];
    [preAct startAnimating];

    UIImageView *curImageCaptured = curImage;
    
    
    
    [curImage setImageWithURL:postArr.originUrl placeholderImage:postArr.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        
        if (error)
        {
            
            [curAct stopAnimating];
            [curImageCaptured setImage:PICS_NO_IMAGE];
            if (self.navigationController.navigationBar.frame.origin.y < 0) {
                [curImageCaptured setTintColor:[UIColor whiteColor]];
            }
            else{
                [curImageCaptured setTintColor:[UIColor grayColor]];
                curImageCaptured.image =  [curImageCaptured.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
            [curImageCaptured setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT)];
            [curImageCaptured setContentMode:UIViewContentModeCenter];
            postArr.originLoaded = NO;
        }
        else{
            postArr.originLoaded = YES;
            // [curImageCaptured setFrame:CGRectMake((SCREEN_SIZE_WIDTH/2) - image.size.width/2,( SCREEN_SIZE_HEIGHT- NAVIGATION_BAR_SIZE*2)/2  - image.size.height/2, image.size.width, image.size.height)];
        }
        [curAct stopAnimating];
    }];
    
    UIImageView *nextImageCaptured = nextImage;
    
    [nextImage setImageWithURL:nextPic.originUrl placeholderImage:nextPic.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        
        if (error)
        {
            
            [nextImageCaptured    setImage:PICS_NO_IMAGE];
            if (self.navigationController.navigationBar.frame.origin.y < 0) {
                [nextImageCaptured setTintColor:[UIColor whiteColor]];
            }
            else{
                [nextImageCaptured setTintColor:[UIColor grayColor]];
                nextImageCaptured.image =  [nextImageCaptured.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
            [nextImageCaptured    setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT)];
            [nextImageCaptured    setContentMode:UIViewContentModeCenter];
            nextPic.originLoaded = NO;
        }
        else{
            nextPic.originLoaded = YES;
        }
        [nextAct stopAnimating];
    }];
    
    UIImageView *preImageCaptured = preImage;
    
    [preImage setImageWithURL:prePic.originUrl placeholderImage:prePic.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error)
        {
            
            [preAct stopAnimating];
            [preImageCaptured   setImage:PICS_NO_IMAGE];
            if (self.navigationController.navigationBar.frame.origin.y < 0) {
                [preImageCaptured setTintColor:[UIColor whiteColor]];
            }
            else{
                [preImageCaptured setTintColor:[UIColor grayColor]];
                preImageCaptured.image =  [preImageCaptured.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
           
            [preImageCaptured    setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT)];
            [preImageCaptured    setContentMode:UIViewContentModeCenter];
            prePic.originLoaded = NO;
        }
        else{
            prePic.originLoaded = YES;
        }
        [preAct stopAnimating];
    }];
    
    
    if (pics.count > 3) {
        //         what was this
        //        [manager downloadWithURL:nextNextPic.originUrl delegate:self options:0 success:nil failure:nil];
        //        [manager downloadWithURL:prePrePic.originUrl delegate:self options:0 success:nil failure:nil];
        
    }
    
}

#pragma mark init

- (void)startUp{
    
    [self observeApplicationNotifications];
}

-(id)init{
    self = [super init];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PictureGalleryBoard" bundle:nil];
     self = (DKPictureGalleryController *)[sb instantiateViewControllerWithIdentifier:@"pictureGallery"];
    if (self) {
        [self startUp];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self startUp];
    }
    return self;
}



- (void)viewDidAppear:(BOOL)animated{
    
    if (self.dataSource) {
        picCount = (int)[self.dataSource numberOfPictures];
    }
    if (picCount) {
        _navTitle.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]  atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
    }
    _scrollLock = YES;

    [self performSelector:@selector(enableScrollLock) withObject:nil afterDelay:0.4];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _toolBar.layer.cornerRadius = 0.0f;
    
    _toolBar.clipsToBounds = YES;
    //.blurTintColor = _toolBar.tintColor;
    
    //[_collectionView reloadData];
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [_collectionView addGestureRecognizer:singleTap];
    
    
    doubleTap = [[UITapGestureRecognizer   alloc]  initWithTarget:self action:@selector(doubleTapped:)];
    [doubleTap   setNumberOfTapsRequired:2];
    
    [_collectionView addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    nameLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
    [nameLabel.titleLabel setNumberOfLines:6];
    [nameLabel addTarget:self action:@selector(openPicUrl) forControlEvents:UIControlEventTouchUpInside];
    
    [self setButton:nameLabel];

    blurView = (AMBlurView *)[hintView viewWithTag:12];
    [hintView addSubview: nameLabel];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark inputmethods

-  (void)closeGallery{
    [self  dismissViewControllerAnimated:NO completion:nil];
}

- (void)reloadData{
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)insertNewPictures:(int)pictureAmount{
    if (self.dataSource) {
        picCount = (int)[self.dataSource numberOfPictures];
    }
    _navTitle.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
    
    NSMutableArray *paths = [NSMutableArray new];
    for (int i = 0 ; i++; i < pictureAmount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i+picCount inSection:0];
        [paths addObject:indexPath];
    }
    
    [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithArray:[NSArray arrayWithArray:paths]]];
}
#pragma mark - orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    isChangingOrientation = YES;
    if (navBarHidden) {
        _navBarView.hidden = YES;
        hintView.hidden = YES;
    }
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]];
    
    _orientationChangeScroll = (DKPictureScroll *)[cell viewWithTag:11];
    UIImageView *picView = (UIImageView *)[_orientationChangeScroll viewWithTag:12];
    _orientationChangeImage = [[UIImageView alloc] initWithImage:picView.image];
    [_orientationChangeImage setContentMode:[picView contentMode]];
    [_orientationChangeImage setTintColor:[picView tintColor]];
    
    UIActivityIndicatorView *act = (UIActivityIndicatorView *)[_orientationChangeScroll viewWithTag:13];
    _orientationChangeAct = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_orientationChangeAct setColor:act.color];
    [_orientationChangeAct setHidesWhenStopped:YES];
    if (act.isAnimating) {
        [_orientationChangeAct startAnimating];
    }
    else
        [_orientationChangeAct stopAnimating];
    
    [self.view insertSubview:_orientationChangeImage aboveSubview:_collectionView];
    [self.view insertSubview:_orientationChangeAct aboveSubview:_orientationChangeImage];
    [_orientationChangeImage setFrame:picView.frame];
    [_orientationChangeAct setFrame:CGRectMake((SCREEN_SIZE_WIDTH - _orientationChangeAct.frame.size.width)/2, (SCREEN_SIZE_HEIGHT - _orientationChangeAct.frame.size.height)/2, _orientationChangeAct.frame.size.width, _orientationChangeAct.frame.size.height)];
    //[_collectionView setAlpha:0.0f];
    [_collectionView setHidden:YES];
    
    if (!navBarHidden) {
        _orientationChangeWhiteView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE_WIDTH, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
        _orientationChangeWhiteView.backgroundColor = [UIColor whiteColor];
        [self.view insertSubview:_orientationChangeWhiteView belowSubview:_orientationChangeImage];
    }
}

-   (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGFloat originPicWidth = 0.0f;
    CGFloat originPicHeight = 0.0f;
    
    if (self.dataSource) {
        NSDictionary *dict = [self.dataSource dictinaryForItem:picTag];
        
        originPicWidth = [(NSNumber  *)[dict objectForKey:@"picWidth"] floatValue];
        originPicHeight = [(NSNumber  *)[dict objectForKey:@"picHeight"] floatValue];
    }else if (pics && [pics    objectAtIndex:picTag]){
        DKPictureWrapper  *picCur = [pics    objectAtIndex:picTag];
        originPicWidth = picCur.picWidth;
        originPicHeight = picCur.picHeight;
        
    }
    
    
    float screenWidth;
    float screenHeight;
    float scaledImageWidth ;
    float scaledImageHeight;
    
    if(originPicWidth > SCREEN_SIZE_WIDTH   ||  originPicHeight > (SCREEN_SIZE_HEIGHT)){
        float widthScale =  SCREEN_SIZE_WIDTH / originPicWidth;
        float heightScale = (SCREEN_SIZE_HEIGHT)/ originPicHeight;
        float resultScale = (widthScale < heightScale) ? widthScale : heightScale;
        
        
        scaledImageWidth = originPicWidth * resultScale;
        scaledImageHeight = originPicHeight * resultScale;
        screenWidth = ( SCREEN_SIZE_WIDTH - scaledImageWidth ) / 2;
        screenHeight = ( SCREEN_SIZE_HEIGHT - scaledImageHeight ) / 2 ;
        
        
    }
    else{
        screenWidth = (SCREEN_SIZE_WIDTH - originPicWidth)/2;
        screenHeight = (SCREEN_SIZE_HEIGHT   - originPicHeight)/2 ;
        scaledImageWidth = originPicWidth ;
        scaledImageHeight = originPicHeight;
    }
    
    [_orientationChangeImage setFrame:CGRectMake(screenWidth, screenHeight, scaledImageWidth, scaledImageHeight)];
   [_orientationChangeWhiteView setFrame:CGRectMake(SCREEN_SIZE_WIDTH, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
    [_orientationChangeAct setFrame:CGRectMake((SCREEN_SIZE_WIDTH - _orientationChangeAct.frame.size.width)/2, (SCREEN_SIZE_HEIGHT - _orientationChangeAct.frame.size.height)/2, _orientationChangeAct.frame.size.width, _orientationChangeAct.frame.size.height)];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    isChangingOrientation = NO;
    
    if (navBarHidden) {
        
        if (navBarHidden) {
            _navBarView.hidden = NO;
             hintView.hidden = NO;
        }
    }
    
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [_collectionView setHidden:NO];
    [_orientationChangeAct removeFromSuperview];
    [_orientationChangeImage removeFromSuperview];
    [_orientationChangeWhiteView removeFromSuperview];
}

- (void)changeTheScrollViewOrientation{
    
    int localPicTag = picTag;
    
    
    scrollWidth = SCREEN_SIZE_WIDTH ;
    scrollHeight    =  SCREEN_SIZE_HEIGHT ;
    
    
    if (navBarHidden) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height - 600.0f, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    }

    
    scroll.frame = CGRectMake(0, 0  , SCREEN_SIZE_WIDTH+PICS_COLLECTION_SCROLL_IMAGE_DIVIDER, SCREEN_SIZE_HEIGHT);
    
    
    for (int i = 0; i <= picCount-1; i++) {
        
        UIScrollView    *minScroll = [scrollViews    objectAtIndex:i];
        UIImageView *picView  =   [picsViews  objectAtIndex:i];
        UIActivityIndicatorView  *act    =   [netActs    objectAtIndex:i];
        DKPictureWrapper  *picCur = [pics    objectAtIndex:i];
        
        
        
        
        float screenWidth;
        float screenHeight;
        float scaledImageWidth ;
        float scaledImageHeight;
        
        if(picCur.picWidth > scrollWidth   ||  picCur.picHeight > (scrollHeight)){
            float widthScale =  scrollWidth / picCur.picWidth;
            float heightScale = scrollHeight / picCur.picHeight;
            float resultScale = (widthScale < heightScale) ? widthScale : heightScale;
            
            
            scaledImageWidth = picCur.picWidth * resultScale;
            scaledImageHeight = picCur.picHeight * resultScale;
            screenWidth = ( scrollWidth - scaledImageWidth ) / 2;
            screenHeight = ( scrollHeight - scaledImageHeight ) / 2 ;
            
            
        }
        else{
            screenWidth = (scrollWidth - picCur.picWidth)/2;
            screenHeight = (scrollHeight   - picCur.picHeight)/2 ;
            scaledImageWidth = picCur.picWidth ;
            scaledImageHeight = picCur.picHeight;
        }
        
        float   divider =   0.0f;
        
        divider =   PICS_COLLECTION_SCROLL_IMAGE_DIVIDER*i;
        
        
        
        [minScroll setBackgroundColor:[UIColor clearColor]];
        
        [minScroll setFrame:CGRectMake(SCREEN_SIZE_WIDTH*i +divider , - NAVIGATION_BAR_SIZE - INTERFACE_ORIENTATION_SENSETIVE_VALUE(STATUS_BAR_SIZE, 8), SCREEN_SIZE_WIDTH,scroll.frame.size.height )];
        
        
        [picView setFrame:CGRectMake(screenWidth, screenHeight, scaledImageWidth, scaledImageHeight)];
        
        
        
        
        
        
        
        [minScroll setContentSize:CGSizeMake(SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT)];
        
        
        [act setFrame:CGRectMake(SCREEN_SIZE_WIDTH/2 - act.frame.size.width/2, (minScroll.frame.size.height)/2  - act.frame.size.height/2, act.frame.size.width, act.frame.size.width)];
        
        
        
    }
    
    picTag = localPicTag;
    
    
    isChangingOrientation = NO;
    
    
}
#pragma mark touch events
- (void)  screenTapped {
    
    UIScrollView    *curScroll = [scrollViews   objectAtIndex:picTag];
    
    
    if (curScroll.zoomScale == 1.0f) {
        
        
        
        [UIView animateWithDuration:INFO_BAR_TIMER
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             BOOL    hidden  =   hintView.transform.ty   ==  130.0   ?   YES :   NO;
                             //[scroll setScrollEnabled:hidden         ?   NO  :   YES];
                             [scroll setMultipleTouchEnabled:hidden  ?   NO  :   YES];
                             if (hidden)
                                 [scroll    setZoomScale:scroll.minimumZoomScale    animated:YES];
                             
                             [hintView   setTransform:hidden   ?   HINT_TRANSFORM_HIDDEN_NO    :   HINT_TRANSFORM_HIDDEN_YES];
                         }
                         completion:NULL];
        [scroll setScrollEnabled:YES];
        
    }
}

- (void)doubleTapped:(UITapGestureRecognizer *)recognizer{
    
    if (!_curScroll) {
        _curScroll = [self getCurrentScroll];
    }
    
    CGPoint location = [recognizer locationInView:self.view];
    
    UIScrollView *scrollView = _curScroll;
    UIImageView *imageView = (UIImageView *)[_curScroll viewWithTag:12];
    
    [scrollView zoomToRect:CGRectZero animated:YES];
    if(scrollView.zoomScale != 1.0){
        //[scrollView setZoomScale:1.0 animated:YES];
        CGRect rect = CGRectMake(location.x - 65, location.y - 65, 130, 130);
        [scrollView zoomToRect:rect  animated:YES];
    }else{
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }
}


- (void)singleTapped{

    if (_curScroll) {
        _curScroll = [self getCurrentScroll];
    }
    
    DKPictureScroll *curScroll = _curScroll;

    if (curScroll.zoomScale <= curScroll.minimumZoomScale) {
    
        [self screenTapped];
        if (_curAct) {
            _curAct = (UIActivityIndicatorView *)[_curScroll viewWithTag:13];
        }
        
        UIActivityIndicatorView *curAct  = _curAct;
        if (_currentImage) {
            _currentImage = (UIImageView *)[_curScroll viewWithTag:12];
        }
        
        UIImageView *curImageView = _currentImage;
        DKPictureWrapper *picWr = [pics objectAtIndex:picTag];
        
        if (navBarHidden) {
            
            CGFloat animationDuration;
            
            animationDuration = 0.5;
            // hide status bar
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            // hide nav bar
            
            navBarHidden = NO;
            

            [UIView animateWithDuration:animationDuration animations:^{
                //self.navigationController.navigationBar.frame = CGRectMake(0, STATUS_BAR_SIZE, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
                
                navViewTopOffset.constant = 0;
                hintViewButtomOffset.constant = 0;
                self.view.backgroundColor = [UIColor whiteColor];
                [self setNeedsStatusBarAppearanceUpdate];
                self.navigationController.navigationBar.tintColor = defaultColor;
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                [curAct setColor:[UIColor grayColor]];
                [curImageView setTintColor:[UIColor grayColor]];
                if (!curScroll.imageLoaded  && !curAct.isAnimating) {
                    curImageView.image =  [curImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }

            } completion:^(BOOL finished) {
                
            }];

            //[self setNeedsStatusBarAppearanceUpdate];
        }
        else{

            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            
            // delta is the amount by which the nav bar will be moved
            CGFloat delta = statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
            CGFloat animationDuration;
            
            if(statusBarFrame.size.height>20) { // in-call
                animationDuration = 0.5;
            }
            else { // normal status bar
                animationDuration = 0.6;
            }
            // hide status bar
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
            
            // hide nav ba
            navBarHidden = YES;
            [UIView animateWithDuration:animationDuration animations:^{
                //self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
                navViewTopOffset.constant = -(_navBarView.frame.size.height);
                hintViewButtomOffset.constant = -(hintView.frame.size.height+1);
                
                self.view.backgroundColor = [UIColor blackColor];
                [curAct setColor:[UIColor whiteColor]];
                [curImageView setTintColor:[UIColor whiteColor]];
                if (!curScroll.imageLoaded && !curAct.isAnimating) {
                    [curImageView setImage:PICS_NO_IMAGE];
                }
                [self setNeedsStatusBarAppearanceUpdate];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
                self.navigationController.navigationBar.tintColor = [UIColor blackColor];
            } completion:^(BOOL finished) {
            }];
     
        }
    }
}

#pragma mark pics actions

- (IBAction)dismiss:(id)sender{
    
    DKTransitionDelegate *myDelegate = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getRectForTransitionForIndex:)]){
        self.endFrame = [self.delegate getRectForTransitionForIndex:picTag];
        UICollectionViewCell *picCell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]];
        
        DKPictureScroll *minScroll = (DKPictureScroll *)[picCell viewWithTag:11];
        UIImageView *picView = (UIImageView *)[minScroll viewWithTag:12];
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(dictinaryForItem:)]) {
            NSDictionary *dict = [self.dataSource dictinaryForItem:picTag];
            if ([dict valueForKey:@"minPic"]) {
                self.transitionMinPic = (UIImage *)[dict valueForKey:@"minPic"];
            }
        }
        
        self.transitionImage = picView.image;
        self.startFrame = picView.frame;
        self.backTransitionSet = YES;
        _transitionView = picView;
//        picView.hidden = YES;
        
        myDelegate = [DKTransitionDelegate new];
        
        
        //[self presentingViewController].transitioningDelegate = nil;
        
    }
    
    self.transitioningDelegate = myDelegate;

    if (self.transitioningDelegate) {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self  dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)saveToAlbum:(id)sender{
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")){
        // [popupQuery showInView:self.view];
        
        DEVICE_IDIOM_SENSETIVE_VALUE([popupQuery showFromBarButtonItem:actionButton animated:YES], [popupQuery showInView:self.view]);
        
        
        
    }
    else{
        
        
        NSString *textToShare = @"I just found this in sputnik.ru";
        UIImage *imageToShare = _currentImage.image;
        if (!_currentImage.image) {
            imageToShare =  PICS_NO_IMAGE;
        }
        
        NSURL *urlToShare = [NSURL URLWithString:@"http://www.sputnik.ru"];
        NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
        
        
        
        activ = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
#ifdef TESTING
        activ.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo]; //or whichever you don't need
#endif
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activ animated:YES completion:nil];
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            
            if ([aPopoverController isPopoverVisible]) {
                [aPopoverController dismissPopoverAnimated:YES];
                
            }
            else{
                [aPopoverController presentPopoverFromBarButtonItem:actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
        //[popupQuery showInView:self.view];
    }
}



-   (void)  confirmSave{
    UIImageWriteToSavedPhotosAlbum(_currentImage.image, nil,
                                   nil, nil);
}


- (void)openPicUrl{
    
    DKPictureWrapper    *picWR =   [[DKPictureWrapper   alloc]  init];
    picWR = [pics   objectAtIndex:picTag];
    
    if (self.delegate) {
        [self.delegate didSelectPictureAtPosition:picTag Sender:self];
    }else if (self.selectedPicture) {
        self.selectedPicture(picTag);
    }
    else
        if (picWR.urlStr) {
            isInBrowser = YES;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:picWR.urlStr]];
            //[Utility openUrl:picWR.urlStr withInternalBrowserControllerPresentedModalByController:self];
        }
}


#pragma mark zooming scrollview
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.delegate && (scrollView.tag == 13)) {
        
        
        [self.delegate changePictureToItem:picTag];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ((scrollView.tag ==   13) && !isChangingOrientation) {
        int num;
        
        num = scrollView.contentOffset.x/(SCREEN_SIZE_WIDTH+10)+0.5;

        if (_scrollLock) {
            num = picTag;
            _scrollLock = NO;
            [scrollView setContentOffset:CGPointMake(picTag*(SCREEN_SIZE_WIDTH+10), 0)];
        }
        
        if (num != picTag) {
            picTag = num;
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:picTag inSection:0]];
            _curScroll = (DKPictureScroll *)[cell viewWithTag:11];
            _currentImage = (UIImageView *)[_curScroll viewWithTag:12];
            _curAct = (UIActivityIndicatorView *)[_curScroll viewWithTag:13];
            
            [self setButton:nameLabel];
            _navTitle.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
 
        }
        
        //NSLog(@"%@",_zoomImageView);
        
    }else if(scrollView.tag == 11){
//        if (self.delegate && [self.delegate respondsToSelector:@selector(getImageBackFromDismissTransition:)]) {
//            if (!backImageView) {
//                backImageView = [[UIImageView alloc] initWithImage:[self.delegate getImageBackFromDismissTransition:picTag]];
//                backImageView.frame = self.view.frame;
//                [self.view insertSubview:backImageView belowSubview:_collectionView];
//            }
//            CGFloat offset =  scrollView.contentOffset.y;
//            [_collectionView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:100/offset]];
//
//        }
               //NSLog(@"offset - %f",scrollView.contentOffset.y);
    }
    
}


#pragma mark zooming scrollView

- (void)scrollViewWillBeginZooming:(UIScrollView *)_scrollView withView:(UIView *)view {
    //        _scrollView.scrollEnabled = YES;
    if (_scrollView.tag == 11) {
        
        
        if (!navBarHidden){
            [self singleTapped];
        }
        
        UIActivityIndicatorView *netActiv = _curAct;
        
        if (netActiv.isAnimating) {
            [netActiv setHidden:YES];
        }
        
        
        
        
    }
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)_scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    
    if (_scrollView.tag == 11) {
        if (scale <= _scrollView.minimumZoomScale){
            
            [self singleTapped];
            
            UIActivityIndicatorView *netActiv = _curAct;
            
            if (netActiv.isAnimating) {
                [netActiv setHidden:NO];
            }
            
        }
    
    }
    
}


-(void) scrollViewDidZoom:(UIScrollView *)_scrollView{
    //[_zoomImageView setCenter:_scrollView.center];
    NSLog(@"Zoom %f contsize h -  %f w - %f  image oofset x - %F offset y - %f", _scrollView.zoomScale,_scrollView.contentSize.height, _scrollView.contentSize.width,_zoomImageView.frame.origin.x, _zoomImageView.frame.origin.y);
    
    
    UIImageView *imgView = _zoomImageView;

    
//    CGFloat offSetX = (_scrollView.contentSize.width > _scrollView.frame.size.width) ? (_scrollView.contentSize.width - _scrollView.frame.size.width) / 2 : 0.0;
//    CGFloat offSetY = (_scrollView.contentSize.height > _scrollView.frame.size.height) ? (_scrollView.contentSize.height - _scrollView.frame.size.height) * 0.45 : 0.0;
//    
//    if (_zoomImageView.frame.size.width < _zoomImageView.frame.size.height){
//        imgView.center = CGPointMake( offSetX + _scrollView.frame.size.width * 0.5 ,
//                                          offSetY + _scrollView.frame.size.height * 0.5 + _scrollView.zoomScale * 4.25 * _scrollView.zoomScale);
//        NSLog(@"H");
//        NSLog(@"%f", imgView.frame.size.height);
//        NSLog(@"%f", imgView.frame.size.width);
//    }
//    else{
//        imgView.center = CGPointMake( offSetX + _scrollView.frame.size.width * 0.5 ,  - _scrollView.frame.size.height);
//        ///[imgView setFrame:CGRectMake(offSetX, offSetY, imgView.frame.size.width, imgView.frame.size.height)];
//        
////        DKPictureScroll *dkpicture = (DKPictureScroll *)_scrollView;
////        dkpicture.topOffsestConstr.constant = dkpicture.topOffsestConstr.constant - offSetY;
////        [_scrollView setNeedsLayout];
////        [_scrollView layoutIfNeeded];
//        NSLog(@"W");
//        NSLog(@" ofsetY - %f h - %f",offSetY,imgView.frame.origin.y);
//        NSLog(@"%f", imgView.frame.size.height);
//        NSLog(@"%f", imgView.frame.size.width);
//        
//    }
    
    [self centerScrollViewContents];
//    UIImage* image = _zoomImageView.image;
//    
//    float xNewOrigin = [TCBRandom randomIntLessThan:image.size.width - scrollView.bounds.size.width];
//    float yNewOrigin = [TCBRandom randomIntLessThan:image.size.height - scrollView.bounds.size.height];
//    
//    CGRect oldRect = scrollView.bounds;
//    CGRect newRect = CGRectMake(
//                                xNewOrigin,
//                                yNewOrigin,
//                                scrollView.bounds.size.width,
//                                scrollView.bounds.size.height);
//    
//    float xDistance = fabs(xNewOrigin - oldRect.origin.x);
//    float yDistance = fabs(yNewOrigin - oldRect.origin.y);
//    float hDistance = sqrtf(powf(xDistance, 2) + powf(yDistance, 2));
//    float hDistanceInPixels = hDistance;
//    
//    float animationDuration = hDistanceInPixels / speedInPixelsPerSecond;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)_scrollView {
    if (_scrollView.tag == 11) {
      
        
        
        NSLog(@"view for zoom");
//        [_zoomImageView setContentMode:UIViewContentModeScaleToFill];
//        [_curScroll setContentMode:UIViewContentModeScaleAspectFill];
        
//        UIImage* image = _zoomImageView.image;
//        _zoomImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//        _curScroll.contentSize = image.size;
        
            _zoomImageView = (UIImageView *)[_scrollView viewWithTag:12];
    
        
        return _zoomImageView;
    }
    return nil;
}

- (void)centerScrollViewContents {
    if( !_curScroll)
        _curScroll = [self getCurrentScroll];
    CGSize boundsSize = _curScroll.bounds.size;
    CGRect contentsFrame = _zoomImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f ;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    _zoomImageView.frame = contentsFrame;
}


#pragma mark appear and dissapear
- (void)viewWillDisappear:(BOOL)animated{
    if (animated && !isInBrowser) {
        
        
        if (navBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSNumber *num = [NSNumber numberWithUnsignedInteger:UIInterfaceOrientationPortrait];
        
        [dict setObject:num forKey:@"value"];
        
        //[[NSNotificationCenter   defaultCenter]  postNotificationName:NID_CHANGE_SUPPORTED_INTERFACE_ORIENTATION object:nil userInfo:dict];
        
        
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        [navBar setHidden:initialNavBarHidden];
    
        if (defaultColor) {
            
                self.navigationController.navigationBar.tintColor = defaultColor;
        }
        
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
           
            
        }
        
        
        //-----------------------------------
        // FORCE PORTRAIT CODE
        //-----------------------------------
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        
        
        //present/dismiss viewcontroller in order to activate rotating.
//        UIViewController *mVC = [[UIViewController alloc] init];
//        [self presentModalViewController:mVC animated:NO];
//        [self dismissModalViewControllerAnimated:NO];
    }
    
    if ((_returnOrientaton != [[UIApplication sharedApplication] statusBarOrientation]) && _returnOrientaton) {
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        
        
        //present/dismiss viewcontroller in order to activate rotating.
        
        
        
    }
}


#pragma mark status bar customization
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (navBarHidden) {
        return UIStatusBarStyleLightContent;
    }else
        return UIStatusBarStyleDefault;
}
#pragma mark observing notifications

- (void)observeApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // restart scrolling when the app has been activated
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}

- (void)enterForeground{
    
}

- (void)becomeActive{
    NSLog(@"become active");
    if (navBarHidden) {
        self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
        
        //self.view.backgroundColor = [UIColor redColor];
        [self setNeedsStatusBarAppearanceUpdate];
    }
 
    
}

#pragma mark collectionView dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
           return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource) {
        picCount = [self.dataSource numberOfPictures];
        return picCount;
    }
    else if (pics.count){
        return pics.count;
    }
    else
        return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *picCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCell" forIndexPath:indexPath];
    
    DKPictureScroll *minScroll = (DKPictureScroll *)[picCell viewWithTag:11];
    UIImageView *picView = (UIImageView *)[minScroll viewWithTag:12];
    if (!picView){
        picView = [[UIImageView alloc] initWithFrame:CGRectZero];
        picView.tag = 12;
        [minScroll addSubview:picView];
    }
    picView.contentMode = UIViewContentModeScaleAspectFit;
    UIActivityIndicatorView *act = (UIActivityIndicatorView *)[picCell viewWithTag:13];
    UIImageView *curImageCaptured = picView;
    
    NSURL *picUrl;
    UIImage *minPic;
    UIImage *originPic;
    CGFloat originPicWidth = 0.0f;
    CGFloat originPicHeight = 0.0f;
    
    if (self.dataSource){
        NSDictionary *dict = [self.dataSource dictinaryForItem:indexPath.row];
        
        originPicWidth = [(NSNumber  *)[dict objectForKey:@"picWidth"] floatValue];
        originPicHeight = [(NSNumber  *)[dict objectForKey:@"picHeight"] floatValue];
        
        picUrl  = (NSURL  *)[dict objectForKey:@"originUrl"];
        minPic = (UIImage  *)[dict objectForKey:@"minPic"];
    }else{
        DKPictureWrapper  *picCur = [pics    objectAtIndex:indexPath.row];
        originPicWidth = picCur.picWidth;
        originPicHeight = picCur.picHeight;
        
        picUrl  = picCur.originUrl;
        minPic = picCur.minPic;
        
    }
    
    
    float screenWidth;
    float screenHeight;
    float scaledImageWidth ;
    float scaledImageHeight;
    
    if(originPicWidth > SCREEN_SIZE_WIDTH   ||  originPicHeight > (SCREEN_SIZE_HEIGHT)){
        float widthScale =  SCREEN_SIZE_WIDTH / originPicWidth;
        float heightScale = (SCREEN_SIZE_HEIGHT)/ originPicHeight;
        float resultScale = (widthScale < heightScale) ? widthScale : heightScale;
        
        
        scaledImageWidth = originPicWidth * resultScale;
        scaledImageHeight = originPicHeight * resultScale;
        screenWidth = ( SCREEN_SIZE_WIDTH - scaledImageWidth ) / 2;
        screenHeight = ( SCREEN_SIZE_HEIGHT - scaledImageHeight ) / 2 ;
        
        
    }
    else{
        screenWidth = (SCREEN_SIZE_WIDTH - originPicWidth)/2;
        screenHeight = (SCREEN_SIZE_HEIGHT   - originPicHeight)/2 ;
        scaledImageWidth = originPicWidth;
        scaledImageHeight = originPicHeight;
    }
    
    
   
//    minScroll.widthConstr.constant = scaledImageWidth;
//    minScroll.heightConstr.constant = scaledImageHeight;
//    minScroll.topOffsestConstr.constant = screenHeight;
//    minScroll.leftOffsetConstr.constant = screenWidth;
    
    
    minScroll.actLeftOffsetConstr.constant = (SCREEN_SIZE_WIDTH - act.frame.size.width)/2;
    minScroll.actRightOffsetConstr.constant = (SCREEN_SIZE_WIDTH - act.frame.size.width)/2;
    minScroll.actTopOffsetConstr.constant = (SCREEN_SIZE_HEIGHT - act.frame.size.height)/2;
    minScroll.actTopOffsetConstr.constant = (SCREEN_SIZE_HEIGHT - act.frame.size.height)/2;
    
    minScroll.maximumZoomScale   = 4.0f;
    minScroll.minimumZoomScale  =   1.0f;
    minScroll.zoomScale = 1.0f;
    minScroll.scrollEnabled =   YES;
    minScroll.showsHorizontalScrollIndicator = YES;
    minScroll.showsVerticalScrollIndicator = YES;
    minScroll.scrollsToTop = NO;
    [minScroll setZoomScale:minScroll.minimumZoomScale];
    
    [picView setFrame:CGRectMake(screenWidth, screenHeight, scaledImageWidth, scaledImageHeight)];
    
    [minScroll setNeedsLayout];
    [minScroll layoutIfNeeded];
    
    [minScroll setContentSize:CGSizeMake(minScroll.frame.size.width, minScroll.frame.size.height)];

    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [act startAnimating];
    UIImageView *picViewCapt = picView;
    
    
    if (navBarHidden) {
        [act setColor:[UIColor whiteColor]];
       
        
    }
    else{
        [act setColor:[UIColor grayColor]];
        

    }

    
    
    if (picUrl) {
        [picView setImageWithURL:picUrl placeholderImage:minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            if (error)
            {
                [act stopAnimating];
                [curImageCaptured setImage:PICS_NO_IMAGE];
                if (navBarHidden) {
                    [curImageCaptured setTintColor:[UIColor whiteColor]];

                }
                else{
                    [curImageCaptured setTintColor:[UIColor grayColor]];
                    curImageCaptured.image =  [curImageCaptured.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
                
                [curImageCaptured setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT)];
                [curImageCaptured setContentMode:UIViewContentModeCenter];
                minScroll.imageLoaded = NO;
                
            }
            else{
                minScroll.imageLoaded = YES;
                [picViewCapt setImage:image];
                //picViewCapt.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            // [curImageCaptured setFrame:CGRectMake((SCREEN_SIZE_WIDTH/2) - image.size.width/2,( SCREEN_SIZE_HEIGHT- NAVIGATION_BAR_SIZE*2)/2  - image.size.height/2, image.size.width, image.size.height)];
            }
            [act stopAnimating];
        }];

    }else {
        [act stopAnimating];
        [curImageCaptured setImage:PICS_NO_IMAGE];
    }
   
    
    
    
    return picCell;
}

#pragma mark collectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
  //return    _collectionView.frame.size;
  //  return CGSizeMake(_collectionView.frame.size.width, _collectionView.frame.size.height);
    return CGSizeMake(SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
}

@end