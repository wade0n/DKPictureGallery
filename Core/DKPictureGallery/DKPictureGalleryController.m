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

@interface DKPictureGalleryController ()

@end

#define HINT_TRANSFORM_HIDDEN_YES    CGAffineTransformMakeTranslation(0.0, 130.0)
#define HINT_TRANSFORM_HIDDEN_NO   CGAffineTransformMakeTranslation(0.0, 0.0)
#define TIMER   0.2
#define INFO_BAR_TIMER 0.5//UINavigationControllerHideShowBarDuration
#define SCREEN_SIZE_HEIGHT         ([UIView getScreenframeForCurrentOrientation].size.height)//DEVICE_IDIOM_AND_INTERFACE_ORIENTATION_SENSETIVE_VALUE(1024.0f, 768.0f, 460.0f, 320.0f)
#define SCREEN_SIZE_WIDTH          ([UIView getScreenframeForCurrentOrientation].size.width)//DEVICE_IDIOM_AND_INTERFACE_ORIENTATION_SENSETIVE_VALUE(768.0f,1024.0f,320.0f,480.0f)
#define NAVIGATION_BAR_SIZE 44.0f
#define STATUS_BAR_SIZE        20.0f



#ifdef UI_USER_INTERFACE_IDIOM
#define IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IPAD() (false)
#endif

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define PICS_COLLECTION_SCROLL_IMAGE_DIVIDER    10.0f

#define PICS_COLLECTION_IMAGE_TITLE_LENGTH        DEVICE_IDIOM_SENSETIVE_VALUE(95, 60)

#define DEVICE_IDIOM_SENSETIVE_VALUE(__iPad__,__iPhone__) ( IPAD() ? __iPad__ : __iPhone__ )

#define PICS_NO_IMAGE       [UIImage imageNamed:@"no_photo"]

@implementation DKPictureGalleryController

- (void)setCurrentPicture:(DKPictureWrapper *)pic
              AllPictures:(NSMutableArray   *)arr
       SetCurrentPosition:(int)num{
    
    
    currentImage = [[UIImageView alloc]  init];
    
    pics = arr;
    picTag = num;
    picCount = arr.count;
    _picture = pic;
    
    
    
    
    
    
    ///adjusting scrollView ot input pictures
    
    scroll.contentSize = CGSizeMake(picCount * SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE);
    
    ///
    
    
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
    
    leftSwipeRecogn = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenSwipedLeft)];
    [leftSwipeRecogn setDirection:UISwipeGestureRecognizerDirectionRight];
    //[self.view addGestureRecognizer:leftSwipeRecogn];
    
    rightSwipeRecogn = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(screenSwipedRight)];
    [rightSwipeRecogn setDirection:UISwipeGestureRecognizerDirectionLeft];
    //[self.view addGestureRecognizer:rightSwipeRecogn];
    
    
    doubleTap = [[UITapGestureRecognizer   alloc]  initWithTarget:self action:@selector(doubleTapped)];
    [doubleTap   setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    
    
    
    
    
    
    nameLabel = [[UIButton alloc] initWithFrame:CGRectMake(15, -15, self.view.frame.size.width - 20, 105)];
    
    nameLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [nameLabel.titleLabel setNumberOfLines:6];
    [nameLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.82] forState:UIControlStateNormal];
    [nameLabel setTitleColor:[UIColor colorWithWhite:1.0 alpha:1] forState:UIControlStateHighlighted];
    
    [nameLabel addTarget:self action:@selector(openPicUrl) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setButton:nameLabel];
    
    
    
    
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 120, self.view.frame.size.width, 120)];
    hintView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [hintView   setTransform:HINT_TRANSFORM_HIDDEN_YES];
    [hintView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [hintView addSubview: nameLabel];
    [self.view addSubview:hintView];
    
    //UIImageView*    background  =   [[UIImageView    alloc] initWithImage:[UIImage  imageNamed:@"as_background.png"]];
    // [background     setFrame:CGRectMake(0.0, -20.0, 320.0, 480.0)];
    //[self.view      addSubview:background];
    //[self.view      sendSubviewToBack:background];
    self.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
    
    
    
    
    
    //[self.view  addSubview:_rootScrollView];
    actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(saveToAlbum)];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"SPLocalize", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"Save", @"SPLocalize", nil), nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    
    
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")){
        
    }
    else{
        
        
        if(_picture.minPic) {
            [currentImage setImage:_picture.minPic];
        }
        else{
            [currentImage setImage:[UIImage  imageNamed:@"widgets-news_load_image@2x"]];
        }
        
        
        
        NSString *textToShare = @"I just found this in sputnik.ru";
        UIImage *imageToShare = currentImage.image;
        
        
        NSArray *activityItems = @[textToShare, imageToShare];
        
        activ = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
#ifdef TESTING
        activ.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo]; //or whichever you don't need
