//
//  CommentsTableViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "MemberViewController.h"
#import "CommentTableViewCell.h"
#import "CommentsTableViewController.h"

@interface CommentsTableViewController ()

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;

@end

@implementation CommentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // refactored to instance method
    [self.event getCommentsWithEventID:self.event.eventID withCompletion:^(NSArray *comments) {
        self.dataArray = comments;
    }];

    self.dateFormatter = [[NSDateFormatter alloc]init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    Comment *c = self.dataArray[indexPath.row];
    cell.authorLabel.text = c.author;
    cell.commentLabel.text = c.text;
    cell.dateLabel.text = [self.dateFormatter stringFromDate:c.date];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MemberViewController *memberVC = [segue destinationViewController];

    Comment *comment = self.dataArray[[self.tableView indexPathForSelectedRow].row];
    memberVC.memberID = comment.memberID;
}


@end
