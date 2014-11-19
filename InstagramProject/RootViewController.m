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

@interface RootViewController ()<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //FBLoginView *loginView = [[FBLoginView alloc] init];
    //loginView.center = self.view.center;
    //[self.view addSubview:loginView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
    PFQuery *profileQuery = [Profile query];
    [profileQuery whereKey:@"user" equalTo:user];
    [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            Instaclone *clone = [Instaclone currentClone];
            clone.profile = (Profile *)object;
        }
    }];


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

    PFQuery *profileQuery = [Profile query];
    [profileQuery whereKey:@"user" equalTo:user];
    [profileQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            Instaclone *clone = [Instaclone currentClone];
            clone.profile = (Profile *)object;

        }
    }];


    NSString *name = 


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
