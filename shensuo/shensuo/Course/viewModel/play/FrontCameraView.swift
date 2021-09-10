//
//  FrontCameraView.swift
//  shensuo
//
//  Created by 陈鸿庆 on 2021/6/21.
//
///前置摄像头视图
import UIKit

class FrontCameraView: UIView {
    // 前置摄像头
    
    var frontFacingCamera: AVCaptureDevice?
    // 静止图像输出端
    var stillImageOutput: AVCapturePhotoOutput?
    // 相机预览图层
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    // 音视频采集会话
    
    let captureSession = AVCaptureSession()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == AVCaptureDevice.Position.front {
                self.frontFacingCamera = device
            }
        }
        do {
            // 当前设备输入端
            let captureDeviceInput = try AVCaptureDeviceInput(device: frontFacingCamera!)
            
            self.stillImageOutput = AVCapturePhotoOutput()
            
            
            self.captureSession.addInput(captureDeviceInput)
            
            self.captureSession.addOutput(self.stillImageOutput!)
            self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.layer.addSublayer(cameraPreviewLayer!)

            self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.frame = self.bounds
            // 启动音视频采集的会话

            self.captureSession.startRunning()
        }catch {
            
            print(error)
            
            return
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
