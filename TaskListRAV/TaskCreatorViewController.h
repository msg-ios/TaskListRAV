//
//  TaskCreatorViewController.h
//  TaskListR
//
//  Created by Marco S. Graciano on 3/8/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface TaskCreatorViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate> {
    BOOL newMedia;
    BOOL recordExists;
    BOOL videoPicked;
}

@property NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSURL *soundFileURL;
@property (strong, nonatomic) NSURL *videoFileURL;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UITextField *taskTextField;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

- (IBAction)useCameraRoll:(id)sender;
- (IBAction)useCamera:(id)sender;
- (IBAction)recordAudio:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
