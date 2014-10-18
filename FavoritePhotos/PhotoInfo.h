//
//  PhotoInfo.h
//  FavoritePhotos
//
//  Created by S on 10/16/14.
//  Copyright (c) 2014 Ryan Siska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoInfoDelegate <NSObject> //will be used for tapGesture
//- (void)instagramWasFavorited:(id)instagram;
//- (void)instagramWasSelected:(id)instagram;
@end


@interface PhotoInfo : NSObject
@property id<PhotoInfoDelegate> delegate;
@property UIImage *image; //didnt know I could add this by importing uikit - Chris told me
@property BOOL favorited;

- (instancetype) initWithImage:(NSString *)url;

@end
