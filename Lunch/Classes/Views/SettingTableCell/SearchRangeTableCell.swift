//
//  SearchRangeTableCell.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/29.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit
import HSegmentControl

internal class SearchRangeTableCell: UITableViewCell {
    
    @IBOutlet private weak var segmentControl: HSegmentControl!
    
    fileprivate var searchRangeList: [SearchRange] {
        return [.tiny, .small, .middle, .large, .huge]
    }
    
    static func instantiate(_ owner: AnyObject) -> SearchRangeTableCell {
        let cell = R.nib.searchRangeTableCell.firstView(owner: owner, options: nil)!
        cell.segmentControl.dataSource = cell
        cell.segmentControl.numberOfDisplayedSegments = cell.searchRangeList.count
        cell.segmentControl.selectedTitleFont = UIFont.systemFont(ofSize: 14)
        cell.segmentControl.selectedTitleColor = UIColor.white
        cell.segmentControl.unselectedTitleFont = UIFont.systemFont(ofSize: 14)
        cell.segmentControl.unselectedTitleColor = UIColor.gray
        cell.segmentControl.segmentIndicatorView.backgroundColor = DeviceModel.themeColor.color
        cell.segmentControl.selectedIndex = cell.searchRangeList.index(of: DeviceModel.searchRange)!
        return cell
    }
    
    @IBAction func valueChanged(segmentControl: HSegmentControl) {
        DeviceModel.searchRange = searchRangeList[segmentControl.selectedIndex]
        AppDelegate.reloadScreen()
    }
}

extension SearchRangeTableCell: HSegmentControlDataSource {
    
    func numberOfSegments(_ segmentControl: HSegmentControl) -> Int {
        return searchRangeList.count
    }
    
    func segmentControl(_ segmentControl: HSegmentControl, titleOfIndex index: Int) -> String {
        return searchRangeList[index].title
    }
}

