//
//  TaskCreatorViewController.m
//  TaskListR
//
//  Created by Marco S. Graciano on 3/8/13.
//  Copyright (c) 2013 MSG. All rights reserved.
//

#import "TaskCreatorViewController.h"
#import "NSData+Compression.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TaskCreatorViewController ()

@end

@implementation TaskCreatorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoView.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    
    //AVAudioRecorder initialization
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
    _soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4],
                                    AVFormatIDKey,
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 1],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:16000.0],
                                    AVSampleRateKey,
                                    nil];
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:_soundFileURL
                      settings:recordSettings
                      error:&error];
    _audioRecorder.delegate = self;
    recordExists = NO;
    videoPicked = NO;
    _statusLabel.text = @"No record.";
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_audioRecorder prepareToRecord];
    }

}

- (void)viewDidUnload {
    [self setRecordButton:nil];
    [self setStatusLabel:nil];
    [self setTaskTextField:nil];
    [self setPhotoView:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.photoView.image = image;
        videoPicked = NO;
        //If a new photo is taken then it is saved into the Photos Album
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
    }
    
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        videoPicked = YES;
        //get the video file URL to use it in save method
        _videoFileURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //generate a thumbnail of the first video frame, and show it into the image view
        MPMoviePlayerController *mPlayer = [[MPMoviePlayerController alloc]initWithContentURL:_videoFileURL];
        mPlayer.shouldAutoplay = NO;
        self.photoView.image = [mPlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];

        if (newMedia){
            NSString *moviePath = [[info objectForKey:
                                    UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
            }
            
        }
    }
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Save failed" message: @"Failed to save file." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Button actions

- (IBAction)useCameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, kUTTypeMovie,nil];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

- (IBAction)useCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, kUTTypeMovie,nil];
        imagePicker.allowsEditing = NO;
        imagePicker.videoMaximumDuration = 5.0;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = YES;
    }
}


- (IBAction)recordAudio:(id)sender {
    if (!_audioRecorder.recording)
    {
        [_recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        //Records for 15 seconds max.
        _statusLabel.text =  @"Recording...";
        [_audioRecorder recordForDuration:(NSTimeInterval) 15.0];
    }
    else{
        [_audioRecorder stop];
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
        recordExists = YES;
    }
    
}


- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    NSString *text = [_taskTextField.text copy];
    _taskTextField.text = nil;
    [_taskTextField resignFirstResponder];
    
    UIImage *photo = self.photoView.image;
    NSData *taskPhoto = UIImageJPEGRepresentation(photo, 1.0);
    NSData *imageData = [taskPhoto zlibDeflate:taskPhoto];
    
    [self.managedObjectContext performBlock:^{
        NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
        [managedObject setValue:text forKey:@"text"];
        [managedObject setValue:imageData forKey:@"imageData"];
        
        if (recordExists) {
            NSData *audioData = [[NSData alloc] initWithContentsOfURL:_soundFileURL];
            audioData = [audioData zlibDeflate:audioData];
            [managedObject setValue:audioData forKey:@"audioData"];
            recordExists = NO;
        }
        
        if (videoPicked) {
            NSData *videoData = [[NSData alloc] initWithContentsOfURL:_videoFileURL];
            videoData = [videoData zlibDeflate:videoData];
            [managedObject setValue:videoData forKey:@"videoData"];
        }
        
        [self.managedObjectContext save:nil];
    }];
    
    [self dismissModalViewControllerAnimated:YES];

}

//Hides the keyboard if the view is touched.
- (IBAction)backgroundTouched:(id)sender {
    [_taskTextField resignFirstResponder];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - AVAudioRecorderDelegate
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
    _recordButton.titleLabel.text = @"Record";
    if (flag) {
        recordExists = YES;
        _statusLabel.text = @"Record saved.";
    }
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

@end
