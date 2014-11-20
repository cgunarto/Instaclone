//
//  Comment.m
//  InstagramProject
//
//  Created by CHRISTINA GUNARTO on 11/19/14.
//  Copyright (c) 2014 Christina Gunarto. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic photo;
@dynamic text;
@dynamic userWhoCommented;
@dynamic dateString;

+ (void)load
{
    [self registerSubclass];
}

+ (NSString *)parseClassName
{
    return @"Comment";
}

-(NSString *)dateString
{
    NSDate *date = self.createdAt;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
    NSString *creationDate = [dateFormat stringFromDate:date];

    return creationDate;

}

@end
