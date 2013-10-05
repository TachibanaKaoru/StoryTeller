//
//  ViewController.h
//  StoryTeller
//
//  Created by Tachibana Kaoru on 25/09/2013.
//  Copyright (c) 2013 Toyship.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textToRead;
@property (weak, nonatomic) IBOutlet UISwitch *onair;
@property (weak, nonatomic) IBOutlet UIButton *speakButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

- (IBAction)speak:(id)sender;
- (IBAction)pauseSpeaking:(id)sender;
- (IBAction)stopSpeaking:(id)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *voicePicker;
@property (weak, nonatomic) IBOutlet UISlider *rateSlider;
@property (weak, nonatomic) IBOutlet UISlider *pitchSlider;
@property (weak, nonatomic) IBOutlet UILabel *readingWord;

@end
