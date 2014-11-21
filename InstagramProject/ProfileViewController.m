//
//  ProfileViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "ProfileViewController.h"
#import "PhotoCollectionViewCell.h"
#import <Parse/Parse.h>
#import "Profile.h"
#import "Photo.h"
#import "Instaclone.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property NSArray *photos;

@end

@implementation ProfileViewController


#pragma mark View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //Looking for all the photos with [Instaclone currentProfile] in the user row
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"user" equalTo:[Instaclone currentProfile]];
    [query orderByAscending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@", error.userInfo);
        }
        else
        {
            self.photos = objects;
            [self.collectionView reloadData];
        }
    }];

    //Setting the initial text, image and buttons to reflect user profile state
    self.usernameLabel.text = [Instaclone currentProfile].username;

    [[Instaclone currentProfile].profilePhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            self.profileImageView.image = image;
        }
    }];

    PFQuery *photoQuery = [Photo query];
    [photoQuery whereKey:@"user" equalTo:[Instaclone currentProfile]];
    [photoQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error)
    {
        self.postLabel.text = [NSString stringWithFormat:@"%d Posts", number];
    }];

    NSString *stringForFollower = [NSString stringWithFormat:@"%lu Followers",(unsigned long)[Instaclone currentProfile].followers.count];
    NSString *stringForFollowing = [NSString stringWithFormat:@"%lu Following",(unsigned long)[Instaclone currentProfile].following.count];

    [self.followersButton setTitle:stringForFollower forState:UIControlStateNormal];
    [self.followingButton setTitle:stringForFollowing forState:UIControlStateNormal];

}

#pragma mark Collection View Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

    Photo *photo = self.photos[indexPath.item];

    //TODO: move this into Photo.h and add completion block
    [photo.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        NSData *imageData = data;
        UIImage *image = [UIImage imageWithData:imageData];
        photoCell.cellImageView.image = image;
    }];
    return photoCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

//Makes sure photo is filling up the full width of the screen
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, width);
}

//- (IBAction)onImageTapped:(UITapGestureRecognizer *)sender
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Photo" message:@"Edit Photo?" preferredStyle:UIAlertControllerStyleActionSheet];
//
//    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
//                                                           style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction * action)
//                                   {
//                                       [alert dismissViewControllerAnimated:YES completion:nil];
//
//                                   }];
//
//    [alert addAction:cancelButton];
//    [self presentViewController:alert
//                       animated:YES
//                     completion:nil];
//}



@end
