//
//  GameBrowserTableViewController.m
//  MySQLChessiOS
//
//  Created by Robert Sallai on 9/21/13.
//  Copyright (c) 2013 Robert Sallai. All rights reserved.
//
//


#import "GameBrowserTableViewController.h"
#import "SocketConnection.h"
#import "Match.h"

@interface GameBrowserTableViewController ()

@property (strong, nonatomic) SocketConnection *connection;
@property (strong, nonatomic) NSMutableArray *matches;

@end

@implementation GameBrowserTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//Stream Event Handler for Streamevent

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
				uint8_t buffer[1024];
				NSUInteger len;
        NSString *response;
				
				while ([self.connection.inputStream hasBytesAvailable])
        {
					len = [self.connection.inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
          {
						response = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
					}
				}
        [self.matches removeAllObjects];
        if (response)
        {
          //Separate the response string into "records"
          NSMutableArray *allMatches = [[NSMutableArray alloc] initWithArray:[response componentsSeparatedByString:@";"]];
          
          for (NSString *match in allMatches) {
            //Sperate each record into columns
            NSMutableArray *aMatch = [[NSMutableArray alloc] initWithArray:[match componentsSeparatedByString:@":"]];
            //TODO: factor it out into a Conveneince Initializer
            Match *aMatchObject = [[Match alloc] init];
            aMatchObject.matchID = [aMatch[0] integerValue];
            aMatchObject.whitePlayer = aMatch[1];
            aMatchObject.wins = [aMatch[2] integerValue];
            aMatchObject.losses = [aMatch[3] integerValue];
            aMatchObject.ties = [aMatch[4] integerValue];
            
            [self.matches addObject:aMatchObject];
          }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
      }
        
			break;
			
		case NSStreamEventErrorOccurred:
      
			[self performSegueWithIdentifier:@"GameBrowserConnectionLost" sender:self];

			break;
			
		case NSStreamEventEndEncountered:
      
      [self.connection closeStreams];
      [self performSegueWithIdentifier:@"GameBrowserConnectionLost" sender:self];
			break;
	}
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.matches = [[NSMutableArray alloc] init];
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
 
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
  self.connection = [SocketConnection getSingletonInstance];
  [self.connection.inputStream setDelegate:self];
  [self.connection.outputStream setDelegate:self];
  self.matches = [[NSMutableArray alloc] init];
  [self.connection listMatches];
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self.connection unlistFromLiveUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Accounting for the rowcout
  return [self.matches count] + 1;
}

- (NSString *)titleForRow:(NSUInteger)row
{
  Match *match = self.matches[row-1];
  return match.whitePlayer;
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
  Match *match = self.matches[row-1];
  return [NSString stringWithFormat:@"Wins: %d, Losses: %d, Ties: %d", match.wins, match.losses, match.ties];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //First row is reserved for creating a new match
  if (indexPath.row == 0) {
    static NSString *CellIdentifier = @"CreateMatch";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"Create a new match";
    return cell;
  }
  else
  {
    static NSString *CellIdentifier = @"GameLobby";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    return cell;
  }
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  
}

@end