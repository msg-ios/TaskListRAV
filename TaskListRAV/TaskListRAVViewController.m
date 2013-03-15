//
//  TaskListRAVViewController.m
//  TaskListRAV
//
//  Created by Marco S. Graciano on 3/13/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import "TaskListRAVViewController.h"
#import "TaskCell.h"
#import "Task.h"
#import "TaskCreatorViewController.h"
#import "NSData+Compression.h"

@interface TaskListRAVViewController () <NSFetchedResultsControllerDelegate>
@property NSFetchedResultsController *fetchedResultsController;
@end

@implementation TaskListRAVViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Task List", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showTaskCreator:)];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"completedAt" ascending:NO]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:nil];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultsController sections]count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections]objectAtIndex:section]numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TaskCell";
    
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    TaskCell *taskCell = (TaskCell *)cell;
    taskCell.taskNameLabel.text = task.text;
    taskCell.taskNameLabel.textColor = [task isCompleted] ? [UIColor lightGrayColor] : [UIColor blackColor];
    
    if (task.imageData != nil) {
        NSData *imageData = [task.imageData zlibInflate:task.imageData];
        taskCell.taskPhoto.image = [[UIImage alloc]initWithData:imageData];
    }
    else {
        taskCell.taskPhoto.image = nil;
    }
    
    if (task.audioData == nil) {
        taskCell.playButton.hidden = YES;
    }
    else {
        taskCell.playButton.hidden = NO;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]    withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forRowAtIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]    withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]     withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.managedObjectContext performBlock:^{
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        task.completed = !task.completed;
        [self.managedObjectContext save:nil];
    }];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Button actions

- (void)playAudio:(UIButton *)button{
    if (!_audioPlayer.playing)
    {
        TaskCell *owningCell = (TaskCell *)button.superview.superview;
        
        NSIndexPath *pathToCell = [self.tableView indexPathForCell:owningCell];
        _pathToPlayingCell = pathToCell;
        
        NSLog(@"path to cell: %d", pathToCell.row);
        
        Task *task = [self.fetchedResultsController objectAtIndexPath:pathToCell];
        
        NSLog(@"audioData (compressed): %d", [task.audioData length]);
        NSData *audioData = [task.audioData zlibInflate:task.audioData];
        NSLog(@"audioData (uncompressed): %d", [audioData length]);
        
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc]
                        initWithData:audioData
                        error:&error];
        _audioPlayer.delegate = self;
        [_audioPlayer play];
        [button setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else{
        [_audioPlayer stop];
        [button setTitle:@"Play" forState:UIControlStateNormal];
    }
}

-(void)showTaskCreator:(id)sender {
    TaskCreatorViewController *taskCreator = [[TaskCreatorViewController alloc] initWithNibName:@"TaskCreatorViewController" bundle:nil];
    taskCreator.managedObjectContext = self.managedObjectContext;
    [self presentModalViewController:taskCreator animated:YES];
}


#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    TaskCell *cell = (TaskCell *)[self.tableView cellForRowAtIndexPath:_pathToPlayingCell];
    [cell.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}




@end
