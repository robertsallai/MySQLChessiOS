//
//  ChessBoardViewController.m
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/20/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//

#import "ChessBoardViewController.h"

@interface ChessBoardViewController ()

@property (strong, nonatomic) NSMutableArray* matches;

@end

@implementation ChessBoardViewController

- (void) viewWillAppear:(BOOL)animated
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	switch (streamEvent) {
      
    case NSStreamEventNone:
      break;
      
		case NSStreamEventOpenCompleted:
			break;
      
    case NSStreamEventHasSpaceAvailable:
      break;
      
		case NSStreamEventHasBytesAvailable:
      
			if (theStream == self.connection.inputStream)
      {
				uint8_t buffer[2048];
				NSUInteger len;
				
				while ([self.connection.inputStream hasBytesAvailable])
        {
					len = [self.connection.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
          {
						NSString *response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != response)
            {
              [self.matches removeAllObjects];
              self.matches = [[NSMutableArray alloc] initWithArray:[response componentsSeparatedByString:@":"]];
            }
					}
				}
			}
			break;
			
		case NSStreamEventErrorOccurred:
      
			break;
			
		case NSStreamEventEndEncountered:
      
      [self.connection closeStreams];
      [self performSegueWithIdentifier:@"GameConnectionLost" sender:self];
			break;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    //Drawing the tiles of the board
    for (int i=0; i<8; i++){
      for (int j=0; j<8; j++){
        UIView *subview;
        CGRect frame = CGRectMake(0 + i *40, 60 + j*40, 40, 40);
        subview = [[UIView alloc] initWithFrame:frame];
        if ((i+1 * j+1 ) % 2) {
          subview.backgroundColor = [UIColor whiteColor];
        }
        else{
          subview.backgroundColor = [UIColor blueColor];
        }
        subview.alpha = 0.5;
        [self.view addSubview:subview];
        [self.view sendSubviewToBack:subview];
      }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end