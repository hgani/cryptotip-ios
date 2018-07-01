import GaniLib
import QRCodeReader
import AVFoundation
import web3swift

class SendScreen: GScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Send"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 20, l: 20, b: 20, r: 20)
            .done()
        
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
    
    
    func process(value: String) {
        if let address = EthereumAddress(value), address.isValid {
            self.nav.push(SendFormScreen(to: value))
        }
        else if let payload = Erc681(url: URL(string: value)) {
            self.nav.push(SendFormScreen(payload: payload))
        }
        else {
            self.launch.alert("Invalid ETH address")
        }
    }
}



extension SendScreen: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        process(value: result.value)
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

