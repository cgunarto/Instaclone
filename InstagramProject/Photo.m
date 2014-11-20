//
//  Photo.m
//  InstagramProject
//
//  Created by Jonathan Kim on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@dynamic photoFile;
@dynamic user;
@dynamic caption;

@dynamic userPhotos;
@dynamic dateString;
@dynamic tag;
@dynamic usersWhoFavorited;


//MARK: Parse methods
+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Photo";
}

-(NSString *)dateString
{
    NSDate *date = self.createdAt;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *creationDate = [dateFormat stringFromDate:date];
    
    return creationDate;

}

-(void)standardImageWithCompletionBlock:(void(^)(UIImage *))completionBlock
{
    [self.photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        completionBlock([UIImage imageWithData:data]);
    }];
}

-(void)usernameWithCompletionBlock:(void(^)(NSString *username))completionBlock {

    [[Instaclone currentProfile] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        completionBlock([Instaclone currentProfile].username);
    }];
}


@end
