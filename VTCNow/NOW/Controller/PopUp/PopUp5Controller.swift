//
//  PopUp5Controller.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import UIKit

class PopUp5Controller: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBack: UIView!

    var onDississ: ((Int) -> Void)!
    var onSelected: (() -> Void)!

    var listData: [MediaModel] = []
    var idPlaying = 0
    override func viewDidLoad() {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: Book2Cell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: Book2Cell.reuseIdentifier)
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}
extension PopUp5Controller: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Book2Cell.reuseIdentifier, for: indexPath) as! Book2Cell
        let item = listData[indexPath.row]
        
        cell.lblTitle.text = item.name
        if item.episode != "" {
            cell.lblAuthor.text = "Phần " + item.episode + "/" + item.totalEpisode
        } else{
            cell.lblAuthor.text = ""
        }
        
        if indexPath.row == idPlaying{
            cell.lblTitle.textColor = .purple
            cell.lblAuthor.textColor = .purple
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idPlaying = indexPath.row
        onDississ?(idPlaying)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * scaleW
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
