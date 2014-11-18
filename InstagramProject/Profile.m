//
//  Profile.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Profile.h"

@implementation Profile

@dynamic username;
@dynamic name;
@dynamic user;
@dynamic email;
@dynamic profilePhoto;
@dynamic followers;
@dynamic following;

+ (void)load
{
    [self registerSubclass]; // need to have this
}

+ (NSString *)parseClassName
{
    return @"Profile"; /// have to return same name, same exact one as the class
}

@end
