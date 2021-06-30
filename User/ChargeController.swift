//
//  ChargeController.swift
//  User
//
//  Created by AlaanCo on 4/15/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ChargeController: UIViewController {
    
    @IBOutlet weak var TextFieldCode: UITextField!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var titelLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var btnSend: UIButton!
    let  b = LocalizeHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        initView()
        adsGoogle()
        
    }
    
    func initView(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgBack.isUserInteractionEnabled = true
        imgBack.addGestureRecognizer(tapGestureRecognizer)
        titelLabel.text = "Accounts Charge".localized()
        
        btnSend.setTitle("Send".localized(), for: UIControl.State.normal)
        btnSend.layer.cornerRadius = 5
        btnSend.clipsToBounds = false
        TextFieldCode.placeholder = "Please enter your code".localized()
        
    }
    
    func adsGoogle(){
        
        bannerView.adUnitID = "ca-app-pub-6606021354718512/5134365580"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.backgroundColor = UIColor.white
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCharge(_ sender: Any) {
        
        if TextFieldCode.text?.count ?? 0 < 1  {
            
            let alert = UIAlertController(title: "", message: "VALIDATE".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
            
        }
        
        let loading =  LoadingViewClass()
        loading.startLoading()
        
        let param:[String:Any] = ["charge_code":TextFieldCode.text ?? ""]
        ServiceAPI.shared.fetchGenericData(urlString: MD_APPLAY, parameters: param, methodInput: .post,isHeaders: true){ (model:ModelCharge?,error:Error?,status:Int?)  in
            
            loading.stopLoading()
            
            if status == 200 {
                
                CSS_Class.alertviewController_title("" , messageAlert:"Charge Code Applied Successfully".localized(), viewController: self, okPop: false)
                
                
            }else if status == 404 {
                
                CSS_Class.alertviewController_title("" , messageAlert:"Invalid Charge Code".localized(), viewController: self, okPop: false)
                
            }else if status == 500 {
                
                CSS_Class.alertviewController_title("" , messageAlert:"ERRORMSG".localized(), viewController: self, okPop: false)
                
            }
            
        }
        
    }
    
}

