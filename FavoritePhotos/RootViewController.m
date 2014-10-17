//
//  ViewController.m
//  FavoritePhotos
//
//  Created by S on 10/16/14.
//  Copyright (c) 2014 Ryan Siska. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *photos;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [[NSMutableArray alloc] init];
    [self getPhotos:@"chicago"];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCellID" forIndexPath:indexPath];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (void)getPhotos:(NSString *)urlString
{
    [super viewDidLoad];
    NSString *string = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=de07f6709b3a418683cb2f43a2729de2&callback=callbackFunction=json", urlString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSError *jsonError = nil;
        if (data)
        {
            NSDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *tempDataArray = [tempDictionary objectForKey:@"data"];

            for (NSDictionary *tempDictionary in tempDataArray) //to be able to pull objectForKeys from Dictionary
            {
                NSDictionary *tempImagesDictionary = [tempDictionary objectForKey:@"images"];
                NSDictionary *tempLowResDictionary = [tempImagesDictionary objectForKey:@"low_resolution"];
                NSString *tempURLString = [tempLowResDictionary objectForKey:@"url"];
                PhotoInfo *photo = [[PhotoInfo alloc] initWithImage:tempURLString]; //learned this - taylors meetup
                //NSLog(@"PhotoInfo photo %@", photo);
                [self.photos addObject:photo];

                //[self createPhotoClass:tempURLString];
                //NSLog(@"%@", tempURLDictionary);
            }
                 NSLog(@"self.photos %@", self.photos);
//                 [self.tableView reloadData];
        }
        NSLog(@"Connection Error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];
}

@end
