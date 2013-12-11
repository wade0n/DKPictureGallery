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
#import "Constants.h"






@interface DKPictureGalleryController ()

@end


#define HINT_TRANSFORM_HIDDEN_YES    CGAffineTransformMakeTranslation(0.0, 130.0)
#define HINT_TRANSFORM_HIDDEN_NO   CGAffineTransformMakeTranslation(0.0, 0.0)
#define TIMER   0.2
#define INFO_BAR_TIMER 0.5//UINavigationControllerHideShowBarDuration




@implementation DKPictureGalleryController

@synthesize pics = _pics;


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
    [self setCurrentPicture:picture AllPictures:picWrapperArr SetCurrentPosition:number];
    
}


- (void)setCurrentPicture:(DKPictureWrapper *)pic
              AllPictures:(NSMutableArray   *)arr
       SetCurrentPosition:(int)num{
    
    
    currentImage = [[UIImageView alloc]  init];
    
    pics = arr;
    picTag = num;
    picCount = (int)arr.count;
    _picture = pic;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    ///adjusting scrollView ot input pictures
    
   scroll.contentSize = CGSizeMake(picCount * SCREEN_SIZE_WIDTH , SCREEN_SIZE_HEIGHT);
    
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
    
    
    
    
    
    
    
    
    nameLabel = [[UIButton alloc] initWithFrame:CGRectMake(15, -15, self.view.frame.size.width - 20, 105)];
    
    nameLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [nameLabel.titleLabel setNumberOfLines:6];
    [nameLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.82] forState:UIControlStateNormal];
    [nameLabel setTitleColor:[UIColor colorWithWhite:1.0 alpha:1] forState:UIControlStateHighlighted];
    
    [nameLabel addTarget:self action:@selector(openPicUrl) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setButton:nameLabel];
    
    hintView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 120, self.view.frame.size.width, 120)];
    hintView.backgroundColor = [UIColor clearColor];
    [hintView   setTransform:HINT_TRANSFORM_HIDDEN_YES];
    [hintView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    [self.view addSubview:hintView];
    
    
        //blurView.blurTintColor = self.navigationController.navigationBar.tintColor;
    //blurView.backgroundColor = [UIColor redColor];
    blurView = [[AMBlurView alloc] initWithFrame:CGRectMake(0.0, 0.0, MAX(SCREEN_SIZE_HEIGHT, SCREEN_SIZE_WIDTH), hintView.frame.size.height)];
    [hintView addSubview:blurView];
    [hintView addSubview: nameLabel];
    
    
    
    self.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
    
    
    
    
    
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
    
    
    DKPictureWrapper    *picWR = [pics   objectAtIndex:picTag];
    
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
    
    NSString *str = [range objectAtIndex:2];
    [info   appendFormat:@"%@: %@",@"URL",str];
    NSString *url = [NSString   stringWithFormat:@"%@: %@",@"Источник",str];
    [button setTitle:info forState:UIControlStateNormal];
    
    CGSize  expSize = [button.titleLabel.text sizeWithFont:button.titleLabel.font constrainedToSize:CGSizeMake(MAX(MAX([nameStr sizeWithFont:button.titleLabel.font].width, [snipStr sizeWithFont:button.titleLabel.font].width), MAX([sizeStr sizeWithFont:button.titleLabel.font].width, [url sizeWithFont:button.titleLabel.font].width)),9999) lineBreakMode:button.titleLabel.lineBreakMode];
    
    [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, expSize.width, button.frame.size.height)];
    
    
}

