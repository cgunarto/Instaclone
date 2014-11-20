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
#import <Social/Social.h>

@interface FavoritePhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
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
    Photo *photo = self.photos[indexPath.item];
    
    [photo.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (!error)
        {
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image = image;
        }
    }];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, width);
}

- (IBAction)onPhotoLongPressed:(UILongPressGestureRecognizer *)gesture
{
    CGPoint selectedPoint = [gesture locationInView:self.collectionView];
    NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:selectedPoint];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"DELETE" message:@"Delete Photo?" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:@"Delete"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       Photo *photo = self.photos[selectedIndexPath.item];
                                       //remove user from photo's userWhoFavorited array.
                                    


                                       [self.collectionView reloadData];
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];

    //Add Twitter send
    UIAlertAction* tweetButton = [UIAlertAction actionWithTitle:@"Tweet it!"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                  {
                                      SLComposeViewController *tweetSheet = [SLComposeViewController
                                                                             composeViewControllerForServiceType:SLServiceTypeTwitter];
                                      [tweetSheet setInitialText:@"I love this photo!"];


                                      [tweetSheet addImage:[UIImage imageWithData:self.favoritedPhotosArray[selectedIndexPath.item]]];

                                      [self presentViewController:tweetSheet animated:YES completion:nil];

                                      [alert dismissViewControllerAnimated:YES completion:nil];

                                  }];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    
    [alert addAction:deleteButton];
    [alert addAction:tweetButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];

}



@end

























