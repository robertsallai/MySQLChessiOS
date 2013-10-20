//
//  Chesspiece.h
//  MySQLChess
//
//  Created by Robert Sallai on 9/9/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chesspiece : NSObject

@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSInteger value;
@property (nonatomic, getter = isPlayable) BOOL playable;

@end
