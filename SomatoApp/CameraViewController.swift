//
//  CameraViewController.swift
//  SomatoApp
//
//  Created by Sandor ferreira da silva on 28/08/17.
//  Copyright © 2017 Sandor Ferreira da Silva. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Pessoa
    
    var pessoa: Pessoa?
    
    // Aux Variables
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var previewLayer: CALayer!

    // From Storyboard
    
    @IBOutlet weak var cameraLiveUIView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var indicatorHomem: UIImageView!
    @IBOutlet weak var indicatorMulher: UIImageView!
    
    @IBOutlet weak var cameraButtonsUIView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        // Começar camera
        
        // Escondendo Botão Salvar
        saveButton.isHidden = true
        containerView.isHidden = true
        
        self.navigationController!.isNavigationBarHidden = true
        
        prepareCamera()
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        //if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera]!, mediaType: AVMediaTypeVideo, position: //)
        
        if let availableDevices = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .back).devices {
            captureDevice = availableDevices.first
            beginSession()
        }
    }
    
    
    func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            self.previewLayer = previewLayer
            cameraLiveUIView.layer.addSublayer(previewLayer)
            self.previewLayer.frame = self.cameraLiveUIView.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)]
            
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.sandorferreira.CaptureQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
        }
    }
    
    // Camera Button Actions
    
    @IBAction func takePhoto(_ sender: UIButton) {
    }
    
    
    @IBAction func activeFlash(_ sender: UIButton) {
    }
    
    
    @IBAction func selectMulher(_ sender: UIButton) {
    }
    
    @IBAction func selectHomem(_ sender: UIButton) {
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
    }
    
    

}
