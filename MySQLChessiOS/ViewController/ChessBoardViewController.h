//
//  ChessBoardViewController.h
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/20/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketConnection.h"

@interface ChessBoardViewController : UIViewController <NSStreamDelegate>

@property (strong, nonatomic) SocketConnection* connection;

@end
