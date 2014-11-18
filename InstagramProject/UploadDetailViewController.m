//
//  UpdateDetailViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "UploadDetailViewController.h"

@interface UploadDetailViewController ()

@property UIImageView *imageView;
@property UITextField *captionTextField;
@property UIButton *shareButton;

@end

@implementation UploadDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView.image = self.imageToUpload;
}




@end
