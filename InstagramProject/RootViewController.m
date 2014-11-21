//
//  ViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>
#import "Profile.h"
#import "Instaclone.h"
#import "Photo.h"
#import "MainFeedCollectionViewCell.h"

@interface RootViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) IBOutlet UIImageView *heartImage;

@property NSArray *arrayOfPhotoObjects;
@property NSMutableArray *allPhotoArray;

@property UIRefreshControl *refreshControl;


@end

@implementation RootViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];

    NSLog(@"viewwillappear called");
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"viewdidload called");

    //Setup required taps
    [self.tapGesture setNumberOfTapsRequired:2];
    [self.tapGesture setNumberOfTouchesRequired:1];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(downloadAllImages:) forControlEvents:UIControlEventValueChanged];

    [self.collectionView addSubview:self.refreshControl];
}

- (IBAction)onTapToAddToFavoritePhoto:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point = [tapGesture locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

        if (indexPath)
        {
            Photo *photoToFavorites = self.allPhotoArray[indexPath.item];

            [photoToFavorites addObject:[Instaclone currentProfile] forKey:@"usersWhoFavorited"];
            [photoToFavorites save];

            [self.collectionView reloadData];
            photoToFavorites.isFavorited = YES;
        }
    }
}




#pragma mark Collection View Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allPhotoArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainFeedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    Photo *photoPost = self.allPhotoArray[indexPath.row];

    if (photoPost.isFavorited)
    {
        [UIView animateWithDuration:0.7
                         animations:^{
                             cell.heartImageView.image = [UIImage imageNamed:@"solid_gray_heart"];
                             cell.heartImageView.alpha =1.0f;
                             cell.heartImageView.alpha =0.0f;
                         }];
    }

    // need to retrieve photos...
    [photoPost.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        if (!error)
        {
            cell.imageView.image = [UIImage imageWithData:data];
        }
    }];

    return cell;
}

-(void)manageLogin
{
    if (![PFUser currentUser]) {

        //Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields:PFLogInFieldsDefault  |PFLogInFieldsDismissButton];


        //Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self];

        //Assign our sign up controler to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];

        //Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:nil];

    }

    // Go to Mainfeed VC

    else
    {
        PFQuery *profileQuery = [Profile query];
        [profileQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        Instaclone *clone = [Instaclone currentClone];

        [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object) {
                clone.profile = (Profile *)object;
                [self downloadAllImages:self.refreshControl];
            }
        }];
        
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self manageLogin];
}

- (IBAction)onLogoutButtonPressed:(id)sender
{
    [PFUser logOut];
    
    [self.allPhotoArray removeAllObjects];
    [self.collectionView reloadData];
    [self manageLogin];
}



- (void)downloadAllImages:(UIRefreshControl *)refreshControl;
{
    self.allPhotoArray =[@[]mutableCopy];
    //Getting my own photos
    PFQuery *query = [PFQuery queryWithClassName:[Photo parseClassName]];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[Instaclone currentProfile]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {


        if (error)
        {
            NSLog(@"\n\nError: %@",error);
            [refreshControl endRefreshing];
        }
        else
        {
            for (Photo *photo in objects)
            {
                [self.allPhotoArray addObject:photo];
            }

            NSArray *followingArray = [Instaclone currentProfile].following;

            if (followingArray.count == 0)
            {
                [refreshControl endRefreshing];
                return;
            }

            for (Profile *following in followingArray)
             {
                 PFQuery *query = [PFQuery queryWithClassName:[Photo parseClassName]];
                 [query orderByDescending:@"createdAt"];
                 [query whereKey:@"user" equalTo:following];

                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
                  {
                      if (error)
                      {
                          NSLog(@"Error: %@",error);
                      }
                      else
                      {
                                 NSLog(@"\n\nxxxxxxxxobjecx2 %@%@", objects, error);

                          for (Photo *photo in objects)
                          {
                              [self.allPhotoArray addObject:photo];
                          }

                          [self.collectionView reloadData];

                      }

                       [refreshControl endRefreshing];
                  }];
             }

        }
    }];


}

#pragma mark - PfLoginViewController Delegate Methods

//Sent to the delegate to determine whether the log in request should be submitted to server
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    //Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        //Begin login process
        return YES;
    }

    [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    //Interrupt login process
    return NO;
}

//Sent to the delegate when a PFUser is logged in
- (void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

//Sent to delegate when login attempt fails
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Failed to log in");
}

//Sent to delegate when the log in screen is dismissed
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PfSignupViewController Delegate Methods

//Sent to the delegate to determine whether signup request should be submitted to server
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;

    //Loop through all submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }

    //Display an alert if field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"Make sure you fill out all of the information" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }

    return informationComplete;
}

//Sent the delegate when a PFUser is signed up
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    Profile *profile = [Profile object];
    profile.email = user.email;
    profile.username = user.username;
    profile.user = user;

    Instaclone *clone = [Instaclone currentClone];

    [profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(error)
        {
            NSLog(@"%@", error.localizedDescription);
        }
        else
        {
            clone.profile = profile;
        }
    }];


    //Dismiss PFSignUpViewController;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Sent the delegate when the sign up attempt fails
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog( @"Failed to sign up");
}

//Sent the delegate when the sign up screen is dismised
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User dismissed the signupViewController");
}




@end
