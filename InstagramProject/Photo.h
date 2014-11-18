//
//  Photo.h
//  InstagramProject
//
//  Created by Jonathan Kim on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Parse/Parse.h>

@class Profile;

@interface Photo : PFObject <PFSubclassing>

@property Profile *user;
@property PFFile *photoFile;
@property NSString *caption;

@end
