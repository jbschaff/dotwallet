//
//  ImportWalletViewController.swift
//  Dot Wallet
//
//  Created by Franky Aguilar on 9/12/18.
//  Copyright © 2018 Ninth Industries. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader
import KeychainAccess

class ImportWalletViewController: UIViewController, QRCodeReaderViewControllerDelegate, PasswordLoginDelegate {
    @IBOutlet weak var ibo_pkeyField:UITextField?
    var loginVC:PasswordLoginViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func iba_pastePKey(){
        if let myString = UIPasteboard.general.string {
            self.ibo_pkeyField?.text = myString
        }
    }
    
    @IBAction func iba_qrReader(){
       self.iba_scanAction()
    }
    
    //WALLET CORE
    @IBAction func importWallet() {
        if (self.ibo_pkeyField?.text?.isEmpty == true){
            self.view.makeToast("No Private Key")
            return
        }
        self.showLoginView(state: .Create)
    }
    
    func showLoginView(state:PassState) {
        
        self.loginVC = (storyboard?.instantiateViewController(withIdentifier: "PasswordLoginViewController") as! PasswordLoginViewController)
        self.loginVC!.modalPresentationStyle = .overFullScreen
        self.loginVC!.delegate = self
        self.loginVC!.passState = state
        self.loginVC!.modalTitle = "Create Password"
        present(loginVC!, animated: false, completion: nil)
    }
    
    func createWalletWithPasscode(pass: String?) {
        self.importWalletWith(pass: pass!)
    }
    
    func importWalletWith(pass:String) {
        let pKey = self.ibo_pkeyField?.text
    
        do {
            try EtherWallet.account.importAccount(privateKey: pKey!, password: pass)
            UserPreferenceManager.shared.setKey(key: "walletColor", object: "C0B9FF")
            
            let publicAddress = EtherWallet.account.address?.lowercased()
            let keychain = Keychain(service: publicAddress!)
            
            do {
                try keychain.set(pass, key: publicAddress!)
                self.pushWalletHomeScreen()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    
    func pushWalletHomeScreen(){
        
        EtherWallet.balance.etherBalance { balance in
            UserDefaults.standard.set(balance, forKey: "ETHBalance")
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "sb_WalletHomeViewController")
        self.navigationController?.setViewControllers([vc!], animated: false)
    }
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        builder.showSwitchCameraButton = false
        return QRCodeReaderViewController(builder: builder)
    }()
    
    func iba_scanAction() {
        
        readerVC.delegate = self
        readerVC.view.frame = self.view.frame
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result?.value == nil {
                return
            }
            let urlQuery = URL(string: (result?.value)!)
            print(result?.value)
            if let ethereumURL = urlQuery?.absoluteStringByTrimmingQuery(){
//                self.ibo_addressField?.text = ethereumURL.replacingOccurrences(of: "ethereum:", with: "")
            }
        }
        
        readerVC.modalPresentationStyle = .overFullScreen
        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
