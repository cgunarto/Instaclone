//
//  UpdateDetailViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "UploadDetailViewController.h"
#import <Parse/Parse.h>

@interface UploadDetailViewController ()

@property UIImageView *imageView;
@property UITextField *captionTextField;
@property UIButton *shareButton;

@end

@implementation UploadDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView.image = [UIImage imageWithData:self.imageToUploadData];
}

- (IBAction)onAddButtonPressed:(UIButton *)button
{
    PFObject *photo = [PFObject objectWithClassName:@"Photo"];
    photo[@"caption"] = self.captionTextField.text;

    [self uploadImage:self.imageToUploadData];
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

    //HUD creation here (see example for code)

    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)

            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *photo = [PFObject objectWithClassName:@"Photo"];
            [photo setObject:imageFile forKey:@"imageFile"];

            // Set the access control list to current user for security purposes
            photo.ACL = [PFACL ACLWithUser:[PFUser currentUser]];

            PFUser *user = [PFUser currentUser];
            [photo setObject:user forKey:@"user"];

            [photo saveInBackgroundWithBlock:nil];
        }
    }];
}


@end
