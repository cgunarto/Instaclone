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

// added properties

@property NSArray *userPhotos;
@property NSString *dateString;
@property NSString *tag;

-(void)standardImageWithCompletionBlock:(void(^)(UIImage *))completionBlock;
-(void)usernameWithCompletionBlock:(void(^)(NSString *username))completionBlock;

@end