-   (void) setScrollView:(UIScrollView*)tempScrollView{
    if (tempScrollView.tag == 13) {
        
        
        scrollWidth = SCREEN_SIZE_WIDTH ;
        scrollHeight    =    SCREEN_SIZE_HEIGHT;
        
        [tempScrollView  setFrame:CGRectMake(0,  0, SCREEN_SIZE_WIDTH+10, SCREEN_SIZE_HEIGHT )];
        
        picsViews   =   [[NSMutableArray alloc]  init];
        scrollViews =   [[NSMutableArray alloc]  init];
        netActs      =   [[NSMutableArray alloc]  init];
        
        scroll = tempScrollView;
        scroll.backgroundColor = [UIColor clearColor];
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
        
        
        tempScrollView.contentSize = CGSizeMake(picCount * SCREEN_SIZE_WIDTH + (picCount-1)*PICS_COLLECTION_SCROLL_IMAGE_DIVIDER, 0);
        
        CGRect frame = CGRectMake(0, 0 ,tempScrollView.frame.size.width , SCREEN_SIZE_HEIGHT );
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
            
            
            [minScroll setFrame:CGRectMake(SCREEN_SIZE_WIDTH*i +divider , - NAVIGATION_BAR_SIZE - INTERFACE_ORIENTATION_SENSETIVE_VALUE(STATUS_BAR_SIZE, 8), SCREEN_SIZE_WIDTH,tempScrollView.frame.size.height )];
            
            [minScroll setBackgroundColor:[UIColor clearColor]];
            [tempScrollView addSubview:minScroll];
            
            [picView setFrame:CGRectMake(screenWidth, screenHeight , scaledImageWidth, scaledImageHeight)];
            
            
            
            
            
            //[minScroll setCenter:CGPointMake(minScroll.center.x, tempScrollView.center.y)];
            [picsViews addObject:picView];
            //[picView setCenter:CGPointMake(320/2, 436/2)];
            
            [act setFrame:CGRectMake(SCREEN_SIZE_WIDTH/2 - act.frame.size.width/2, SCREEN_SIZE_HEIGHT/2- act.frame.size.height/2, act.frame.size.width, act.frame.size.width)];
            
            [act setHidesWhenStopped:YES];
           
            [act stopAnimating];
            
            //[picView setCenter:CGPointMake(SCREEN_SIZE_WIDTH*i +divider + SCREEN_SIZE_WIDTH/2, scrollHeight/2)];
            //[tempScrollView addSubview:picView]
            // [minScroll   addSubview:act];
            [minScroll   addSubview:picView];
            [minScroll   addSubview:act];
            
            [minScroll setContentSize:CGSizeMake(SCREEN_SIZE_WIDTH, tempScrollView.frame.size.height )];
            
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


#pragma mark init

- (void)startUp{
    scroll = [[UIScrollView alloc]   init];
    scroll.tag = 13;
    scroll.delegate = self;
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = YES;
    scroll.scrollsToTop = NO;
    scroll.bounces = NO;
   
    
}

-(id)init{
    self = [super init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    defautColor =  self.navigationController.navigationBar.tintColor;
    
    [self.view addSubview:scroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - orientation



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    isChangingOrientation = YES;

}

-   (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self changeTheScrollViewOrientation];
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (navBarHidden) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height , self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    }

    
}

- (void)changeTheScrollViewOrientation{
    
    int localPicTag = picTag;
    
    
    scrollWidth = SCREEN_SIZE_WIDTH ;
    scrollHeight    =  SCREEN_SIZE_HEIGHT ;
    
    
    if (navBarHidden) {
        
        self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height - 600.0f, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    }

    
    scroll.frame = CGRectMake(0, 0  , SCREEN_SIZE_WIDTH+PICS_COLLECTION_SCROLL_IMAGE_DIVIDER, SCREEN_SIZE_HEIGHT);
    scroll.contentSize = CGSizeMake(picCount * SCREEN_SIZE_WIDTH + (picCount-1)*PICS_COLLECTION_SCROLL_IMAGE_DIVIDER, 0);
    
    
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
    
    
   
    [scroll setContentOffset:CGPointMake(scroll.frame.size.width*picTag, - NAVIGATION_BAR_SIZE - INTERFACE_ORIENTATION_SENSETIVE_VALUE(STATUS_BAR_SIZE+4, 8))];

    
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

- (void)doubleTapped{
    UIScrollView *scrollView = [scrollViews objectAtIndex:picTag];
    
    if(scrollView.zoomScale != 1.0){
        [scrollView setZoomScale:1.0 animated:YES];
    }else{
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
    }
}


- (void)singleTapped{
    
    
    
    UIScrollView *curScroll = [scrollViews objectAtIndex:picTag];
    
    
    
    
    
    if (curScroll.zoomScale <= 1.0f) {
        
        
        
        
        
        
        [self screenTapped];
        
        if (self.navigationController.navigationBar.frame.origin.y < 0) {
            
            
            
            
            CGFloat animationDuration;
            
            animationDuration = 0.5;
            // hide status bar
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            // hide nav bar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            self.navigationController.navigationBar.frame = CGRectMake(0, STATUS_BAR_SIZE, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
            
            self.view.backgroundColor = [UIColor whiteColor];
            
            self.navigationController.navigationBar.tintColor = defautColor;
            
            [UIView commitAnimations];
            
            
            
            
            navBarHidden = NO;
            
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
            
            // hide nav bar
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:animationDuration];
            
            self.navigationController.navigationBar.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
            
            self.view.backgroundColor = [UIColor blackColor];
            self.navigationController.navigationBar.tintColor = [UIColor blackColor] ;
            [UIView commitAnimations];
            
            
            
            
            
            navBarHidden = YES;
            
        }
        
        
    }
    
    
}

#pragma mark pics actions

-   (void)  saveToAlbum{
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")){
        // [popupQuery showInView:self.view];
        
        DEVICE_IDIOM_SENSETIVE_VALUE([popupQuery showFromBarButtonItem:actionButton animated:YES], [popupQuery showInView:self.view]);
        
        
        
    }
    else{
        
        
        NSString *textToShare = @"I just found this in sputnik.ru";
        UIImage *imageToShare = currentImage.image;
        if (!currentImage.image) {
            imageToShare =  [UIImage    imageNamed:@"widgets-news_load_image@2x"];
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
    UIImageWriteToSavedPhotosAlbum(currentImage.image, nil,
                                   nil, nil);
    
}


- (void)openPicUrl{
    
    DKPictureWrapper    *picWR =   [[DKPictureWrapper   alloc]  init];
    
    picWR = [pics   objectAtIndex:picTag];
    
    if (picWR.urlStr) {
        isInBrowser = YES;
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:picWR.urlStr]];
        //[Utility openUrl:picWR.urlStr withInternalBrowserControllerPresentedModalByController:self];
    }
    
    
    
}


#pragma mark zooming scrollview


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ((scrollView.tag ==   13) && !isChangingOrientation) {
        
        
        
        
        
        
        
        
        if ((scrollView.contentOffset.x <= scrollView.frame.size.width * (picTag -1))){
            if (picTag > 0) {
                
                int num;
                
                num = scrollView.contentOffset.x/scrollView.frame.size.width + 0.5;
                picTag = num;
                [self changePage];
                [self setButton:nameLabel];
                self.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
            }
        }
        
        else  if (scrollView.contentOffset.x >= scrollView.frame.size.width * (picTag+1)-PICS_COLLECTION_SCROLL_IMAGE_DIVIDER) {
            if (picTag < (pics.count)) {
                
                int num;
                
                num = scrollView.contentOffset.x/scrollView.frame.size.width + 0.5;
                picTag = num;
                
                [self changePage];
                [self setButton:nameLabel];
                self.title = [NSString stringWithFormat:@"%i из %i", picTag + 1, picCount];
            }
        }
    }
    
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)_scrollView withView:(UIView *)view {
    //        _scrollView.scrollEnabled = YES;
    if (_scrollView.tag != 13) {
        
        
        if (self.navigationController.navigationBar.frame.origin.y > 0){
            [self singleTapped];
        }
        
        UIActivityIndicatorView *netActiv = [netActs  objectAtIndex:picTag];
        
        if (netActiv.isAnimating) {
            [netActiv setHidden:YES];
        }
        
        
        
        
    }
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)_scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    
    if (_scrollView.tag != 13) {
        
        
        
        if (_scrollView.zoomScale == _scrollView.minimumZoomScale){
            
            [self singleTapped];
            
            UIActivityIndicatorView *netActiv = [netActs  objectAtIndex:picTag];
            
            if (netActiv.isAnimating) {
                [netActiv setHidden:NO];
            }
            
        }
        
        
    }
    
}


