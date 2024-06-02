//
//  CameraController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 03.03.2024.
//

import UIKit
import SnapKit
import AVFoundation

class CameraController: UIViewController {
    
    let output = AVCapturePhotoOutput()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named:  "capture_photo")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupLayouts()
        setupSignals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupLayouts() {
        view.addSubview(capturePhotoButton)
        capturePhotoButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }
        
    }
    
    func setupSignals() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        backButton.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        capturePhotoButton.addTarget(self, action: #selector(handleCaptureButtonPressed), for: .touchUpInside)
    }
    
    @objc func handleBackButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleCaptureButtonPressed() {
        print("Capturing photo..")
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else {return}
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey: previewFormatType] as [String: Any]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Ошибка настройки камеры", error)
        }
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .background).async {
            captureSession.startRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Ошибка в процессе фото", error!)
            return
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "captureNewPhoto"), object: previewImage)
        self.navigationController?.popViewController(animated: true)
        
        self.tabBarController?.selectedIndex = 2
        self.tabBarController?.tabBar.isHidden = false
            
            
        }
    }

