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
    NSURL *urlString = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:urlString]])];
    UIImage *image = [UIImage imageWithData:imageData];

    PhotoInfo *photo = [[PhotoInfo alloc] init];
    photo.image = image;
    photo.favorited = NO;

    return photo;
}


@end
