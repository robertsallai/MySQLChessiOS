//
//  Match.h
//  MySQLChessiOS
//
//  Created by Robert Sallai on 10/7/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Match : NSObject

@property (nonatomic) NSUInteger matchID;
@property (strong, nonatomic) NSString *whitePlayer;
@property (nonatomic) NSUInteger wins;
@property (nonatomic) NSUInteger losses;
@property (nonatomic) NSUInteger ties;

@end
