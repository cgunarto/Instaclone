//
//  SearchViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "SearchViewController.h"
#import "Photo.h"
#import "PhotoCollectionViewCell.h"
#import "PhotoDetailViewController.h"

@interface SearchViewController ()<UICollectionViewDataSource, UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *photosArray;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//Query all the photos with some tag associated to it

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *textResult = searchBar.text;
    PFQuery *queryTaggedPhotos =[Photo query];

    //TODO:can you search through an array with ContainsString? May need to use string StringWithFormat
    [queryTaggedPhotos whereKey:@"tag" containsString:textResult];

    [queryTaggedPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            self.photosArray = objects;
            [self.collectionView reloadData];
        }

    }];

    [self resignFirstResponder];
}

#pragma mark Collection View Cell Delegate Method

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    Photo *photo = self.photosArray[indexPath.item];

    [photo.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        cell.cellImageView.image = [UIImage imageWithData:data];
    }];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photosArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = self.photosArray[indexPath.item];
    [self performSegueWithIdentifier:@"segueToPhotoDetail" sender:photo];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Photo *)photo
{
    PhotoDetailViewController *photoDetailVC = segue.destinationViewController;
    photoDetailVC.selectedPhoto = photo;
}


@end
