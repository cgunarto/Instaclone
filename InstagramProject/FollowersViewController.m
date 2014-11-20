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
@property (strong, nonatomic) NSMutableArray *followersArray;
@property (strong, nonatomic) NSMutableArray *followingArray;
@property Profile *profile;
@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.followersArray = [NSMutableArray new];

    [self refreshDisplay];
}

- (void)refreshDisplay
{
    Profile *ourProfile = [Instaclone currentProfile];
    NSString *ourProfilesObjectID = ourProfile.objectId;

    PFQuery *query = [Profile query];
    [query whereKey:@"objectId" equalTo:ourProfilesObjectID];
    [query includeKey:@"followers"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        Profile *ourRefreshProfile = (Profile *)object;

        [Instaclone currentClone].profile = ourRefreshProfile;

        self.followersArray = [ourRefreshProfile.followers mutableCopy];
        self.followingArray = [ourRefreshProfile.following mutableCopy];



        [self.tableView reloadData];

    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Profile *follower = self.followersArray[indexPath.row];
    for (Profile *following in self.followingArray) {
        if ([following.objectId isEqual:follower.objectId]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

    cell.textLabel.text = follower.username;


//    // compare table view items (everyone) to list of followers
//    [Instaclone currentProfile].followers = self.followersArray;
//
//
//
//    NSArray *array = [Instaclone currentProfile].followers;
//
//    for(Profile *follower in array){
//
//        // compare currentProfile for TB to item in followers
//
//        if()
//
//
//    }
//
//
//    NSString *objectId = array[@"objectId"];




    //[Instaclone currentProfile].following = profile.following;

//    NSString *followingObjectID = ourProfile.ob;
//
//    if (followingObjectID == followerObjectID) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.followersArray.count;
}



@end
