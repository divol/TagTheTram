//
//  tttFirstViewController.m
//  TagTheTram
//
//  Created by divol on 12/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "tttListeViewController.h"
 #import "tttDatabase.h"

@interface tttListeViewController ()

@end

@implementation tttListeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCoreData) name:@"STATIONS_LOADED" object:nil];
   // [self reloadCoreData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [lines release];
   
    [super dealloc];
}


- (void)reloadCoreData {

    
    lines = [[[tttDatabase currentDatabase] getNameOfLines]retain];
    
    //sometimes things go wrong, so force reload data on mainThread
    [StationtableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    
    
    }



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (lines){
        return  [lines count];
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString * line = [lines objectAtIndex:section ];
    
    return   [[[tttDatabase currentDatabase] getStations:line]count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *line = [lines objectAtIndex:section ];
    return[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Line: ",nil),line];
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)pTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	[StationtableView deselectRowAtIndexPath:indexPath animated:YES];
    
	// Configure the cell...
	UITableViewCell	*cell = (UITableViewCell *)[pTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    
     NSString * line = [lines objectAtIndex:indexPath.section ];
    
    
     NSDictionary* station =  [[tttDatabase currentDatabase] getStationOfLine:indexPath.row  ofLine: line];

	// Configure the cell...
    NSString * label =[[tttDatabase currentDatabase] getAttrStation:station withAttr:nameStation];
    if (!label){
        label = @"??????"; //json received can be corupted
    }
	cell.textLabel.text=label;
		
    return cell;
}







#pragma mark -
#pragma mark Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Assume self.view is the table view
    NSIndexPath *path = [StationtableView indexPathForSelectedRow];
    
    NSString * line = [lines objectAtIndex:path.section ];
    
    
    NSDictionary* station =  [[tttDatabase currentDatabase] getStationOfLine:path.row  ofLine: line];
    
    if([segue.destinationViewController respondsToSelector:@selector(setStation:)]){
        [segue.destinationViewController setStation:station];
    }
}





@end
