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

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIImage *imageToUpload;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self showCameraController];
}

- (void)showCameraController
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
    {
        // Camera is not available
        return;
    }
    UIImagePickerController *camera = [[UIImagePickerController alloc] init];
    camera.sourceType = UIImagePickerControllerSourceTypeCamera;
    camera.allowsEditing = NO;
    camera.cameraOverlayView = nil;
    camera.delegate = self;

    [self presentViewController:camera animated:YES completion:nil];
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

    self.imageToUpload = [originalImage thumbnailImage:750 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];

    // segue to UPLOAD PHOTO VC
    [self performSegueWithIdentifier:@"toUploadDetailVCSegue" sender:self];

    // If the user returns to this VC from UPLOAD PHOTO VC - this vc will be empty.
    [self dismissViewControllerAnimated:NO completion:nil];
}


//MARK: Prepare for Segue to Upload Detail VC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toUploadDetailVCSegue"])
    {
        UploadDetailViewController *uploadPhotoVC = segue.destinationViewController;
        uploadPhotoVC.imageToUpload = self.imageToUpload;
    }
}




@end
