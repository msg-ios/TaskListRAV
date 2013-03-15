//
//  TaskListRAVViewController.h
//  TaskListRAV
//
//  Created by Marco S. Graciano on 3/13/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface TaskListRAVViewController : UITableViewController <AVAudioPlayerDelegate>

@property NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSIndexPath *pathToPlayingCell;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

- (void)playAudio:(UIButton *)button;
- (void)playVideo:(UIButton *)button;
- (void)showTaskCreator:(id)sender;


@end
