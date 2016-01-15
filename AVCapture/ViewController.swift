//
//  ViewController.swift
//  AVCapture
//
//  Created by 谷建兴 on 16/1/14.
//  Copyright © 2016年 gujianxing. All rights reserved.
//


import UIKit
//1.AVFoundation框架,AVCaptureMetadataOutputObjectsDelegate       iOS7.0以上
import AVFoundation
class ViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var input:AVCaptureDeviceInput?
    var session:AVCaptureSession?
    var viewLayer:AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //2.实例化输入设备  所有设备在下面 详1:
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //3.初始化输入流
        do {
            self.input = try AVCaptureDeviceInput(device: device)
        }catch {
            
        }
        //4.创建会话
        self.session = AVCaptureSession()
        //5.添加输入流
        self.session!.addInput(self.input)
        //6.初始化输出流
        let output = AVCaptureMetadataOutput()
        //7.添加输出流
        self.session!.addOutput(output)
        //8.配置输出流参数 (1)设置输出代理和线程
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        //(2)设置元数据类型  ios7以上
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code]
        /**  Types:
        *QRCode                     二维码                   --- 一般使用的二维码
        *DataMatrixCode             Datamatrix二维码
        *AztecCode                  阿兹特克二维码
        *PDF417Code                 PDF417二维条码
        *Code128Code                Code128条形码
        *Code39Code                 Code39条形码
        *Code39Mod43Code            Code39Mod43条形码
        *Code93Code                 Code93条形码
        *EAN13Code                  EAN条形码标准版 EAN-13    --- 一般的商品条形码
        *EAN8Code                   EAN条形码缩短版 EAN-8
        *UPCECode                   UPC条形码中的UPC-E
        *ITF14Code                  ITF条码
        *Interleaved2of5Code        交插25码 条形码
        *Face                       人脸识别
        */
        
        
        //添加扫描框
        self.viewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.viewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.viewLayer!.frame = CGRectMake(50, 80, UIScreen.mainScreen().bounds.width - 100, UIScreen.mainScreen().bounds.width - 100)
        self.view.layer.addSublayer(self.viewLayer!)
        
        //开始扫描
        self.session!.startRunning()
        
    }
    
    //MARK:Delegate   一个扫描框内可以同时扫描多个二维码
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        //判断是否捕捉到条码    metadataObjects.count为扫描框捕捉到的条形码个数
        if metadataObjects != nil && metadataObjects.count > 0 {
//            print(metadataObjects.count)
            //我们一般只扫描一个二维码所以取第一个就够了
            if metadataObjects.first?.type == AVMetadataObjectTypeQRCode {
                print(metadataObjects.first?.stringValue)
                print("这是一个二维码")
            }else if metadataObjects.first?.type == AVMetadataObjectTypeEAN13Code {
                print(metadataObjects.first?.stringValue)
                print("这是一个条形码")
            }else{
                
            }
        }
        
    }
    
    
    //结束扫描
    func endScanning() {
        self.session!.stopRunning()
        self.session = nil
        self.viewLayer?.removeFromSuperlayer()
        self.viewLayer = nil
    }
    
    
    /** 详1:
     *AVMediaTypeVideo
     *AVMediaTypeAudio
     *AVMediaTypeText
     *AVMediaTypeClosedCaption
     *AVMediaTypeSubtitle
     *AVMediaTypeTimecode
     *AVMediaTypeTimedMetadata
     *AVMediaTypeMuxed
     */
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