#endif
        if (UI_USER_INTERFACE_IDIOM()   ==  UIUserInterfaceIdiomPad) {
            aPopoverController = [[UIPopoverController alloc] initWithContentViewController:[[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil]];
        }
        
        
    }
    
    
    //[self screenTapped];
    

}


-   (void) setButton:(UIButton *)button{
    
    DKPictureWrapper    *picWR =   [[DKPictureWrapper   alloc]  init];
    
    picWR = [pics   objectAtIndex:picTag];
    
    NSString    *nameStr = [NSString    new];
    
    if ([picWR.name stripHTMLMarkup].length > PICS_COLLECTION_IMAGE_TITLE_LENGTH) {
        nameStr = [[picWR.name stripHTMLMarkup] substringWithRange:NSMakeRange(0, PICS_COLLECTION_IMAGE_TITLE_LENGTH)];
        nameStr = [NSString stringWithFormat:@"%@...",nameStr];
    }
    else{
        nameStr = [picWR.name stripHTMLMarkup];
    }
    
    
    
    
    NSMutableString *info = [NSMutableString stringWithFormat:@"«%@»\n", nameStr];
    
    NSString    *snipStr = [NSString    new];
    
    if ([picWR.snippet stripHTMLMarkup].length > PICS_COLLECTION_IMAGE_TITLE_LENGTH) {
        snipStr = [[picWR.snippet stripHTMLMarkup] substringWithRange:NSMakeRange(0, PICS_COLLECTION_IMAGE_TITLE_LENGTH)];
        snipStr = [NSString stringWithFormat:@"%@...",snipStr];
        
    }
    else{
        snipStr = [picWR.snippet stripHTMLMarkup];
    }
    
    [info appendFormat:@"%@\n",snipStr];
    
    [info appendFormat:@"%@: %ix%i \n", @"Размер", picWR.picWidth, picWR.picHeight];
    NSString    *sizeStr = [NSString    stringWithFormat:@"%@: %ix%i", @"Размер", picWR.picWidth, picWR.picHeight];
    NSArray *range = [picWR.urlShowStr componentsSeparatedByString:@"/"];
    
    NSString *str = [range objectAtIndex:2];
    [info   appendFormat:@"%@: %@",@"URL",str];
    NSString *url = [NSString   stringWithFormat:@"%@: %@",@"URL",str];
    [button setTitle:info forState:UIControlStateNormal];
    
    CGSize  expSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAX(MAX([nameStr sizeWithFont:button.titleLabel.font].width, [snipStr sizeWithFont:button.titleLabel.font].width), MAX([sizeStr sizeWithFont:button.titleLabel.font].width, [url sizeWithFont:button.titleLabel.font].width)),9999) lineBreakMode:button.titleLabel.lineBreakMode];
    
    [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, expSize.width, button.frame.size.height)];
    
    
}

