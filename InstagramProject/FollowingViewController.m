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
@property (nonatomic, strong) NSMutableArray *followingArray;

@end

@implementation FollowingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followingArray = [NSMutableArray new];

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
    [query whereKey:@"objectId" equalTo:ourProfilesObjectID];
    //referene pointers to
    [query includeKey:@"following"];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        Profile *ourRefreshProfile = (Profile *)object;
        
        [Instaclone currentClone].profile = ourRefreshProfile;

        self.followingArray = [ourRefreshProfile.following mutableCopy];
        [self.tableView reloadData];



    }];


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Profile *profile = self.followingArray[indexPath.row];

    cell.textLabel.text = profile.username;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.followingArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    //if selected, display an alertview, if select unfollow, query data, then
    UIAlertController *unfollowOrCancelAlert = [UIAlertController alertControllerWithTitle:@"Unfollow User?" message:@"Are you sure you want to unfollow this user?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *unfollow = [UIAlertAction actionWithTitle:@"Unfollow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 //we have that updated array, we just need to remove one
                                 [self.followingArray removeObjectAtIndex:indexPath.row];

                                 //reload the data after deletion
                                 [self.tableView reloadData];

                                 //setting updated array to our current profiles following attribute essentially updating it in memory
                                 [Instaclone currentProfile].following = self.followingArray;

                                 //share update with cloud through save in background
                                 [[Instaclone currentProfile] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                     nil;
                                 }];





                             }];
    [unfollowOrCancelAlert addAction:unfollow];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil];
    [unfollowOrCancelAlert addAction:cancel];

    [self presentViewController:unfollowOrCancelAlert animated:YES completion:nil];


}


@end
