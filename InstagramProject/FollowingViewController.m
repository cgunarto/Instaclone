//
//  FollowingViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FollowingViewController.h"
#import "Instaclone.h"

@interface FollowingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *followingArray;

@end

@implementation FollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Profile *profile = [Profile object];
    profile.username = @"Test Name";
    [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            [self refreshDisplay];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDisplay];
}

-(void)refreshDisplay
{
    Profile *ourProfile = [Instaclone currentProfile];
    NSString *ourProfilesObjectID = ourProfile.objectId;

    PFQuery *query = [Profile query];
    [query whereKey:@"objectID" equalTo:ourProfilesObjectID];
    [query orderByAscending:@"createdAt"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        Profile *ourRefreshProfile = (Profile *)object;
        self.followingArray = ourRefreshProfile.followers;

    }];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error, didn't refresh followers Array %@", error.localizedDescription);
        }
        else
        {
            self.followingArray = objects;

            [self.tableView reloadData];
        }
    }];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Profile *object = self.followingArray[indexPath.row];
    cell.textLabel.text = object.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followingArray.count;
}


@end
