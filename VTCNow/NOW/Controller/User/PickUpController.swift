//
//  PickUpController.swift
//  NOW
//
//  Created by dovietduy on 4/22/21.
//

import UIKit
class PickUpController: UIViewController {
    @IBOutlet weak var collView1: UICollectionView!
    @IBOutlet weak var collView2: UICollectionView!
    @IBOutlet weak var viewDelete: UIView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewDone: UIView!
    var onComplete: ((Int) -> ())!
    var onDelete: (() -> ())!
    var listData: [String] = []
    var list5: [String] = []
    var idList = 0
    
    var isEditor = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collView1.delegate = self
        collView1.dataSource = self
        collView1.register(UINib(nibName: WordCell.className, bundle: nil), forCellWithReuseIdentifier: WordCell.className)
        let layout2 = LeftAlignedCellsCustomFlowLayout()
        layout2.estimatedItemSize = CGSize(width: 1, height: 40 * scaleW)
        layout2.minimumLineSpacing = 10 * scaleW
        layout2.minimumInteritemSpacing = 10 * scaleW
        layout2.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView1.collectionViewLayout = layout2
        
        collView2.delegate = self
        collView2.dataSource = self
        collView2.register(UINib(nibName: WordCell.className, bundle: nil), forCellWithReuseIdentifier: WordCell.className)
        let layout = LeftAlignedCellsCustomFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 40 * scaleW)
        layout.minimumLineSpacing = 10 * scaleW
        layout.minimumInteritemSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView2.collectionViewLayout = layout
        
        //
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewDone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewDone(_:))))
        viewDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewDelete(_:))))
        if isEditor {
            viewDelete.isHidden = false
        } else{
            viewDelete.isHidden = true
        }
        APIService.shared.getKeyUser {[weak self] (data, error) in
            if let data = data as? [String] {
                self?.listData = data
                self?.collView2.reloadData()
            }
        }
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
    @objc func didSelectViewDone(_ sender: Any){
        if list5.isEmpty {
            
        } else{
            if isEditor {
                UserDefaults.standard.setValue(list5, forKey: "\(idList)")
                onComplete?(idList)
                navigationController?.popViewController(animated: false)
            } else{
                var count = UserDefaults.standard.integer(forKey: "NumberOfList")
                UserDefaults.standard.setValue(list5, forKey: "\(count)")
                onComplete?(count)
                count += 1
                UserDefaults.standard.setValue(count, forKey: "NumberOfList")
                navigationController?.popViewController(animated: false)
            }
            
        }
    }
    @objc func didSelectViewDelete(_ sender: Any) {
        UserDefaults.standard.setValue([], forKey: "\(idList)")
        onDelete?()
        navigationController?.popViewController(animated: false)
    }
}

extension PickUpController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collView1:
            switch indexPath.row {
            case 0..<list5.count:
                let label = UILabel(frame: .zero)
                label.text = list5[indexPath.row]
                label.font = UIFont(name: "Roboto-Medium", size: 13 * scaleW)
                label.sizeToFit()
                return CGSize(width: label.frame.width + 20 * scaleW, height: 40 * scaleW)
            default:
                if list5.count == 4 {
                    return CGSize(width: 0, height: 0)
                }
                let label = UILabel(frame: .zero)
                label.text = "              "
                label.font = UIFont(name: "Roboto-Medium", size: 13 * scaleW)
                label.sizeToFit()
                return CGSize(width: label.frame.width + 20 * scaleW, height: 40 * scaleW)
            }
            
        default:
            return CGSize(width: 1, height: 40 * scaleW)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collView1:
            return list5.count + 1
        default:
            return listData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collView1:
            switch indexPath.row {
            case 0..<list5.count:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.className, for: indexPath) as! WordCell
                cell.lblTitle.text = list5[indexPath.row]
                cell.viewContain.cornerRadius = 5 * scaleW
                cell.viewContain.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                cell.lblTitle.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.className, for: indexPath) as! WordCell
                cell.lblTitle.text = "              "
                cell.viewContain.cornerRadius = 5 * scaleW
                cell.lblTitle.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
                return cell
            }
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.className, for: indexPath) as! WordCell
            cell.lblTitle.text = listData[indexPath.row]
            cell.viewContain.cornerRadius = 5 * scaleW
            cell.viewContain.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            cell.lblTitle.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView1:
            switch indexPath.row {
            case 0..<list5.count:
                list5.remove(at: indexPath.row)
                collView1.reloadData()
            default:
                break
            }
        default:
            let text = listData[indexPath.row]
            for item in list5 {
                if item == text {
                    view.showToast(message: "Đã thêm!")
                    return
                }
            }
            
            if list5.count < 4 {
                list5.insert(text, at: 0)
                collView1.reloadData()
                 
            } else{
                view.showToast(message: "Tối đa 4 chọn!")
            }
            
        }
    }

}

class ListString {
    var data: [String] = []
}
