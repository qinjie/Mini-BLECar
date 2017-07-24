//
//  ListSongsViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import MediaPlayer

class ListSongsViewController: UIViewController {
    @IBOutlet weak var tbl : UITableView!
    let identifierCell = "SongTableViewCell"
    var listSongs = [MPMediaItem]()
    var avplayer : AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        
        let mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        
        mediaPicker.prompt = "Please Pick a Song"
        
        present(mediaPicker, animated: true) {
            
        }
    }
    
    func setupTableView(){
        self.tbl.dataSource = self
        self.tbl.delegate = self
        self.tbl.register(UINib.init(nibName: self.identifierCell, bundle: nil), forCellReuseIdentifier: self.identifierCell)
        self.tbl.estimatedRowHeight = 100
        self.tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListSongsViewController : MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        NSLog("Pick Item")
        for item in mediaItemCollection.items {
            print("Add \(item.title ?? "") to a playlist, prep the player, etc")
            self.listSongs.append(item)
        }
        mediaPicker.dismiss(animated: true, completion: nil)
        self.tbl.reloadData()
    }
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        NSLog("Cancel")
    }
}

extension ListSongsViewController : UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell") as! SongTableViewCell
        
        let obj = self.listSongs[indexPath.row]
        cell.setSongs(obj: obj)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.listSongs[indexPath.row]
        let url = obj.assetURL
        
        let urlAsset = AVURLAsset.init(url: url!)
        
        let playerItem = AVPlayerItem.init(asset: urlAsset)
        
        self.avplayer = AVPlayer.init(playerItem: playerItem)
        
        self.avplayer?.play()
    }
}
