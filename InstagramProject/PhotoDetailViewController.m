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
@property (strong, nonatomic) IBOutlet UIButton *followButton;

@property NSArray *commentsArray;

@end

@implementation PhotoDetailViewController

// viewwillappear not working...

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

    if (![self.selectedPhoto.usersWhoFavorited containsObject:[Instaclone currentProfile]])
    {
        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
    else
    {
        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.selectedPhoto standardImageWithCompletionBlock:^(UIImage *selectedPhoto) {
        self.imageView.image = selectedPhoto;
    }];

    [self.selectedPhoto usernameWithCompletionBlock:^(NSString *username) {
        self.usernameLabel.text = username;
    }];

    [self.tableView reloadData];
}

// following button

- (IBAction)onFollowButtonPressed:(UIButton *)sender
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
