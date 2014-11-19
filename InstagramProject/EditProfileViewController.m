//
//  EditProfileViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Profile.h"
#import "Instaclone.h"


@interface EditProfileViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate>
//@property Profile *profile;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) NSMutableArray *capturedImages;

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
    self.nameTextField.text = [Instaclone currentProfile].name;
    self.usernameTextfield.text = [Instaclone currentProfile].username;
    self.emailTextField.text = [Instaclone currentProfile].email;
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"EMPTY SPACES"
                                                                       message:@"Please make sure there are no blank fields"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alert addAction:okButton];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];

    }

    else
    {
        self.navigationItem.rightBarButtonItem = self.editButton;
        [self disableAllTextFieldEditing];

        [Instaclone currentProfile].name = self.nameTextField.text;
        [Instaclone currentProfile].username = self.usernameTextfield.text;
        [Instaclone currentProfile].email = self.emailTextField.text;

        [[Instaclone currentProfile] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            [self loadProfileInfo];
        }];
    }
}

- (IBAction)showImagePickerForEditPhoto:(UIButton *)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;

    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:NULL];

    NSData *imageData = UIImagePNGRepresentation(image);
    [Instaclone currentProfile].profilePhoto = imageData;

    [[Instaclone currentProfile] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.profileImageView.image = image;
    }];

    self.imagePickerController = nil;

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
