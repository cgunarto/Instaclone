//
//  PhotoDetailViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Instaclone.h"
#import "Comment.h"

@interface PhotoDetailViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;

@property NSArray *commentsArray;

@end

@implementation PhotoDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshDisplay];

//    Profile *profile = [Profile object];
//
//    if (![profile.following containsObject:self.selectedPhoto.user.username])
//    {
//        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.selectedPhoto standardImageWithCompletionBlock:^(UIImage *selectedPhoto) {
        self.imageView.image = selectedPhoto;
    }];

    Profile *profile = self.selectedPhoto.user;
    PFQuery *query = [Profile query];
    [query whereKey:@"objectId" equalTo:profile.objectId];

    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        PFObject *profile = object;

        self.usernameLabel.text = profile[@"username"];
    }];

//    self.usernameLabel.text = self.selectedPhoto.user.username;

//    [self.selectedPhoto usernameWithCompletionBlock:^(NSString *username) {
//        self.usernameLabel.text = username;
//    }];

//    if (![self.selectedPhoto.usersWhoFavorited containsObject:self.selectedPhoto])
//    {
//        [self.favoriteButton setTitle:@"Favorite" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.favoriteButton setTitle:@"Unfavorite" forState:UIControlStateNormal];
//    }

    [self.tableView reloadData];
}

// follow button
- (IBAction)onFollowButtonPressed:(UIButton *)sender
{
    [self.selectedPhoto usernameWithCompletionBlock:^(NSString *username) {
        Profile *following = [Profile object];

        [following addObject:username forKey:@"following"];
        [following save];
    }];

//
//    Profile *following = [Profile object];
//
//    [following addObject:[Instaclone currentProfile] forKey:@"following"];
//    [following save];
}


// favorite button

- (IBAction)onFavoriteButtonPressed:(UIButton *)sender
{

    [self.selectedPhoto addObject:[Instaclone currentProfile] forKey:@"usersWhoFavorited"];
    [self.selectedPhoto save];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}
- (IBAction)onCommentButtonPressed:(UIButton *)sender
{
    Comment *comment = [Comment object];
    comment.text = self.commentTextField.text;
    comment.photo = self.selectedPhoto;
    comment.userWhoCommented = [Instaclone currentProfile];

    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            [self refreshDisplay];
        }
    }];

    [self.commentTextField resignFirstResponder];
}

- (void)refreshDisplay
{
    PFQuery *queryComments = [Comment query];
    [queryComments whereKey:@"photo" equalTo:self.selectedPhoto];
    [queryComments orderByDescending:@"createdAt"];
    [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            self.commentsArray = objects;
            [self.tableView reloadData];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // need custom tableview cell here

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Comment *comment = self.commentsArray[indexPath.row];
    cell.textLabel.text = comment.text;
    cell.detailTextLabel.text = comment.dateString;

    // below code not working..
//    cell.detailTextLabel.text = comment.userWhoCommented.username;

    return cell;
}

@end
