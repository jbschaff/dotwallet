//
//  ViewController.swift
//  FuyuWallet
//
//  Created by Franky Aguilar on 7/22/18.
//  Copyright © 2018 Ninth Industries. All rights reserved.
//

import UIKit
import Foundation


class WalletHomeViewController: UIViewController {
    
    @IBOutlet var ibo_walletHeader:WalletCardViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func iba_displayTokenViewController(){
        
        
        
//            vc.ibo_contentView =
//
//        let sendView = self.storyboard?.instantiateViewController(withIdentifier: "sb_SendViewController")
        
        
    }
    @IBAction func iba_displayWalletSettings(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        if let headerView = destination as? WalletCardViewController {
            self.ibo_walletHeader = headerView
        }
    }
    
}



