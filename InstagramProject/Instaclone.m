//
//  Instaclone.m
//  InstagramProject
//
//  Created by Supreme Overlord on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Instaclone.h"
#import "Profile.h"
@implementation Instaclone

+(instancetype)currentClone
{
    static Instaclone *myProfile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        myProfile = [[self alloc] init];

    });
    return myProfile;
}

+(Profile *)currentProfile
{
    return [[Instaclone currentClone] profile];
}
@end