-   (void) setScrollView:(UIScrollView*)tempScrollView{
    if (tempScrollView.tag == 13) {
        
        
        scrollWidth = SCREEN_SIZE_WIDTH ;
        scrollHeight    =    SCREEN_SIZE_HEIGHT;
        
        [tempScrollView  setFrame:CGRectMake(0, -NAVIGATION_BAR_SIZE - STATUS_BAR_SIZE, SCREEN_SIZE_WIDTH+10, SCREEN_SIZE_HEIGHT + NAVIGATION_BAR_SIZE + STATUS_BAR_SIZE)];
        
        picsViews   =   [[NSMutableArray alloc]  init];
        scrollViews =   [[NSMutableArray alloc]  init];
        netActs      =   [[NSMutableArray alloc]  init];
        
        scroll = tempScrollView;
        scroll.backgroundColor = [UIColor blackColor];
        //
        
        //
        //    D_Log(@"width %f height %f",scrollWidth,scrollHeight);
        //    int localTag = picTag;
        //
        DKPictureWrapper *postArr       = [[DKPictureWrapper    alloc]  init];
        DKPictureWrapper *prePic        = [[DKPictureWrapper alloc]  init];
        DKPictureWrapper *prePrePic     = [[DKPictureWrapper  alloc]  init];
        DKPictureWrapper *nextPic       = [[DKPictureWrapper alloc]  init];
        DKPictureWrapper *nextNextPic   = [[DKPictureWrapper    alloc]  init];
        
        postArr    =   [pics    objectAtIndex:picTag];
        
        
        if (picTag == pics.count-1) {
            nextPic =   [pics objectAtIndex:0];
            
        }
        else{
            nextPic = [pics  objectAtIndex:picTag+1];
        }
        
        if (picTag  ==  pics.count-2) {
            nextNextPic = [pics objectAtIndex:0];
        }
        
        else{
            nextNextPic = [pics objectAtIndex:picTag];
        }
        
        if (picTag  ==  0) {
            prePic  =   [pics   objectAtIndex:pics.count-1];
        }
        else{
            prePic  =   [pics objectAtIndex:picTag-1];
        }
        
        if (picTag == 1) {
            prePrePic = [pics objectAtIndex:pics.count-1];
        }
        else{
            prePrePic   =   [pics objectAtIndex:picTag];
        }
        
        
        tempScrollView.contentSize = CGSizeMake(picCount * SCREEN_SIZE_WIDTH + (picCount-1)*PICS_COLLECTION_SCROLL_IMAGE_DIVIDER, SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE*2);
        
        CGRect frame = CGRectMake(0, 0 ,tempScrollView.frame.size.width , SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE);
        frame.origin.x =tempScrollView.frame.size.width*picTag;
        frame.origin.y = 0;
        
        tempScrollView.pagingEnabled = YES;
        [tempScrollView setScrollEnabled:YES];
        
        [tempScrollView scrollRectToVisible:frame animated:NO];
        
        
        
        
        for (int i = 0; i < pics.count; i++) {
            
            DKPictureWrapper  *picCur = [pics    objectAtIndex:i];
            UIImageView *picView = [[UIImageView alloc]  initWithImage:picCur.minPic];
            
            
            UIScrollView * minScroll = [[UIScrollView    alloc]  init];
            [minScroll setDelegate:self];
            
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            
            
            float screenWidth;
            float screenHeight;
            float scaledImageWidth ;
            float scaledImageHeight;
            
            if(picCur.picWidth > scrollWidth   ||  picCur.picHeight > (SCREEN_SIZE_HEIGHT)){
                float widthScale =  scrollWidth / picCur.picWidth;
                float heightScale = (scrollHeight)/ picCur.picHeight;
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
            
            
            [minScroll setFrame:CGRectMake(SCREEN_SIZE_WIDTH*i +divider , 0, SCREEN_SIZE_WIDTH, scrollHeight )];
            [minScroll setBackgroundColor:[UIColor blackColor]];
            [tempScrollView addSubview:minScroll];
            
            //[picView setFrame:CGRectMake(screenWidth+ SCREEN_SIZE_WIDTH*i +divider,   screenHeight , scaledImageWidth, scaledImageWidth)];
            [picView setFrame:CGRectMake(screenWidth, screenHeight , scaledImageWidth, scaledImageHeight)];
            
            //[picView setCenter:minScroll.center];
            
            
            
            
            //[minScroll setCenter:CGPointMake(minScroll.center.x, tempScrollView.center.y)];
            [picsViews addObject:picView];
            //[picView setCenter:CGPointMake(320/2, 436/2)];
            
            [act setFrame:CGRectMake(SCREEN_SIZE_WIDTH/2 - act.frame.size.width/2, SCREEN_SIZE_HEIGHT/2- act.frame.size.height/2, act.frame.size.width, act.frame.size.width)];
            
            [act setHidesWhenStopped:YES];
            //[act setBackgroundColor:[UIColor redColor]];
            [act stopAnimating];
            
            //[picView setCenter:CGPointMake(SCREEN_SIZE_WIDTH*i +divider + SCREEN_SIZE_WIDTH/2, scrollHeight/2)];
            //[tempScrollView addSubview:picView]
            // [minScroll   addSubview:act];
            [minScroll   addSubview:picView];
            [minScroll   addSubview:act];
            
            [minScroll setContentSize:CGSizeMake(SCREEN_SIZE_WIDTH, scrollHeight )];
            
            //[picView setCenter:CGPointMake(minScroll.center.x, minScroll.center.y)];
            minScroll.maximumZoomScale   = 4.0f;
            minScroll.minimumZoomScale  =   1.0f;
            minScroll.scrollEnabled =   YES;
            minScroll.showsHorizontalScrollIndicator = YES;
            minScroll.showsVerticalScrollIndicator = YES;
            minScroll.scrollsToTop = NO;
            minScroll.bounces = NO;
            
            
            
            [scrollViews    addObject:minScroll];
            [netActs    addObject:act];
            
            
        }
        
        currentImage = [picsViews   objectAtIndex:picTag];
        
        [self changePage];
        [self screenTapped];
        
        tempScrollView.scrollEnabled = YES;
        tempScrollView.maximumZoomScale = 2.0;
        tempScrollView.minimumZoomScale = 1.0;
        tempScrollView.zoomScale = 1.0;
        
        
        tempScrollView.pagingEnabled = YES;
        //    tempScrollView.contentSize = CGSizeMake(1000 , SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE); // making frame for scrollView
        //   tempScrollView.showsHorizontalScrollIndicator = YES;
        //  tempScrollView.showsVerticalScrollIndicator = NO;
        //    tempScrollView.scrollsToTop = NO;
        //    tempScrollView.delegate = self;
        //    tempScrollView.bounces = NO;
        
        
        
    }
    
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
    
    
    currentImage = curImage;
    
    curAct  = [netActs   objectAtIndex:picTag];
    nextAct = [netActs   objectAtIndex:[pics   indexOfObject:nextPic]];
    preAct  = [netActs   objectAtIndex:[pics   indexOfObject:prePic]];
    
    [curAct startAnimating];
    [nextAct startAnimating];
    [preAct startAnimating];
    
    
    ////check pics order///
    
    
    
    
    
    UIImageView *curImageCaptured = curImage;
    
    
    
    [curImage setImageWithURL:postArr.originUrl placeholderImage:postArr.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error)
        {
            
            [curAct stopAnimating];
            [curImageCaptured setImage:PICS_NO_IMAGE];
            [curImageCaptured    setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , scrollHeight)];
            [curImageCaptured    setContentMode:UIViewContentModeCenter];
            
        }
        else{
            // [curImageCaptured setFrame:CGRectMake((SCREEN_SIZE_WIDTH/2) - image.size.width/2,( SCREEN_SIZE_HEIGHT- NAVIGATION_BAR_SIZE*2)/2  - image.size.height/2, image.size.width, image.size.height)];
        }
        [curAct stopAnimating];
    }];
    
    UIImageView *nextImageCaptured = nextImage;
    
    [nextImage setImageWithURL:nextPic.originUrl placeholderImage:nextPic.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error)
        {
            
            [nextImageCaptured    setImage:PICS_NO_IMAGE];
            [nextImageCaptured    setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE)];
            [nextImageCaptured    setContentMode:UIViewContentModeCenter];
        }
        [nextAct stopAnimating];
    }];
    
    UIImageView *preImageCaptured = preImage;
    
    [preImage setImageWithURL:prePic.originUrl placeholderImage:prePic.minPic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (error)
        {
            
            [preAct stopAnimating];
            [preImageCaptured    setFrame:CGRectMake(0 ,0 , SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT - NAVIGATION_BAR_SIZE)];
            [preImageCaptured    setContentMode:UIViewContentModeCenter];
        }
        [preAct stopAnimating];
    }];
    
    
    if (pics.count > 3) {
        //        TODO: what was this
        //        [manager downloadWithURL:nextNextPic.originUrl delegate:self options:0 success:nil failure:nil];
        //        [manager downloadWithURL:prePrePic.originUrl delegate:self options:0 success:nil failure:nil];
        
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
