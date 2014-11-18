//
//  Instaclone.h
//  InstagramProject
//
//  Created by Supreme Overlord on 11/18/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"

@interface Instaclone : NSObject

+(instancetype)currentClone;
+(Profile *)currentProfile;

@property (nonatomic, strong) Profile *profile;

@end
