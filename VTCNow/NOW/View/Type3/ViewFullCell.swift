//
//  ViewFullCell.swift
//  NOW
//
//  Created by dovietduy on 4/1/21.
//

import UIKit

class ViewFullCell: UICollectionViewCell {
    static let reuseIdentifier = "ViewFullCell"
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collDotView: UICollectionView!
    @IBOutlet weak var lblXemToanCanh: UILabel!
    
    @IBOutlet weak var widthCollDotView: NSLayoutConstraint!
    var delegate: ViewFullCellDelegate!
    var timer = Timer()
    var indexPath = IndexPath(row: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.tag = 0
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: ViewFullItemCell.className, bundle: nil), forCellWithReuseIdentifier: ViewFullItemCell.className)
        let layout = PagedFlowLayout()
        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: collView.bounds.height * scaleW)
        collView.collectionViewLayout = layout
        collView.isPagingEnabled = true
        
        collDotView.tag = 1
        collDotView.delegate = self
        collDotView.dataSource = self
        collDotView.register(UINib(nibName: LongDotCell.className, bundle: nil), forCellWithReuseIdentifier: LongDotCell.className)
        let layout2 = UICollectionViewFlowLayout()
        let count = overView.media.count
        widthCollDotView.constant = CGFloat(CGFloat(count * 60) * scaleW) + CGFloat(count - 1) * 10 * scaleW
        layout2.itemSize = CGSize(width: 60 * scaleW, height: 2 * scaleW)
        layout2.minimumLineSpacing = 10 * scaleW
        layout2.minimumInteritemSpacing = 0
        collDotView.collectionViewLayout = layout2
        //
        lblXemToanCanh.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectXemToanCanh(_:))))
        viewContainer.dropShadow()
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: {[self] (timer) in
            if indexPath.row < overView.media.count{
                indexPath.row += 1
            } else{
                indexPath.row = 0
            }
            collView.isPagingEnabled = false
            if indexPath.row < overView.media.count {
                collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            collView.isPagingEnabled = true
        })
    }
    func layout(){
        let layout2 = UICollectionViewFlowLayout()
        let count = overView.media.count
        widthCollDotView.constant = CGFloat(CGFloat(count * 60) * scaleW) + CGFloat(count - 1) * 10 * scaleW
        layout2.itemSize = CGSize(width: 60 * scaleW, height: 2 * scaleW)
        layout2.minimumLineSpacing = 10 * scaleW
        layout2.minimumLineSpacing = 10 * scaleW
        collDotView.collectionViewLayout = layout2
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    @objc func didSelectXemToanCanh(_ sender: Any){
        delegate?.didSelectXemToanCanh()
    }
}
extension ViewFullCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return overView.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewFullItemCell.reuseIdentifier, for: indexPath) as! ViewFullItemCell
            let item = overView.media[indexPath.row]
            cell.lblTitle.text = item.name
            cell.lblTime.text = " "
            //cell.lblDescription.text = item.descripTion
            cell.lblDescription.isHidden = true
            if let image = overViewImages[indexPath.row]{
                cell.imgThumb.image = image
            } else {
                if let url = URL(string: root.cdn.imageDomain + item.thumnail800_450.replacingOccurrences(of: "\\", with: "/" )){
                    cell.imgThumb.loadImage(fromURL: url)
                }
            }
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongDotCell.reuseIdentifier, for: indexPath) as! LongDotCell
            if indexPath == self.indexPath{
                cell.viewDot.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            }else{
                cell.viewDot.backgroundColor = .lightGray
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
            self.indexPath = indexPath
            collDotView.reloadData()
            break
        default:
            break
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        APIService.shared.getPlaylist(privateKey: overView.media[indexPath.row].privateKey) {[weak self] (data, error) in
//            if let data = data as? CategoryModel{
//                news = data
//                self?.delegate?.didSelectItemAt()
//            }
//        }
        let temp = overView.copy()
        let item = overView.media[indexPath.row]
        temp.media.remove(at: indexPath.row)
        temp.media.insert(item, at: 0)
        news = temp
        delegate?.didSelectItemAt()
    }
}
protocol ViewFullCellDelegate: Type3Cell {
    func didSelectItemAt()
    func didSelectXemToanCanh()
}
