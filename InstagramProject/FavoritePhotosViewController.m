//
//  FavoritePhotosViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FavoritePhotosViewController.h"
#import "Instaclone.h"
#import "FavPhotoCollectionViewCell.h"
#import "Photo.h"

@interface FavoritePhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSArray *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FavoritePhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    PFQuery *query = [Photo query];
    NSArray *userWhoFavorited = @[[Instaclone currentProfile]];
    [query whereKey:@"userWhoFavorited" containsAllObjectsInArray:userWhoFavorited];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        self.photos = objects;
        [self.collectionView reloadData];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favoriteCell" forIndexPath:indexPath];
    cell.imageView.image = self.photos[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}






@end
