//
//  CameraViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "CameraViewController.h"
#import <Parse/Parse.h>

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>

@property UIImagePickerController *imagePicker;
@property UIImageView *imageView; // IBOulet
@property UITextView *captionTextView; // IBOutlet
@property BOOL canTakePhoto;



@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.canTakePhoto = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    // So that tapping on other taps will NOT trigger the showCamera method
    self.tabBarController.delegate = nil;
}

- (void)showCamera
{
    if (self.canTakePhoto == YES)
    {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;

        [self presentViewController:camera animated:YES completion:nil];

        self.canTakePhoto = NO;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self showCamera];
}

- (void)uploadImage
{
    if (self.imageView.image)
    {
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.05f);

        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

        NSString *caption = self.captionTextView.text;

        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                NSLog(@"%@", error.userInfo);
            }
            else
            {
                PFObject *photo = [PFObject objectWithClassName:@"Photo"];
                [photo setObject:imageFile forKey:@"Image"];
                [photo setObject:caption forKey:@"Caption"];

                PFUser *currentUser = [PFUser currentUser];
                [photo setObject:currentUser forKey:@"currentUser"];

                [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error)
                    {
                        NSLog(@"%@", error.userInfo);
                    }
                    else
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        self.canTakePhoto = YES;
                    }
                }];
            }
        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please take a picture or choose a photo from your photo library" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


//MARK: IBAction Method

- (IBAction)onUploadImageButtonPressed:(id)sender
{
    [self uploadImage];
}

//MARK: Imagepicker delegate method

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.canTakePhoto = YES;
}



@end
