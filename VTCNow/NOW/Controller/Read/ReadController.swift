//
//  ReadController.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit

class ReadController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: ReadACell.className, bundle: nil), forCellWithReuseIdentifier: ReadACell.className)
        collView.register(UINib(nibName: ReadBCell.className, bundle: nil), forCellWithReuseIdentifier: ReadBCell.className)
        collView.register(UINib(nibName: WeatherCell.className, bundle: nil), forCellWithReuseIdentifier: WeatherCell.className)
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        collView.collectionViewLayout = layout
    }
    
}
extension ReadController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return reads.count - 1
        default:
            return 0
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == reads.count - 5{
            page += 1
            APIService.shared.getRead (page: page.description) { (data, error) in
                if let data = data as? [ReadModel]{
                    reads += data
                    self.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.className, for: indexPath) as! WeatherCell
            cell.viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnSearch(_:))))
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadACell.className, for: indexPath) as! ReadACell
            let item = reads[0]
            cell.lblTitle.text = item.title
            cell.lblTime.text = item.timePass
            if let url = URL(string: item.image16_9){
                cell.imgThumb.loadImage(fromURL: url)
            }
            cell.item = item
            cell.view3Dot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView3Dot(_:))))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadBCell.className, for: indexPath) as! ReadBCell
            let item = reads[indexPath.row + 1]
            cell.lblTitle.text = item.title
            cell.lblTime.text = item.timePass
            if let url = URL(string: item.image16_9){
                cell.imgThumb.loadImage(fromURL: url)
            }
            cell.item = item
            cell.view3Dot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView3Dot(_:))))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadACell.className, for: indexPath) as! ReadACell
            return cell
        }
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didSelectView3Dot(_ sender: UITapGestureRecognizer){
        if let cell = sender.view?.superview?.superview as? ReadACell{
            let vc = storyboard?.instantiateViewController(withIdentifier: PopUp6Controller.className) as! PopUp6Controller
            vc.data = cell.item
            vc.modalPresentationStyle = .custom
            vc.modalTransitionStyle = .crossDissolve
            present(vc, animated: true, completion: nil)
        }
        if let cell = sender.view?.superview?.superview as? ReadBCell{
            let vc = storyboard?.instantiateViewController(withIdentifier: PopUp6Controller.className) as! PopUp6Controller
            vc.data = cell.item
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}
extension ReadController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return  CGSize(width: 414 * scaleW, height: 50 * scaleW)
        case 1:
            return  CGSize(width: 414 * scaleW, height: 330 * scaleW)
        case 2:
            return  CGSize(width: 414 * scaleW, height: 130 * scaleW)
        default:
            return  .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailWebviewController.className) as! ReadDetailWebviewController
            vc.url = reads[indexPath.row].detailUrl
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailWebviewController.className) as! ReadDetailWebviewController
            vc.url = reads[indexPath.row + 1].detailUrl
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
}
