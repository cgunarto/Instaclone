//
//  FollowersViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FollowersViewController.h"
//#import "Profile.h"
#import "Instaclone.h"

@interface FollowersViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *followersArray;

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshDisplay];
}

- (void)refreshDisplay
{
    Profile *ourProfile = [Instaclone currentProfile];
    NSString *ourProfilesObjectID = ourProfile.objectId;

    PFQuery *query = [Profile query];
    [query whereKey:@"objectID" equalTo:ourProfilesObjectID];
    [query orderByAscending:@"createdAt"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        Profile *ourRefreshProfile = (Profile *)object;
        self.followersArray = ourRefreshProfile.followers;

    }];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error, didn't refresh followers Array %@", error.localizedDescription);
        }
        else
        {
            self.followersArray = objects;

            [self.tableView reloadData];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Profile *object = self.followersArray[indexPath.row];
    cell.textLabel.text = object.name;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followersArray.count;
}

//-(void)AddFollowerToUser:(Profile *)profile
//{
//    //Need to declare block in profile.h and implement in.m
//    [Profile addFollowerWithName:[Instaclone currentProfile].username complete^(PFObject *object, NSError *error){
//    }];
//
//
//}



@end
