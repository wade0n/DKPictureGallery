//
//  DKPictureWrapper.h
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPictureWrapper : NSObject

@property(nonatomic, retain) NSURL      *url;
@property(nonatomic, retain) NSString   *urlStr;
@property(nonatomic, retain) NSURL      *urlShow;
@property(nonatomic, retain) NSString   *urlShowStr;
@property(nonatomic, retain) NSString   *dateStr;
@property(nonatomic, retain) NSDate     *date;
@property(nonatomic, retain) NSString   *title;
@property(nonatomic, retain) NSString   *titleShow;
@property(nonatomic, retain) NSString   *snippet;
@property(nonatomic, retain) NSString   *format;
@property(nonatomic, retain) NSString   *picId;
@property(nonatomic, retain) NSString   *name;
@property(nonatomic, retain) NSURL      *originUrl;
@property(nonatomic, retain) NSString   *originStr;
@property(nonatomic, retain) NSString   *minPicKey;
@property(nonatomic, retain) NSURL      *minPicUrl;
@property(nonatomic, retain) UIImage    *minPic;
@property(nonatomic, retain) UIImage    *rectImage;
@property(nonatomic)         int        time;
@property(nonatomic)         int        picWidth;
@property(nonatomic)         int        picHeight;
@property(nonatomic)         int        fileSize;
@property(nonatomic)         int        number;

@end
