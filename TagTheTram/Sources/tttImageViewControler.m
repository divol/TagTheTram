//
//  tttImageViewControlerViewController.m
//  TagTheTram
//
//  Created by divol on 13/04/13.
//  Copyright (c) 2013 divol. All rights reserved.
//

#import "tttImageViewControler.h"
#import "tttPhotoStationCell.h"
#import "tttDatabase.h"


@interface tttImageViewControler ()
- (void)askPhotoLabel;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker;
- (void) imagePickerController: (UIImagePickerController *) picker;
@end

@implementation tttImageViewControler
@synthesize station;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.station){
        self.title =[[tttDatabase currentDatabase] getAttrStation:self.station withAttr:nameStation];
        
      //  [self.tableView setEditing:YES];
    }
    

}

- (void)dealloc
{
    
    self.station=nil;
    if (cameraUI){
        [cameraUI release];
    }
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (self.station){
        NSString *idstation = [[tttDatabase currentDatabase] getIdStation:self.station];
        
        
        
    
        NSArray *arrayofphoto = [[tttDatabase currentDatabase]getPhotosOfStation:idstation];
        
        if (arrayofphoto){
            return [arrayofphoto count];
        }
        
    }
    
    return 0;
}

//-(NSArray *)getPhotosOfStation:(NSString *) idstation{
//    return [self.photos objectForKey:idstation];
//}
//
//-(NSDictionary *)getPhotoOfStation:(NSInteger)pos ofStation:(NSString *) idstation{
//    return [[self.photos objectForKey:idstation]objectAtIndex:pos];
//}
//
//
//
//-(NSString *)getAttrPhoto:(NSDictionary *)station withAttr:(NSString *) attr{
//    return [station objectForKey:attr];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    tttPhotoStationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     NSString *idstation = [[tttDatabase currentDatabase] getIdStation:self.station];

    NSDictionary * photo = [[tttDatabase currentDatabase]getPhotoOfStation:indexPath.row ofStation:idstation];
    
    
    //title
   
    cell.titleStation.text= [[tttDatabase currentDatabase] getAttrPhoto:photo withAttr:labelPhoto];
    
    
    //date
    NSDateFormatter *dateStr = [[NSDateFormatter alloc] init];
    [dateStr setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSString * ss = [[tttDatabase currentDatabase] getAttrPhoto:photo withAttr:datePhoto];
    
    NSDate *date = [dateStr dateFromString:ss];
    [dateStr release];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY '@' HH:mm"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    cell.datetimeStation.text=formattedDateString  ;
    [dateFormatter release];
    
    //image
    cell.imageStation.image = [[UIImage alloc]initWithContentsOfFile:[[tttDatabase currentDatabase] getAttrPhoto:photo withAttr:pathPhoto]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate




//  Update array of displayed objects by inserting/removing objects as necessary.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *idstation = [[tttDatabase currentDatabase] getIdStation:self.station];
        
       // NSDictionary * photo = [[tttDatabase currentDatabase]getPhotoOfStation:indexPath.row ofStation:idstation];
        
        [[tttDatabase currentDatabase]removePhotoFromStation:indexPath.row fromstation:idstation];
        
        [tableView reloadData];
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Assume self.view is the table view
    NSIndexPath *path = [self.tableView  indexPathForSelectedRow];
    
    NSString *idstation = [[tttDatabase currentDatabase] getIdStation:self.station];
    
    NSDictionary * photo = [[tttDatabase currentDatabase]getPhotoOfStation:path.row ofStation:idstation];
    
    
    if([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]){
        [segue.destinationViewController setPhoto:photo];
    }
}


#pragma mark - photo shooter

- (void)askPhotoLabel {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Photo Title",nil)
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
    
}

//UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    
    if (curphoto){
        [curphoto setObject:inputText forKey:labelPhoto];
       NSString *idstation = [[tttDatabase currentDatabase] getIdStation:self.station];
        
        [[tttDatabase currentDatabase]addPhotoEntryToStation:curphoto tostation:idstation];
        [curphoto release];
        
        [[tttDatabase currentDatabase]savePhotoDB];
    }
    [alertView release];
    
    
    [self.tableView reloadData];
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissModalViewControllerAnimated:YES];
    
       
    
}


// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    // NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    // if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    
    
    
    if(self.station)
    {
        // UIImageWriteToSavedPhotosAlbum(imageToSave,nil,nil,nil); // uncomment if needed
        
        //image to data
        NSData *data = UIImagePNGRepresentation(imageToSave);
        
        //build url
        NSString *stationname= [[tttDatabase currentDatabase] getAttrStation:station withAttr:nameStation];
        NSURL * url =[[tttDatabase currentDatabase] createImagePath:stationname];
        NSError *err;
       // BOOL b=[data writeToURL:url atomically:YES];
        
         
        NSString*datestr =  [[NSDate date] description];
        //temp desc for photo
        curphoto =  [[[tttDatabase currentDatabase]makePhotoEntry:@"" withDate:datestr withPath:[url path]]retain];
        
        //save photo
       BOOL b=[data writeToURL:url options:NSDataWritingFileProtectionNone error:&err];
        
        if(b){
           
            
            
            
            [self askPhotoLabel ];
        }else{
            
        }
        
    }
    
    
    /////////
    
    
    
    //////////
    //  }
   
    
    [picker dismissModalViewControllerAnimated:YES];
}



- (IBAction)photoAction:(id)sender{
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        if (!cameraUI)
            cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType=UIImagePickerControllerSourceTypeCamera;
        cameraUI.allowsEditing = YES;
        
        cameraUI.delegate = self;
        
        if ([self respondsToSelector:@selector(presentViewController:)]) {
            [self presentViewController: cameraUI   animated: YES completion:^{
                
                //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
                
                
            }] ;
        }else{
            [self presentModalViewController: cameraUI   animated: YES];
        }

    }
    
}
@end
