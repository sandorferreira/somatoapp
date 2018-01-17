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
    var tookPhoto = false
    var photoTaken: UIImage?
    
    // Aux Variables
    
    var captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var previewLayer: CALayer!

    // From Storyboard
    
    @IBOutlet weak var cameraLiveUIView: UIView!
    @IBOutlet weak var pictureTaken: UIImageView!
    @IBOutlet weak var manBorderUIImage: UIImageView!
    @IBOutlet weak var buttonTirarFoto: UIButton!
    @IBOutlet weak var deletePreviewPhoto: UIButton!
    
    
    @IBOutlet weak var cameraButtonsUIView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Começar camera
        
        // Escondendo Botão Salvar
        saveButton.isHidden = true
        pictureTaken.isHidden = true
        deletePreviewPhoto.isHidden = true
        
        // Corner Radius no Botão Salvar
        self.saveButton.layer.cornerRadius = 5.0
        
        // escondendo navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        prepareCamera()
    }
    
    func prepareCamera() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
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
            
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer.frame = self.view.bounds
            
            self.cameraLiveUIView.layer.addSublayer(previewLayer)
            
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        if tookPhoto {
            print("uhum take photo true")
            tookPhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                
                
                print("got it??")
                DispatchQueue.main.async {
                    self.pictureTaken.image = image
                    self.photoTaken = image
//                    let homemImagem = UIImage(named: "border_homem")
//                    let homemBorder = UIImageView(image: homemImagem)
//                    homemBorder.contentMode = .center
//                    homemBorder.contentScaleFactor = UIScreen.main.scale
//                    self.cameraLiveUIView.addSubview(self.manBorderUIImage)
                    self.buttonTirarFoto.isHidden = true
                    self.saveButton.isHidden = false
                    self.deletePreviewPhoto.isHidden = false
                    self.stopCaptureSession()
                }
            } else {
                print("nao conseguiu")
            }
        } else {
            print("ata")
        }
    }
    
    func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvImageBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                print("returning image")
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
            
        }
        return nil
    }
    
    func stopCaptureSession() {
        self.captureSession.stopRunning()
    }
    
    
    // Camera Button Actions
    
    @IBAction func takePhoto(_ sender: Any) {
        print("tirar foto!")
        tookPhoto = true
    }
    
    @IBAction func tirarOutraFoto(_ sender: UIButton) {
        pictureTaken.isHidden = true
        tookPhoto = false
        //prepareCamera()
        self.buttonTirarFoto.isHidden = false
        self.deletePreviewPhoto.isHidden = true
        self.saveButton.isHidden = true
        self.captureSession.startRunning()
    }
    
    
    
    @IBAction func activeFlash(_ sender: UIButton) {
    }
    
    
    @IBAction func selectMulher(_ sender: UIButton) {
    }
    
    @IBAction func selectHomem(_ sender: UIButton) {
    }
    
    @IBAction func savePhoto(_ sender: UIButton) {
        if let image = self.photoTaken {
            let topImage = self.manBorderUIImage.image! //UIImage(named: "borda_mannn")! //
            let newSize = self.manBorderUIImage.frame.size
            let mainSize = self.cameraLiveUIView.frame.size
            let botImage = image.crop(to: )
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            botImage.draw(in: CGRect(origin: .zero, size: mainSize))
            topImage.draw(in: CGRect(origin: .zero, size: newSize))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(newImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
            if let dataBemBonita = UIImageJPEGRepresentation(newImage!, 0.9) {

                let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let imageURL = docDir.appendingPathComponent("ataquerida.jpg")
                try! dataBemBonita.write(to: imageURL)
                print("saved!")
            } else {
                print("nao rolou fofa")
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Concluído", message: "Sua foto está salva na biblioteac.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}

extension UIImage {
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x : posX, y : posY, width : cropWidth, height : cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        cropped.draw(in: CGRect(x : 0, y : 0, width : to.width, height : to.height))
        
        return cropped
    }
}
