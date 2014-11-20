//
//  Comment.h
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/19/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Parse/Parse.h>
#import "Photo.h"
#import "Profile.h"

@interface Comment : PFObject <PFSubclassing>

@property Photo* photo;
@property NSString *text;
@property Profile *userWhoCommented;
@property NSString *dateString;

@end
