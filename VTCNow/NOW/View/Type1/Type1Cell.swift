//
//  Type1Cell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type1Cell: UICollectionViewCell {
    static let reuseIdentifier = "Type1Cell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collViewDot: UICollectionView!
    @IBOutlet weak var widthCollDot: NSLayoutConstraint!
    var delegate: Type1CellDelegate!
    var timer = Timer()
    var indexPath = IndexPath(row: 0, section: 0)
    var data = CategoryModel(){
        didSet{
            if data.media.count >= 3 {
                widthCollDot.constant = 40 * scaleW
            }else{
                widthCollDot.constant = 40 * scaleW
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.tag = 0
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type1ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type1ItemCell.className)
        let layout = PagedFlowLayout()
        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: collView.bounds.height * scaleW)
        collView.collectionViewLayout = layout
        collView.isPagingEnabled = true
        //
        collViewDot.tag = 1
        collViewDot.delegate = self
        collViewDot.dataSource = self
        collViewDot.register(UINib(nibName: DotCell.className, bundle: nil), forCellWithReuseIdentifier: DotCell.className)
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: 10 * scaleW, height: 10 * scaleW)
        layout2.minimumLineSpacing = 5
        layout2.scrollDirection = .horizontal
        collViewDot.collectionViewLayout = layout2
        
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: {[self] (timer) in
            if indexPath.row < 3{
                indexPath.row += 1
            } else{
                indexPath.row = 0
            }
            collView.isPagingEnabled = false
            if indexPath.row < 3 {
                collView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
            collView.isPagingEnabled = true
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}
extension Type1Cell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let count = collView.visibleCells.count
//        if count == 2 {
//            let id0 = collView.indexPath(for: collView.visibleCells[0])!
//            let id1 = collView.indexPath(for: collView.visibleCells[1])!
//            if id0.row < id1.row {
//                if self.indexPath != id0{
//                    self.indexPath = id0
//                    print("scrolldidScroll")
//                    collViewDot.reloadData()
//                }
//            }else{
//                if self.indexPath != id1{
//                    self.indexPath = id1
//                    print("scrolldidScroll")
//                    collViewDot.reloadData()
//                }
//            }
//        } else{
//            let id0 = collView.indexPath(for: collView.visibleCells[0])!
//            if self.indexPath != id0{
//                self.indexPath = id0
//                print("scrolldidScroll")
//                collViewDot.reloadData()
//            }
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            if data.media.count >= 3 {
                return 3
            }
            return data.media.count
        default:
            if data.media.count >= 3 {
                return 3
            }
            return data.media.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type1ItemCell.className, for: indexPath) as! Type1ItemCell
            let item = data.media[indexPath.row]
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            cell.item = item
            cell.lblTitle.text = item.name
            //cell.lblTime.text = item.timePass
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DotCell.className, for: indexPath) as! DotCell
            if indexPath == self.indexPath{
                cell.viewDot.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            }else{
                cell.viewDot.backgroundColor = .gray
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            self.indexPath = indexPath
            collViewDot.reloadData()
            if data.media.count < 3{
                APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: "0") { (data, error) in
                    if let data = data as? [MediaModel]{
                        self.data.media += data
                        self.widthCollDot.constant = 40 * scaleW
                        self.collView.reloadData()
                    }
                }
            }
        default:
            break
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
//            let count = data.media.count
//
//            var list: [MediaModel] = []
//            if count == 1{
//                list = []
//            } else if count == 2{
//                if indexPath.row == 0 {
//                    list.append(data.media[1])
//                } else{
//                    list.append(data.media[0])
//                }
//            } else if count >= 3 {
//                if indexPath.row == 0{
//                    list = Array(data.media[1...count-1])
//                } else if indexPath.row == count-1 {
//                    list = Array(data.media[0...count - 2])
//                } else{
//                    list = Array(data.media[indexPath.row+1...count-1] + data.media[0...indexPath.row-1])
//                }
//            }
//            APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
//                if let data = data as? MediaModel{
//                    self.delegate?.didSelectItemAt(data, list, self)
//                }
//            }
            let temp = self.data.copy()
            let item = data.media[indexPath.row]
            temp.media.remove(at: indexPath.row)
            temp.media.insert(item, at: 0)
            news = temp
            delegate?.didSelectItemAt(self)
        default:
            break
        }
        
    }
}
protocol Type1CellDelegate: class{
//    func didSelectItemAt(_ data: MediaModel,_ list: [MediaModel],_ cell: Type1Cell)
    func didSelectItemAt(_ cell: Type1Cell)
}
class PagedFlowLayout: UICollectionViewFlowLayout {

  override init() {
    super.init()
    self.scrollDirection = .horizontal
    self.minimumLineSpacing = 0 // line spacing is the horizontal spacing in horizontal scrollDirection
    self.minimumInteritemSpacing = 0
    if #available(iOS 11.0, *) {
      self.sectionInsetReference = .fromSafeArea // for iPhone X
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("not implemented")
  }

  // Note: Setting `minimumInteritemSpacing` here will be too late. Don't do it here.
  override func prepare() {
    super.prepare()
    guard let collectionView = collectionView else { return }
      collectionView.decelerationRate = UIScrollView.DecelerationRate.fast // mostly you want it fast!

      let insetedBounds = collectionView.bounds.inset(by: self.sectionInset)
    self.itemSize = insetedBounds.size
  }
  override func targetContentOffset( //swiftlint:disable:this cyclomatic_complexity
    forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

    guard let collectionView = collectionView else { return proposedContentOffset }

    let pageWidth = itemSize.width + minimumLineSpacing
    let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
    let nearestPage: CGFloat = round(currentPage)
    let isNearPreviousPage = nearestPage < currentPage

    var pageDiff: CGFloat = 0
    let velocityThreshold: CGFloat = 0.5 // can customize this threshold
    if isNearPreviousPage {
      if velocity.x > velocityThreshold {
        pageDiff = 1
      }
    } else {
      if velocity.x < -velocityThreshold {
        pageDiff = -1
      }
    }

    let x = (nearestPage + pageDiff) * pageWidth
    let cappedX = max(0, x) // cap to avoid targeting beyond content
    //print("x:", x, "velocity:", velocity)
    return CGPoint(x: cappedX, y: proposedContentOffset.y)
  }

}
