//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import "MemberViewController.h"

@interface MemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Member *member;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.alpha = 0;

    // refactored to class method
    [Member getMemberInformationWithID:self.memberID andCompletionHandler:^(Member *memberInfo) {
        self.member = memberInfo;
    }];
}

- (void)setMember:(Member *)member
{
    _member = member;
    self.nameLabel.text = member.name;

    // refactored to instance method
    [self.member getImageWithURL:member.photoURL andCompletionHandler:^(UIImage *image) {
        self.photoImageView.image = image;

        [UIView animateWithDuration:.3 animations:^{
            self.photoImageView.alpha = 1;
        }];
    }];
}



@end













