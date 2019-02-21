//
//  ViewController.swift
//  Audio Level
//
//  Created by JimmyHarrington on 2019/02/21.
//  Copyright © 2019 JimmyHarrington. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    // MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var recorder : AVAudioRecorder? = nil
    var audioTimer = Timer()
    var maxDb: Float = -120.0
    
    // MARK: - IBOutlet
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var testView: TestView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - IBAction
    @IBAction func startTapped(_ sender: UIButton) {
        sender.isEnabled = false
        stopButton.isEnabled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.startRecording()
        }
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        startButton.isEnabled = true
        sender.isEnabled = false
        maxDb = -120.0
        
        recorder?.stop()
        audioTimer.invalidate()
        testView.removeLayer()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        recorder?.stop()
        audioTimer.invalidate()
        testView.removeLayer()
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* navigation title */
        self.navigationItem.title = "Audio Level"
        navigationController!.navigationBar.barTintColor = .orange
        
        /* maxLabel */
        maxLabel.backgroundColor = UIColor.clear
        maxLabel.text = ""
        
        /* buttonView */
        buttonView.backgroundColor = UIColor.clear
        
        /* buttons */
        startButton.setTitleColor(UIColor.orange, for: .normal)
        startButton.setTitleColor(UIColor.lightGray, for: .disabled)
        startButton.setTitle("Start", for: .normal)
        startButton.layer.borderColor = UIColor.init(red: 6/255.0, green: 170/255.0, blue: 212/255.0, alpha: 1.0).cgColor
        startButton.layer.cornerRadius = 10.0
        startButton.layer.borderWidth = 1.0
        startButton.layer.backgroundColor = UIColor.white.cgColor
        
        stopButton.setTitleColor(UIColor.orange, for: .normal)
        stopButton.setTitleColor(UIColor.lightGray, for: .disabled)
        stopButton.isEnabled = false
        stopButton.setTitle("Stop", for: .normal)
        stopButton.layer.borderColor = UIColor.init(red: 6/255.0, green: 170/255.0, blue: 212/255.0, alpha: 1.0).cgColor
        stopButton.layer.cornerRadius = 10.0
        stopButton.layer.borderWidth = 1.0
        stopButton.layer.backgroundColor = UIColor.white.cgColor
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if checkMicrophonePermission() {
            print("Microphone permission...")
        }
    }
    
    // MARK: - Permission
    func checkMicrophonePermission() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            print("granted")
            startButton.isEnabled = true
            return true
        case .denied:
            print("denied")
            startButton.isEnabled = false
            return false
        case .undetermined:
            print("undetermined")
            var isGranted = false
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    print("granted")
                    isGranted = true
                } else {
                    print("not granted")
                    isGranted = false
                }
                DispatchQueue.main.async() {
                    [weak self] in
                    // Return data and update on the main thread, all UI calls should be on the main thread
                    // Create strong reference to the weakSelf inside the block so that it´s not released while the block is running
                    guard let strongSelf = self else { return }
                    strongSelf.startButton.isEnabled = granted
                }
            })
            return isGranted
        }
    }

    // MARK: - Recording audio
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Done recording!")
        recorder.stop()
        recorder.deleteRecording()
        recorder.prepareToRecord()
    }
    
    func startRecording() {
        do {
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            //try session.setCategory(.playback, mode: .default, policy: .default, options: .defaultToSpeaker)
            try session.setCategory(.playAndRecord, mode: .default)
            try session.overrideOutputAudioPort(.speaker)
            //try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            recorder = try AVAudioRecorder(url: makeAudioURL(), settings: settings)
            recorder!.delegate = self
            recorder!.isMeteringEnabled = true
            if recorder!.prepareToRecord() {
                recorder?.record()
                monitorAudio()
            } else {
                print("Error: AVAudioRecorder prepareToRecord failed")
            }
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    @objc func monitorAudio() {
        audioTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateMonitorDb), userInfo: nil, repeats: true)
    }
    
    @objc func updateMonitorDb() {
        recorder?.updateMeters()
        if let monitorDb = recorder?.averagePower(forChannel: 0) {
            print(monitorDb)
            if monitorDb > maxDb {
                maxDb = monitorDb
                maxLabel.text = NSString(format: "Max: %.2f", maxDb) as String
            }
            
            let newDb = monitorDb + 120.0
            testView.makeLayer(num: CGFloat(newDb))
        }
    }
    
    
    
    
    // MARK: - Functions
    func makeAudioURL() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls.first!
        return documentDirectory.appendingPathComponent("recording.m4a")
    }
}

