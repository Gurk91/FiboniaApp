//
//  CollectionStudentTableViewCell.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 31/May/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import UIKit

class CollectionStudentTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    var collCelldata = currStudent.subjects
    
    func setCollectionViewDelegate<D: UICollectionViewDelegate & UICollectionViewDataSource>(delegate: D, forRow row: Int) {
        
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        collectionView.tag = row
        collectionView.reloadData()
    }

}

extension CollectionStudentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collCelldata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! StudentClassesCollectionViewCell
        cell.classLabel.text = collCelldata[indexPath.row]
        let colors = [UIColor.init(red: 247/255, green: 71/255, blue: 10/255, alpha: 1), UIColor.init(red: 247/255, green: 190/255, blue: 10/255, alpha: 1), UIColor.init(red: 10/255, green: 247/255, blue: 190/255, alpha: 1), UIColor.init(red: 186/255, green: 247/255, blue: 10/255, alpha: 1)]
        
        cell.backView.backgroundColor = colors[indexPath.row % colors.count]
        
        if collCelldata[indexPath.row] == "COMPSCI" {
            cell.setImg(img: "COMPSCI")
        }
        else if collCelldata[indexPath.row] == "CHEM" {
            cell.setImg(img: "CHEM")
        }
        else if collCelldata[indexPath.row] == "ECON" {
            cell.setImg(img: "ECON")
        }
        else if collCelldata[indexPath.row] == "MATH" {
            cell.setImg(img: "MATH")
        }
        else if collCelldata[indexPath.row] == "PHYSICS" {
            cell.setImg(img: "PHYSICS")
        }
        else if collCelldata[indexPath.row] == "BIOLOGY" {
            cell.setImg(img: "BIOLOGY")
        } else {
            cell.setImg(img: "OTHER")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 153, height: 74)
    }
    
}
