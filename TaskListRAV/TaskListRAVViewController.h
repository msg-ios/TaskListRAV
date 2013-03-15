//
//  TaskListRAVViewController.h
//  TaskListRAV
//
//  Created by Marco S. Graciano on 3/13/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TaskListRAVViewController : UITableViewController <AVAudioPlayerDelegate>

@property NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSIndexPath *pathToPlayingCell;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (void)playAudio:(UIButton *)button;
- (void)showTaskCreator:(id)sender;


@end
