//
//  FavoritePhotosViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "FavoritePhotosViewController.h"
#import "Instaclone.h"
#import "Photo.h"

@interface FavoritePhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property NSArray *photos;

@end

@implementation FavoritePhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favoriteCell" forIndexPath:indexPath];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}






@end
