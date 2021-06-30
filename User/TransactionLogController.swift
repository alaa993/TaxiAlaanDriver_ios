//
//  TransactionLogController.swift
//  User
//
//  Created by AlaanCo on 4/19/19.
//  Copyright © 2019 iCOMPUTERS. All rights reserved.
//

import UIKit
import SDWebImage

class TransactionLogController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var titelLabel: UILabel!
    @IBOutlet weak var imageBack: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = [ModelTransactionLog]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageBack.isUserInteractionEnabled = true
        imageBack.addGestureRecognizer(tapGestureRecognizer)
        
         titelLabel.text = "Transactions List".localized()
        
        
        getData()
   
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionLogCell", for: indexPath) as! TransactionLogCell
        let mo = model[indexPath.item]
        
        cell.dateAndTimeLabel.text = mo.created_at
        cell.typeLabel.text = mo.type
        cell.statusLabel.text = mo.status
        cell.mountLabel.text = "\(mo.amount ?? 0)"
        cell.commissionLabel.text = "Comission : \(mo.commission ?? 0)"
        cell.reminBalanceLabel.text = "RemainBalance :\(mo.remain_balance ?? 0)"
        cell.labelCash.text = "Cash : \(mo.cash ?? 0)"
        cell.labelDiscount.text = "Discount : \(mo.discount ?? 0)"
        
        if mo.amount ?? 0 < 0 {
            cell.image.image = UIImage(named: "inc")
            cell.mountLabel.textColor = UIColor.red
        }else {
            cell.image.image = UIImage(named: "min")
            cell.mountLabel.textColor = UIColor.green
        }
        
        return cell
    }

    
    func getData()  {
        
        let loading =  LoadingViewClass()
        loading.startLoading()
        
        let param:[String:Any] = ["":""]
        
        ServiceAPI.shared.fetchGenericData(urlString:MD_TRANSACTIONLOG , parameters: param, methodInput:.post,isHeaders: true) { (model:[ModelTransactionLog]?,error:Error?,status:Int?) in
            
            loading.stopLoading()
            if status == 200 {
                
                self.model = model ?? []
                self.collectionView.reloadData()
                
            }else if status == 500{
                
           CSS_Class.alertviewController_title("" , messageAlert:"ERRORMSG".localized(), viewController: self, okPop: false)
                
            }
            
            
        }
        
        
    }
    
    
}
