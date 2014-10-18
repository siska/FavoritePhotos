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
    [self getPhotos:@"Chicago"];
}

- (void)getPhotos:(NSString *)urlString
{
    NSLog(@"getting URL sent from search: %@", urlString);
    [super viewDidLoad];

    self.navigationItem.title = urlString;

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
                if (self.photos.count < 10)
                {
                    NSDictionary *tempImagesDictionary = [tempDictionary objectForKey:@"images"];
                    NSDictionary *tempLowResDictionary = [tempImagesDictionary objectForKey:@"low_resolution"];
                    NSString *tempURLString = [tempLowResDictionary objectForKey:@"url"];

                    PhotoInfo *photo = [[PhotoInfo alloc] initWithImage:tempURLString]; //learned this - taylors meetup project implementation
                    [self.photos addObject:photo];
                }
            }
            NSLog(@"self.photos %@", self.photos);
            [self.imageCollectionView reloadData];
            [self.imageCollectionView setContentOffset:CGPointZero animated:YES];
        }
        NSLog(@"Connection Error: %@", connectionError);
        NSLog(@"JSON Error: %@", jsonError);
    }];
}

#pragma mark - CollectionView Delegates

-(ImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"reached the cellForItem...");
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCellID" forIndexPath:indexPath];
    NSInteger indexOfCurrentCollectionCell = [indexPath item];
    PhotoInfo *photoForCell = [[self photos] objectAtIndex:indexOfCurrentCollectionCell];

    cell.imageView.image = photoForCell.image;
    //photoForCell.delegate = self;
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    [self.photos removeAllObjects];
    [self getPhotos:searchTerm];

    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
