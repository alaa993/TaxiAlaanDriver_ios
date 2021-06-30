//
//  WalletController.swift
//  User
//
//  Created by AlaanCo on 4/14/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import UIKit

class WalletController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var titelLabel: UILabel!
    
    @IBOutlet weak var imagBack: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let listItem = ["Send Money","Accounts Charge","Transactions List","Withdraw Amount"]
    let imageItem = ["pincode","transaction","report_transaction","withdraw"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   initView()
    
        
    }
    
    func initView(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        LocaleManager.apply(identifier:UserDefaults.standard.string(forKey: "LanguageCode") )
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imagBack.isUserInteractionEnabled = true
        imagBack.addGestureRecognizer(tapGestureRecognizer)
        Bundle.setLanguage(lang: UserDefaults.standard.string(forKey: "LanguageCode") ?? "en")
        
        titelLabel.text = "Wallet".localized()
        
        
    }
    
    
 
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletCell", for: indexPath) as! WalletCell
      
        cell.labelName.text = listItem[indexPath.item].localized()
        cell.image.image = UIImage(named: imageItem[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionController") as! TransactionController
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        }else if indexPath.item == 1 {
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ChargeController") as! ChargeController
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        }else if indexPath.item == 2 {
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionLogController") as! TransactionLogController
            self.navigationController?.pushViewController(secondVC, animated: true)
            
            
        }else if indexPath.item == 3 {
            
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "WithdrawController") as! WithdrawController
            self.navigationController?.pushViewController(secondVC, animated: true)
            
        }
        
    }
    
    
}



    
