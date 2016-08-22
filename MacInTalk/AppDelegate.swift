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
@objc(AppDelegate)
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var window: NSWindow!
    @IBOutlet var textToSpeak: NSTextView!
    
    @IBOutlet var speakButton: NSButton!
    @IBOutlet var rateSlider: NSSlider!
    @IBOutlet var volumeSlider: NSSlider!
    
    @IBOutlet weak var voiceTable: NSTableView!
    
    var speechSynth: NSSpeechSynthesizer = NSSpeechSynthesizer.init()
    var voices: [String] = []
    
    var speaking: Bool = false
    var currentVoice: Int = 0
    var rate: Double = 0.0
    var volume: Double = 0.0
    
    var voiceNames: NSMutableArray = []
    
    let speakButtonStart: String = "Speak"
    let speakButtonStop: String = "Stop"
    
    func applicationDidFinishLaunching(_: Notification) {
        speechSynth.delegate = self
        currentVoice = voices.index(of: speechSynth.voice()!)!
        
        let indexSet: NSIndexSet = NSIndexSet.init(index: currentVoice)
        voiceTable.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        voiceTable.scrollRowToVisible(currentVoice)
        
        rate = Double(speechSynth.rate)
        volume = Double(speechSynth.volume)
        
        rateSlider.doubleValue = rate
        volumeSlider.doubleValue = volume
    }
    
    override func awakeFromNib() {
        speaking = false
        
        voices = NSSpeechSynthesizer.availableVoices()
        
        for voice: String in voices {
            let attributes = NSSpeechSynthesizer.attributes(forVoice: voice as String);
            voiceNames.add(attributes[NSVoiceName]! as! String)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true;
    }
    
    // MARK: - IBActions
    @IBAction func toggleSpeak(_: AnyObject) {
        if (speaking) {
            speechSynth.stopSpeaking()
            speakButton.title = speakButtonStart
            speaking = false
        } else {
            if (textToSpeak.string!.characters.count == 0) {
                return
            }
            speechSynth.startSpeaking(textToSpeak.string!)
            speakButton.title = speakButtonStop
            speaking = true
        }
    }
    
    @IBAction func rateChanged(_: AnyObject) {
        rate = rateSlider.doubleValue
        speechSynth.rate = Float(rate)
    }
    
    @IBAction func volumeChanged(_: AnyObject) {
        volume = volumeSlider.doubleValue
        speechSynth.volume = Float(volume)
    }
    
    // MARK: - TableView Data Source
    
    func numberOfRows(in: NSTableView) -> Int {
        return voiceNames.count
    }
    
    func tableView(_: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if (tableColumn == voiceTable.tableColumns[0]) {
            return voiceNames[row]
        }
        return nil
    }
    
    // MARK: - TableView Delegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        currentVoice = voiceTable.selectedRow
        speechSynth.setVoice(voices[currentVoice])
    }
    
    // MARK: - Speech Synthesizer Delegate
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        speaking = false
        speakButton.title = speakButtonStart
    }
}
