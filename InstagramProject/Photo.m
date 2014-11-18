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


//MARK: Parse methods
+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Photo";
}

@end
