//
//  EditProfileViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Profile.h"

@interface EditProfileViewController () <UITextFieldDelegate>
@property Profile *profile;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self disableAllTextFieldEditing];

}

- (void)loadProfileInfo
{
    self.nameTextField.text = self.profile.name;
    self.usernameTextfield.text = self.profile.username;
    self.emailTextField.text = self.profile.email;
}

- (void)disableAllTextFieldEditing
{
    self.nameTextField.enabled = NO;
    self.usernameTextfield.enabled = NO;
    self.emailTextField.enabled = NO;
}

- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItem = self.doneButton;
    self.nameTextField.enabled = YES;
    self.usernameTextfield.enabled = YES;
    self.emailTextField.enabled = YES;
}

- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender
{
    if ([self.nameTextField.text isEqualToString:@""]||[self.usernameTextfield.text isEqualToString:@""]||[self.emailTextField.text isEqualToString:@""])
    {
        NSLog(@"Alert user here");
        //TODO: alert user if text is empty
    }

    else
    {
        self.navigationItem.rightBarButtonItem = self.editButton;
        [self disableAllTextFieldEditing];

        self.profile.name = self.nameTextField.text;
        self.profile.username = self.usernameTextfield.text;
        self.profile.email = self.emailTextField.text;

        [self.profile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            [self loadProfileInfo];
        }];
    }
}



@end
