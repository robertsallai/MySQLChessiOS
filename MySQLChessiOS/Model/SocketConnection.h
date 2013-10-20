//
//  SocketConnection.h
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/20/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketConnection : NSObject

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

- (void) login:(NSString *) message;
- (void) listMatches;
- (void) unlistFromLiveUpdate;
- (void) createMatch;
- (BOOL) joinMatch:(NSUInteger) matchID;
- (void) initializeServerConnection;
- (void) closeStreams;

+ (SocketConnection *) getSingletonInstance;

@end
