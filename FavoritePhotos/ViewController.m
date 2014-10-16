//
//  ViewController.m
//  FavoritePhotos
//
//  Created by S on 10/16/14.
//  Copyright (c) 2014 Ryan Siska. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadPhotos:@"chicago"];
}

- (void)loadPhotos:(NSString *)urlString
    {
        [super viewDidLoad];
        NSString *string = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=de07f6709b3a418683cb2f43a2729de2&callback=callbackFunction=json", urlString];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@", jsonString); //used to see if correctly retrieving data

             NSError *jsonError = nil;

//             if (data)
//             {
//                 NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//                 self.eventsInfoArray = [tempDict objectForKey:@"results"];
//
//                 [self.tableView reloadData];
//             }

             NSLog(@"Connection Error: %@", connectionError);
             NSLog(@"JSON Error: %@", jsonError);
         }];
    }

@end
