//
//  PhotoDetailViewController.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/17/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "PhotoDetailViewController.h"

@interface PhotoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // need custom tableview cell here

    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell"];

    //UserName
    [self.selectedPhoto usernameWithCompletionBlock:^(NSString *username) {
//        cell.usernameLabel.text = username;
    }];

    //Image
    [self.selectedPhoto standardImageWithCompletionBlock:^(UIImage *photo) {
//        cell.photo.image = photo;
    }];

    //PhotoCaption
//    cell.captionTextView.text = self.selectedPhoto.caption;

    //TimeLabel
    cell.textLabel.text = self.selectedPhoto.dateString;

    return cell;
}

@end
