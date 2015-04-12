//
//  AppDelegate.m
//  MacInTalk
//
//  Created by Liam Westby on 10/4/14.
//  Copyright (c) 2014 ACM. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *textToSpeak;

@property (weak) IBOutlet NSButton *speakButton;
@property (weak) IBOutlet NSSlider *rateSlider;
@property (weak) IBOutlet NSSlider *volumeSlider;

@property (retain) NSSpeechSynthesizer *speechSynth;
@property (retain) NSMutableArray *voices;


@property BOOL speaking;
@property NSInteger currentVoice;
@property float rate;
@property float volume;
@end

@implementation AppDelegate
@synthesize voiceTable, voiceNames;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    self.speechSynth.delegate = self;
    self.currentVoice = [self.voices indexOfObjectIdenticalTo:[self.speechSynth voice]];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.currentVoice];
    [self.voiceTable selectRowIndexes:indexSet byExtendingSelection:NO];
    
    [self.voiceTable scrollRowToVisible:self.currentVoice];
    
    self.rate = self.speechSynth.rate;
    self.volume = self.speechSynth.volume;
    
    self.rateSlider.doubleValue = self.rate;
    self.volumeSlider.doubleValue = self.volume;

}

- (void)awakeFromNib {
    self.speaking = NO;
    
    self.voices = [[NSMutableArray alloc] initWithArray:[NSSpeechSynthesizer availableVoices]];
    self.voiceNames = [[NSMutableArray alloc] init];

    for (NSString *voice in _voices) {
        NSArray *components = [voice componentsSeparatedByString:@"."];
        if ([[components objectAtIndex:[components count] -1] isEqualToString:@"premium"]) {
            [self.voiceNames addObject:[[components objectAtIndex:[components count]-2] capitalizedString]];
        }
        else {
            [self.voiceNames addObject:[[components objectAtIndex:[components count]-1] capitalizedString]];
        }
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark - IBActions

- (IBAction)toggleSpeak:(id)sender {
    //NSLog(@"Toggle speaking: %hhd", self.speaking);
    if (_speaking) {
        // Will stop speaking
        [self.speechSynth stopSpeaking];
        self.speakButton.title = @"Start";
        self.speaking = NO;
    }
    else {
        // Will start speaking
        //NSLog(@"Checking length");
        if (self.textToSpeak.string.length == 0) return;
        //NSLog(@"Length not zero. Starting speech.");
        [self.speechSynth startSpeakingString:self.textToSpeak.string];
        //NSLog(@"Started speech. Changing button.");
        self.speakButton.title = @"Stop";
        //NSLog(@"Button changed. Speaking.");
        self.speaking = YES;
    }
}
- (IBAction)rateChanged:(id)sender {
    self.rate = self.rateSlider.doubleValue;
    self.speechSynth.rate = self.rate;
}

- (IBAction)volumeChanged:(id)sender {
    self.volume = self.volumeSlider.doubleValue;
    self.speechSynth.volume = self.volume;
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self voiceNames] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableColumn == [[[self voiceTable] tableColumns] objectAtIndex:0]) {
        return [[self voiceNames] objectAtIndex:row];
    }
    return nil;
}

#pragma mark - Table View Delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    self.currentVoice = self.voiceTable.selectedRow;
    self.speechSynth.voice = [self.voices objectAtIndex:self.currentVoice];
}

#pragma mark - Speech Synthesizer Delegate 
- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
    self.speaking = NO;
    self.speakButton.title = @"Speak";
}


@end
