//
//  SocketConnection.m
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/20/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//
//  Class for maintaining a TCP socket connection - uses the Singleton Design Pattern with Grand Central Dispatch


#import "SocketConnection.h"

@implementation SocketConnection


- (id)init
{
  self = [super init];
  
  if (self)
  {
    [self initializeServerConnection];
  }
  return self;
}

- (void) initializeServerConnection{
  
  CFReadStreamRef readStream;
  CFWriteStreamRef writeStream;
  
  CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"188.142.140.97", 70, &readStream, &writeStream);
  
  self.inputStream = (__bridge NSInputStream *)readStream;
  self.outputStream = (__bridge NSOutputStream *)writeStream;
  
  [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [self.inputStream open];
  [self.outputStream open];
  
}

- (void) closeStreams{
  [self.inputStream close];
  [self.outputStream close];
  [self.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

+ (SocketConnection *) getSingletonInstance{
  static SocketConnection *sharedSocketConnection = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{ sharedSocketConnection = [[self alloc] init]; });
  return sharedSocketConnection;
}

- (void) login:(NSString *) message
{
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void) logout{
  NSString *message = @"logout";
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void) listMatches
{
  NSString *message = @"list";
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
  [self.outputStream write:[data bytes] maxLength:[data length]];
}

-(void) unlistFromLiveUpdate
{
  NSString *message = @"unlist";
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
  [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void) createMatch
{
  NSString *message = @"create";
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
  [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (BOOL) joinMatch:(NSUInteger)matchID
{
  return TRUE;
}

@end