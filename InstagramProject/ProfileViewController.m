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


@property NSArray *photos;

@end

@implementation ProfileViewController

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
        }
    }];

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
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];

    Photo *photo = self.photos[indexPath.item];
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



@end
