//
//  CameraViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "CameraViewController.h"
#import "UploadDetailViewController.h"
#import "UIImage+Resize.h"
#import <Parse/Parse.h>

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property NSData *imageToUploadData;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showCameraController];
}

- (void)showCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    imagePicker.cameraOverlayView = nil;
    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];
    }

    else

    // if camera is not available
    {
        return;
    }
}

//MARK: UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);

    UIImage *imageToUpload = [originalImage thumbnailImage:750 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];

    // segue to UPLOAD PHOTO VC
    [self performSegueWithIdentifier:@"toUploadDetailVCSegue" sender:self];

    // If the user returns to this VC from UPLOAD PHOTO VC - this vc will be empty.
    [self dismissViewControllerAnimated:NO completion:nil];

    // Upload image
    self.imageToUploadData = UIImageJPEGRepresentation(imageToUpload, 0.05f);
}



//- (void)refresh
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error)
//        {
//            //
//        }
//        else
//        {
//            self.people = objects;
//        }
//    }];
//}


//MARK: Prepare for Segue to Upload Detail VC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUploadDetailVCSegue"])
    {
        UploadDetailViewController *uploadPhotoVC = segue.destinationViewController;
        uploadPhotoVC.imageToUploadData = self.imageToUploadData;
    }
}




@end
