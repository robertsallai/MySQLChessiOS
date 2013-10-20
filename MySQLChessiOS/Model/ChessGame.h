//
//  ChessGame.h
//  MySQLChess
//
//  Created by Robert Sallai on 9/9/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessGame : NSObject
@property (strong, nonatomic) NSString *playerColor;
@property (nonatomic) NSUInteger plycount;
@end
