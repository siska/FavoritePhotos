//
//  PhotoInfo.m
//  FavoritePhotos
//
//  Created by S on 10/16/14.
//  Copyright (c) 2014 Ryan Siska. All rights reserved.
//

#import "PhotoInfo.h"

@implementation PhotoInfo

- (instancetype) initWithImage:(NSString *)url;
{
    self = [super init];
    if (self)
    {
        NSURL *urlString = [NSURL URLWithString:url];
        NSData *imageData = [NSData dataWithContentsOfURL:urlString];
        UIImage *image = [UIImage imageWithData:imageData];

        self.image = image;
        self.favorited = NO; //will have to change later - will reset an image if it reappears in the first ten
        NSLog(@"initWithImage method was called");
    }
    return self;
}

@end

