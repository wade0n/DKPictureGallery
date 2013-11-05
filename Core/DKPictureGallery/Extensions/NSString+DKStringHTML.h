//
//  NSString+DKStringHTML.h
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DKStringHTML)

- (NSString*)stripHTMLMarkupExceptBoldTagAndUnescapeFromHTML;

- (NSString*)stripHTMLMarkup;

- (NSString *)stringByStrippingExternalHTMLMarkupExceptTagsWithCharacters:(NSCharacterSet*)specialTagNameCharacters;
@end



@interface DKNSString_stripHTML_XMLParse1 : NSObject <NSXMLParserDelegate> {
@private
    NSMutableArray* strings;
}
- (NSString*)getCharsFound;

@end
