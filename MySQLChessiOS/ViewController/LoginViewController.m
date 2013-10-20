//
//  LoginViewController.m
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/20/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//
//  TODO:
//  Create a selector method for reinitializing the Stream so it can be performed after segueing back
//

#import "LoginViewController.h"
#import "SocketConnection.h"
#import "GameBrowserTableViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) SocketConnection *connection;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *streamStatusLabel;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.connection = [SocketConnection getSingletonInstance];
}

-(void)viewWillAppear:(BOOL)animated{
  [self.connection.inputStream setDelegate:self];
  [self.connection.outputStream setDelegate:self];
}

//Stream Event Handler for login
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	switch (streamEvent) {
      
    case NSStreamEventNone:
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
      break;
      
		case NSStreamEventOpenCompleted:
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
			break;
      
    case NSStreamEventHasSpaceAvailable:
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
      break;
      
		case NSStreamEventHasBytesAvailable:
      
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
      
			if (theStream == self.connection.inputStream)
      {
				uint8_t buffer[1024];
				NSUInteger len;
				
				while ([self.connection.inputStream hasBytesAvailable])
        {
					len = [self.connection.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
          {
						NSString *response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (response)
            {
              BOOL login = [response integerValue];
              if (login)
              {
                self.feedBackLabel.text = @"Sikeres bejelentkezes";
                [self performSegueWithIdentifier:@"LoginSegue" sender:self];
              }
              else
              {
                self.feedBackLabel.text = @"Sikertelen bejelentkezes";
              }
						}
					}
				}
			}
			break;
						
		case NSStreamEventEndEncountered:
      
      self.feedBackLabel.text = @"Connection lost";
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
      [self.connection closeStreams];

			break;
      
    case NSStreamEventErrorOccurred:
      self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
			break;
	}
}
- (IBAction)getStreamStatus:(UIButton *)sender {
  
  [self.connection closeStreams];
  [self.connection initializeServerConnection];
  [self.connection.inputStream setDelegate:self];
  [self.connection.outputStream setDelegate:self];
  self.streamStatusLabel.text = [NSString stringWithFormat:@"%d", [self.connection.inputStream streamStatus]];
}

- (IBAction)login:(UIButton *)sender
{
  // The description of an NSString is the string itself
  self.streamStatusLabel.text = [NSString stringWithFormat:@"input: %d, output: %d", [self.connection.inputStream streamStatus], [self.connection.outputStream streamStatus]];
  NSString *credentials = [NSString stringWithFormat:@"login:%@:%@",
                           self.usernameTextField.text,
                           self.passwordTextField.text];
  
 [self.connection login:credentials];
}

@end