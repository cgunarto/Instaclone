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
#import "PhotoDetailViewController.h"
#import <Social/Social.h>

@interface FavoritePhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property NSArray *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation FavoritePhotosViewController


#pragma mark View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    PFQuery *query = [Photo query];
    [query whereKey:@"usersWhoFavorited" equalTo:[Instaclone currentProfile]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            self.photos = objects;

            //reload the collectionViewCell if there is a photo -- this will crash if it wasn't here
            if (self.photos.count > 0)
            {
                [self.collectionView reloadData];
            }
        }

    }];
}

#pragma mark Collection View Cell Methods

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *selectedPhoto = self.photos[indexPath.item];
    [self showPhotoDetailViewControllerForPhoto:selectedPhoto];
};


#pragma mark Helper Method

- (void) queryForFavPhotosAndReloadCell
{
    //Reloading the data
    PFQuery *query = [Photo query];
    [query whereKey:@"usersWhoFavorited" equalTo:[Instaclone currentProfile]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.photos = objects;
         [self.collectionView reloadData];
     }];
}

- (void)showPhotoDetailViewControllerForPhoto: (Photo *)photo
{
    PhotoDetailViewController *photoDetailVC = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([PhotoDetailViewController class])];
    photoDetailVC.selectedPhoto = photo;

    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

#pragma mark Long Press
//Long press on collection view cell to bring up options
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
                                       NSString *ourPhotoObjectID = photo.objectId;

                                       //Grabbing the most recent data of selected Photo
                                       PFQuery *queryPhoto = [Photo query];
                                       [queryPhoto whereKey:@"objectId" equalTo:ourPhotoObjectID];
                                       [queryPhoto getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                                        {
                                            PFObject *photo = object;
                                            photo = object;

                                            //Removing the current Profile from the usersWhoFavorited array
                                            NSMutableArray *usersWhoFavorited = [@[]mutableCopy];
                                            usersWhoFavorited = photo[@"usersWhoFavorited"];

                                            //Checking for the same profil with the same objectID
                                            for (Profile *profile in usersWhoFavorited)
                                            {
                                                if ([profile.objectId isEqual:[Instaclone currentProfile].objectId])
                                                {
                                                    [usersWhoFavorited removeObject:profile];
                                                }
                                            }

                                            NSArray *usersWhoFavoritedUpdatedArray = usersWhoFavorited;
                                            photo[@"usersWhoFavorited"] = usersWhoFavoritedUpdatedArray;

                                            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                                            {
                                                if (!error)
                                                {
                                                    [self queryForFavPhotosAndReloadCell];
                                                }
                                            }];
                                        }];

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


                                      Photo *photo = self.photos[selectedIndexPath.item];
                                      [photo.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                                      {
                                          [tweetSheet addImage:[UIImage imageWithData:data]];
                                      }];

                                      [self presentViewController:tweetSheet animated:YES completion:nil];
                                      [alert dismissViewControllerAnimated:YES completion:nil];

                                  }];

    UIAlertAction* fbButton = [UIAlertAction actionWithTitle:@"Share to Facebook!"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action)
                                  {
                                      SLComposeViewController *fbSheet = [SLComposeViewController
                                                                             composeViewControllerForServiceType:SLServiceTypeFacebook];
                                      [fbSheet setInitialText:@"I love this photo!"];


                                      Photo *photo = self.photos[selectedIndexPath.item];
                                      [photo.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                                       {
                                           [fbSheet addImage:[UIImage imageWithData:data]];
                                       }];

                                      [self presentViewController:fbSheet animated:YES completion:nil];
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
    [alert addAction:fbButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];

}



@end

