-(void) scrollViewDidZoom:(UIScrollView *)_scrollView{
    
    // D_Log(@"Zoom %f", _scrollView.zoomScale);
    CGFloat offSetX = (_scrollView.contentSize.width > _scrollView.frame.size.width) ? (_scrollView.contentSize.width - _scrollView.frame.size.width) / 2 : 0.0;
    CGFloat offSetY = (_scrollView.contentSize.height > _scrollView.frame.size.height) ? (_scrollView.contentSize.height - _scrollView.frame.size.height) * 0.45 : 0.0;
    
    if (imageOrientation == YES){
        currentImage.center = CGPointMake( offSetX + _scrollView.frame.size.width * 0.5 ,
                                          offSetY + _scrollView.frame.size.height * 0.5 + _scrollView.zoomScale * 4.25 * _scrollView.zoomScale);
        //      //  D_Log(@"H");
        //        D_Log(@"%f", currentImage.frame.size.height);
        //        D_Log(@"%f", currentImage.frame.size.width);
    }
    else{
        currentImage.center = CGPointMake( offSetX + _scrollView.frame.size.width * 0.5 ,
                                          offSetY + _scrollView.frame.size.height * 0.5 + 3);
        //        D_Log(@"W");
        //        D_Log(@"%f", currentImage.frame.size.height);
        //        D_Log(@"%f", currentImage.frame.size.width);
    }
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)_scrollView {
    
    if (_scrollView.tag != 13) {
        
        
        
        UIImageView *imgView =[_scrollView.subviews    objectAtIndex:0];
        
        return imgView;
    }
    
    return nil;
}


#pragma mark appear and dissapear
- (void)viewWillDisappear:(BOOL)animated{
    if (animated && !isInBrowser) {
        
        
        if (navBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSNumber *num = [NSNumber numberWithUnsignedInteger:kSupportedInterfaceOrientationPortrait];
        
        [dict setObject:num forKey:@"value"];
        
        //[[NSNotificationCenter   defaultCenter]  postNotificationName:NID_CHANGE_SUPPORTED_INTERFACE_ORIENTATION object:nil userInfo:dict];
        
        
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        [navBar setHidden:YES];
        
        
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

- (void)viewWillAppear:(BOOL)animated{
    if(animated && !isInBrowser){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSNumber *num = [NSNumber numberWithUnsignedInteger:kSupportedInterfaceOrientationAllButUsideDown];
        
        [dict setObject:num forKey:@"value"];
        
        
        
        
        scrollHeight = SCREEN_SIZE_HEIGHT;
        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        UINavigationBar *navBar = [[self navigationController] navigationBar];
        
        [navBar setHidden:NO];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
        }
        else{
        }
        

        
        [self setScrollView:scroll];
        
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            [navBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            
            [navBar setBackgroundColor:[UIColor   blackColor]];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [navBar setTintColor:[UIColor blackColor]];
            [navBar setAlpha:0.5f];
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
        }
        
        
        
        
        
        
        
        isReadyForZoom = YES;
        
    }
    else{
        isInBrowser = NO;
        }
}

@end