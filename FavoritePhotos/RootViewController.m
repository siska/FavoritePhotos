//
//  ViewController.m
//  FavoritePhotos
//
//  Created by S on 10/16/14.
//  Copyright (c) 2014 Ryan Siska. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoInfo.h"
#import "ImageCollectionViewCell.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property NSMutableArray *photos;
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [[NSMutableArray alloc] init];
    [self getPhotos:@"chicago"];
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
                PhotoInfo *photo = [[PhotoInfo alloc] initWithImage:tempURLString]; //learned this - taylors meetup project implementation
                //NSLog(@"PhotoInfo photo %@", photo);
                [self.photos addObject:photo];
            }
                 NSLog(@"self.photos %@", self.photos);
//                 [self.tableView reloadData];
        }
        NSLog(@"Connection Error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];
}

#pragma mark - CollectionView Delegates

-(ImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCellID" forIndexPath:indexPath];
    NSInteger indexOfCurrentCollectionCell = [indexPath item];
    PhotoInfo *photoForCell = [[self photos] objectAtIndex:indexOfCurrentCollectionCell];

    cell.imageView.image = photoForCell.image;
    //photoForCell.delegate = self;
    NSLog(@"Finished the cellForItem...");
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    [self getPhotos:searchTerm];
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
