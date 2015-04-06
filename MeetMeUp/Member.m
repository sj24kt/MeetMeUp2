//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import <UIKit/UIKit.h>

@implementation Member

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
    }
    return self;
}

- (void)getImageWithURL:(NSURL *)url andCompletionHandler:(void(^)(UIImage *image))completion {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        completion([UIImage imageWithData:data]);
    }];
}

+ (void)getMemberInformationWithID:(NSString *)memberId andCompletionHandler:(void(^)(Member *memberInfo))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=3818441843395d67181d73604a2b4d1d", memberId]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               completion([[Member alloc]initWithDictionary:dict]);
                           }];
}

@end














