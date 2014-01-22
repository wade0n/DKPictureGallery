//
//  NSString+DKStringHTML.m
//  PictureGallery
//
//  Created by Дмитрий Калашников on 05/11/13.
//  Copyright (c) 2013 Дмитрий Калашников. All rights reserved.
//

#import "NSString+DKStringHTML.h"

@implementation DKNSString_stripHTML_XMLParse1
- (id)init {
    if((self = [super init])) {
        strings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
    [strings addObject:string];
}

- (NSString*)getCharsFound {
    return [strings componentsJoinedByString:@""];
}
@end

@implementation NSString (DKStripHTML)

- (NSString*)stripHTMLMarkup {
    // take this string obj and wrap it in a root element to ensure only a single root element exists
    NSString* string = [NSString stringWithFormat:@"<root>%@</root>", self];
    
    // add the string to the xml parser
    NSStringEncoding encoding = string.fastestEncoding;
    NSData* data = [string dataUsingEncoding:encoding];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    
    // parse the content keeping track of any chars found outside tags (this will be the stripped content)
    DKNSString_stripHTML_XMLParse1 *resultHandler = [[DKNSString_stripHTML_XMLParse1 alloc] init];
    parser.delegate = resultHandler;
    [parser parse];
    
    // any chars found while parsing are the stripped content
    NSString* strippedString = [resultHandler getCharsFound];
    
    // get the raw text out of the parsee after parsing, and return it
    return strippedString;
}


@end
