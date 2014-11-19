//
//  Profile.h
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@class Profile;

@interface Profile : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) PFFile *profilePhoto;
@property (nonatomic, strong) NSArray *followers;
@property (nonatomic, strong) NSArray *following;


@end
