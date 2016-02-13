//
//  Hair_Test.h
//  Kiko
//
//  Created by Garrett Davidson on 2/12/16.
//  Copyright © 2016 G&R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Hair_Test : PFObject<PFSubclassing>

@property (nonatomic) NSString *name;
@property (nonatomic) PFFile *csv;

@end
