//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import <UIKit/UIKit.h>

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {

        self.name = dictionary[@"name"];


        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

+ (NSArray *)eventsFromArray:(NSArray *)incomingArray
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:incomingArray.count];

    for (NSDictionary *d in incomingArray) {
        Event *e = [[Event alloc]initWithDictionary:d];
        [newArray addObject:e];
    }
    return newArray;
}

+ (void)getDataFromPerformSearchKeyWord:(NSString *)keyword withCompletionHandler:(void(^)(NSArray *events)) completion {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=4b6a576833454113112e241936657e47",keyword]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               if (!connectionError) {
                                   NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:nil] objectForKey:@"results"];

                                   NSArray *dataArray = [Event eventsFromArray:jsonArray];
                                   completion(dataArray);
                               }
                           }];
}

- (void)getCommentsWithEventID:(NSString *)eventID withCompletion:(void(^)(NSArray *comments))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=3818441843395d67181d73604a2b4d1d", eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                               
                               NSArray *jsonArray = [dict objectForKey:@"results"];
                               
                               completion([Comment objectsFromArray:jsonArray]);
                           }];
    
}

- (void)getImageWithURL:(NSURL *)url withCompletion:(void(^)(UIImage *image))completion {
    NSURLRequest *imageReq = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                completion([UIImage imageWithData:data]);
            }
        });
    }];
}

@end
















