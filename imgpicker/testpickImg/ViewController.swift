//
//  ViewController.swift
//  testpickImg
//
//  Created by admin on 12/1/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var examImg: UIImage!
    
    @IBOutlet weak var nameImg: UILabel!
    
    var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var path: String!
    var pathAudio: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        print(docDirectory)
        path = docDirectory.appending("/Image1.png")
        pathAudio = docDirectory.appending("/recording.mp3")
        
//        examImg = UIImage(named: "linux.png")
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        // audio record
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            self.loadRecordingUI()
        } catch {
            print(error)
        }

    }
    
    func loadRecordingUI() {
        recordButton = UIButton(frame: CGRect(x: 200, y: 468, width: 130, height: 62))
        recordButton.backgroundColor = UIColor.brown
        
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        view.addSubview(recordButton)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }

    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @IBAction func loadImgBtn(_ sender: UIButton) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveAudio(_ sender: UIButton) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveImg(_ sender: UIButton) {
//        saveImg(img: examImg, path: path)
        
        let imgFilename = getDocumentsDirectory().appendingPathComponent("exam.png")
        saveImg(img: imageView.image!, url: imgFilename)
//        saveImg(img: imageView.image!, path: path)
    }

    func saveImg(img: UIImage,url: URL) {
//        let url = URL(fileURLWithPath: path)
        let pngImg = UIImagePNGRepresentation(img)
        do {
            try pngImg?.write(to: url)
            print("Image Added Successfully")
        } catch {
            print(error)
        }
    }
}

