//
//  DKConstants.h
//  PictureGallery
//
//  Created by Дмитрий Калашников on 06/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HINT_TRANSFORM_HIDDEN_YES    CGAffineTransformMakeTranslation(0.0, 130.0)
#define HINT_TRANSFORM_HIDDEN_NO   CGAffineTransformMakeTranslation(0.0, 0.0)
#define TIMER   0.2
#define INFO_BAR_TIMER 0.5//UINavigationControllerHideShowBarDuration
#define SCREEN_SIZE_HEIGHT         ([UIView getScreenframeForCurrentOrientation].size.height)//DEVICE_IDIOM_AND_INTERFACE_ORIENTATION_SENSETIVE_VALUE(1024.0f, 768.0f, 460.0f, 320.0f)
#define SCREEN_SIZE_WIDTH          ([UIView getScreenframeForCurrentOrientation].size.width)//DEVICE_IDIOM_AND_INTERFACE_ORIENTATION_SENSETIVE_VALUE(768.0f,1024.0f,320.0f,480.0f)
#define NAVIGATION_BAR_SIZE 44.0f
#define STATUS_BAR_SIZE        20.0f
#define TABBAR_SIZE 49.0f



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

// interface orientation detection macro
#define UI_INTERFACE_ORIENTATION_IS_PORTRAIT() (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
#define UI_INTERFACE_ORIENTATION_IS_LANDSCAPE() (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))

#define INTERFACE_ORIENTATION_SENSETIVE_VALUE(__Portrait__,__Landscape__) ( UI_INTERFACE_ORIENTATION_IS_PORTRAIT() ? __Portrait__ : __Landscape__ )

#define PICS_NO_IMAGE       [UIImage imageNamed:@"no_photo"]

#define GALLEY_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define GALLERY_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define GALLERY_IS_IPHONE_5 (GALLERY_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define GALLERY_IS_IPHONE_4 (GALLERY_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
