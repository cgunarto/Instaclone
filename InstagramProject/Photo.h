//
//  Photo.h
//  InstagramProject
//
//  Created by Jonathan Kim on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Parse/Parse.h>
#import "Instaclone.h"

@class Profile;
@class Photo;

typedef void (^PhotoResultBlock)(Photo *photo, NSError *error);

@interface Photo : PFObject <PFSubclassing>

@property Profile *user;
@property PFFile *photoFile;
@property NSString *caption;

// added properties

@property NSArray *userPhotos;
@property NSString *dateString;
@property NSString *tag;
@property NSMutableArray *usersWhoFavorited;

@property BOOL isFavorited;


-(void)standardImageWithCompletionBlock:(void(^)(UIImage *))completionBlock;
-(void)usernameWithCompletionBlock:(void(^)(NSString *username))completionBlock;

@end
