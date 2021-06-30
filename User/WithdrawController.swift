//
//  WithdrawController.swift
//  User
//
//  Created by AlaanCo on 4/22/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMobileAds
class WithdrawController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        initView()
        adsGoogle()
        
    }
    
    func initView(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageBack.isUserInteractionEnabled = true
        imageBack.addGestureRecognizer(tapGestureRecognizer)
        titelLabel.text = "Withdraw Amount".localized()
        btnSend.setTitle("Send".localized(), for: UIControl.State.normal)
        textFieldAmount.placeholder = "Please enter amount".localized()
        btnSend.layer.cornerRadius = 5
        btnSend.clipsToBounds = false
        
    }
    
    
    
    func adsGoogle(){
        
        bannerView.adUnitID = "ca-app-pub-6606021354718512/5872732188"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.backgroundColor = UIColor.white
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnWitDraw(_ sender: Any) {
        
        let loading =  LoadingViewClass()
        loading.startLoading()
        
        let param:Parameters = ["amount":textFieldAmount.text ?? ""]
        
        ServiceAPI.shared.fetchGenericData(urlString: MD_WITHDRAW, parameters: param, methodInput: .post,isHeaders: true) { (model:ModelCharge?,error:Error?, status:Int?) in
            loading.stopLoading()
            
            if status == 200{
                
                CSS_Class.alertviewController_title("" , messageAlert: "Request Has Been Sent Successfully".localized(), viewController: self, okPop: false)
            }else if status == 402 {
                
                CSS_Class.alertviewController_title("Balance Is Low!".localized() , messageAlert: model?.message, viewController: self, okPop: false)
                
            }else if status == 500 {
                
                CSS_Class.alertviewController_title("ERRORMSG".localized() , messageAlert: model?.message, viewController: self, okPop: false)
                
            }
            
        }
        
        
    }
    
}
