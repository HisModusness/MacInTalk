//
//  AppDelegate.swift
//  MacInTalk
//
//  Created by Liam Westby on 11/4/15.
//  Copyright © 2015 ACM. All rights reserved.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textToSpeak: NSTextView!
    
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var rateSlider: NSSlider!
    @IBOutlet weak var volumeSlider: NSSlider!
    
    @IBOutlet weak var voiceTable: NSTableView!
    
    var speechSynth: NSSpeechSynthesizer = NSSpeechSynthesizer.init()
    var voices: NSMutableArray = []
    
    var speaking: Bool = false
    var currentVoice: Int = 0
    var rate: Double = 0.0
    var volume: Double = 0.0
    
    var voiceNames: NSMutableArray = []
    
    let speakButtonStart: String = "Speak"
    let speakButtonStop: String = "Stop"
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        speechSynth.delegate = self
        currentVoice = voices.indexOfObjectIdenticalTo(speechSynth.voice()!)
        
        let indexSet: NSIndexSet = NSIndexSet.init(index: currentVoice)
        voiceTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        voiceTable.scrollRowToVisible(currentVoice)
        
        rate = Double(speechSynth.rate)
        volume = Double(speechSynth.volume)
        
        rateSlider.doubleValue = rate
        volumeSlider.doubleValue = volume
    }
    
    override func awakeFromNib() {
        speaking = false
        
        voices = NSMutableArray.init(array: NSSpeechSynthesizer.availableVoices())
        
        for voice: NSString in voices as NSArray as! [String] {
            var components: [String] = voice.componentsSeparatedByString(".")
            if (components[components.count - 1] == "premium") {
                voiceNames.addObject(components[components.count - 2].capitalizedString)
            } else {
                voiceNames.addObject(components[components.count - 1].capitalizedString)
            }
        }
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }
    
    // MARK: - IBActions
    @IBAction func toggleSpeak(sender: AnyObject) {
        if (speaking) {
            speechSynth.stopSpeaking()
            speakButton.title = speakButtonStart
            speaking = false
        } else {
            if (textToSpeak.string!.characters.count == 0) {
                return
            }
            speechSynth.startSpeakingString(textToSpeak.string!)
            speakButton.title = speakButtonStop
            speaking = true
        }
    }
    
    @IBAction func rateChanged(sender: AnyObject) {
        rate = rateSlider.doubleValue
        speechSynth.rate = Float(rate)
    }
    
    @IBAction func volumeChanged(sender: AnyObject) {
        volume = volumeSlider.doubleValue
        speechSynth.volume = Float(volume)
    }
    
    // MARK: - TableView Data Source
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voiceNames.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if (tableColumn == voiceTable.tableColumns[0]) {
            return voiceNames[row]
        }
        return nil
    }
    
    // MARK: - TableView Delegate
    func tableViewSelectionDidChange(notification: NSNotification) {
        currentVoice = voiceTable.selectedRow
        speechSynth.setVoice(voices[currentVoice] as? String)
    }
    
    // MARK: - Speech Synthesizer Delegate
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        speaking = false
        speakButton.title = speakButtonStart
    }
}
