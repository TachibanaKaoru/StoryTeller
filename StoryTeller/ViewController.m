//
//  ViewController.m
//  StoryTeller
//
//  Created by Tachibana Kaoru on 25/09/2013.
//  Copyright (c) 2013 Toyship.org. All rights reserved.
//

#import "ViewController.h"

typedef enum{
	STSpeakingStatusSpeak,
	STSpeakingStatusStop,
	STSpeakingStatusPause,
	STSpeakingStatusNone
}STSpeakingStatus;

@interface ViewController ()

@property (strong, nonatomic) AVSpeechSynthesisVoice *speechVoice;
@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@property (strong, nonatomic) NSArray* voices;

- (void)changeStatus:(STSpeakingStatus)status;
- (void)closeKeyboard:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// initialize AVSpeechSynthesizer
	self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
	self.speechSynthesizer.delegate = self;
	
	// get system voices
	self.voices = [AVSpeechSynthesisVoice speechVoices];
	//NSLog(@"system voices are %@",self.voices);
	
	// set values of sliders
	self.rateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate;
	self.rateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate;
	self.rateSlider.value = AVSpeechUtteranceDefaultSpeechRate;
	self.pitchSlider.minimumValue = 0.5;
	self.pitchSlider.maximumValue = 2.0;
	self.pitchSlider.value = 1.0;
		
	// select current system voice in picker
	AVSpeechSynthesisVoice* currentVoice = [AVSpeechSynthesisVoice voiceWithLanguage:[AVSpeechSynthesisVoice currentLanguageCode]];
	NSInteger currentIndex = [self.voices indexOfObject:currentVoice];
	[self.voicePicker selectRow:currentIndex inComponent:0 animated:NO];
	
	// make inputAccessoryView
	UIView* accessoryView =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
	accessoryView.backgroundColor = [UIColor clearColor];
	
	// set buttons to inputAccessoryView ("Done" button)
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
	closeButton.frame = CGRectMake(210,10,100,30);
	[closeButton setTitle:@"Done" forState:UIControlStateNormal];
	[closeButton setBackgroundColor:[UIColor lightGrayColor]];
	[closeButton addTarget:self action:@selector(closeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
	[accessoryView addSubview:closeButton];
	self.textToRead.inputAccessoryView = accessoryView;
	
	// set default text to read
	self.textToRead.text = @"Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, `and what is the use of a book,' thought Alice `without pictures or conversation?' So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Speak Control

- (IBAction)speak:(id)sender {
	
	NSString* targetText = self.textToRead.text;
	AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:targetText];

	utterance.voice = self.speechVoice;
	utterance.rate = self.rateSlider.value;
	utterance.pitchMultiplier = self.pitchSlider.value;
	
	[self.speechSynthesizer speakUtterance:utterance];

}
- (IBAction)pauseSpeaking:(id)sender {
	
	if( self.speechSynthesizer.paused){
		[self.speechSynthesizer continueSpeaking];
		
	}
	else{
		// you can change AVSpeechBoundaryWord and AVSpeechBoundaryImmediate
		[self.speechSynthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
	}

}

- (IBAction)stopSpeaking:(id)sender {
	
	// you can change AVSpeechBoundaryWord and AVSpeechBoundaryImmediate
	[self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

#pragma mark - UI functions

-(void)closeKeyboard:(id)sender{
	[self.textToRead resignFirstResponder];
}

- (void)changeStatus:(STSpeakingStatus)status{
	
	switch (status) {
		case STSpeakingStatusSpeak:
			
			self.speakButton.enabled = NO;
			self.stopButton.enabled = YES;
			self.pauseButton.enabled = YES;
			[self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
			self.rateSlider.enabled = NO;
			self.pitchSlider.enabled = NO;
			self.textToRead.editable = NO;
			self.voicePicker.userInteractionEnabled = NO;
			self.onair.on = YES;

			break;
		case STSpeakingStatusStop:
			self.speakButton.enabled = YES;
			self.stopButton.enabled = NO;
			self.pauseButton.enabled = NO;
			[self.pauseButton setTitle:@"Pause" forState:UIControlStateNormal];
			self.rateSlider.enabled = YES;
			self.pitchSlider.enabled = YES;
			self.textToRead.editable = YES;
			self.voicePicker.userInteractionEnabled = YES;
			self.onair.on = NO;
			break;
		case STSpeakingStatusPause:
			self.speakButton.enabled = NO;
			self.stopButton.enabled = NO;
			self.pauseButton.enabled = YES;
			[self.pauseButton setTitle:@"Resume" forState:UIControlStateNormal];
			self.rateSlider.enabled = NO;
			self.pitchSlider.enabled = NO;
			self.textToRead.editable = NO;
			self.voicePicker.userInteractionEnabled = NO;
			self.onair.on = NO;
			break;
		case STSpeakingStatusNone:
			;
			break;
			
		default:
			break;
	}

}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{

	[self changeStatus:STSpeakingStatusSpeak];

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
	
	[self changeStatus:STSpeakingStatusStop];

}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{

	[self changeStatus:STSpeakingStatusPause];
	
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{

	[self changeStatus:STSpeakingStatusSpeak];
	
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
	
	[self changeStatus:STSpeakingStatusStop];
	
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
	
	//NSLog(@"willSpeakRangeOfSpeechString with %lu %lu",(unsigned long)characterRange.location,characterRange.length);
	
	NSString* strTarget = [utterance.speechString substringWithRange:characterRange];
	
	//NSLog(@" target is %@",strTarget);
	self.readingWord.text = strTarget;
	
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	AVSpeechSynthesisVoice* voice = [self.voices objectAtIndex:row];
	self.speechVoice = voice;

}

#pragma mark - UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
	AVSpeechSynthesisVoice* voice = [self.voices objectAtIndex:row];
	return voice.language;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.voices count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

@end
