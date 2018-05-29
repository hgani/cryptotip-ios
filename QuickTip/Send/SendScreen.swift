import GaniLib
import QRCodeReader
import AVFoundation

class SendScreen: GScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Send"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 20, l: 20, b: 20, r: 20)
            .end()
        
        container.addView(GLabel()
            .width(.matchParent)
            .align(.center)
            .spec(.h1)
            .text("Scan to send coin"), top: 50)
        
        container.addView(GLabel()
            .width(.matchParent)
            .align(.center)
            .spec(.p)
            .text("Click the QR icon below"), top: 40)
        
        container.addView(GLabel()
            .width(.matchParent)
            .align(.center)
            .icon("fa:qrcode", size: 120)
            .onClick({ _ in
                self.openQrScanner()
            }), top: 10)
    }
    
    func openQrScanner() {
        let reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
            $0.reader                   = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr])
            $0.showSwitchCameraButton   = false
            $0.showTorchButton          = true
        })
        reader.modalPresentationStyle = .formSheet
        reader.delegate = self
        present(reader, animated: true, completion: nil)
    }
    
    
    func submit(code: String) {
//        _ = Rest.post(path: "/", params: params).execute { result in
//            if result["success"].boolValue {
//                self.dismiss(animated: true, completion: nil)
//                self.indicator.show(success: result["message"].stringValue)
//                return true
//            }
//            return false
//        }
        self.nav.push(SendFormScreen(to: code))
    }
}



extension SendScreen: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        submit(code: result.value)
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        //        if let cameraName = newCaptureDevice.device.localizedName {
        //            print("Switching capturing to: \(cameraName)")
        //        }
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

