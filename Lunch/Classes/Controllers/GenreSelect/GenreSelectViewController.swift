//
//  GenreSelectViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

typealias GenreSelectCompletion = (Genre) -> Void

internal final class GenreSelectViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    fileprivate var genreList: [Genre] = []
    private var completion: GenreSelectCompletion?
    
    // MARK: - Initializer
    
    static func instantiate(completion: GenreSelectCompletion? = nil) -> GenreSelectViewController {
        let viewController =  R.storyboard.genreSelectViewController.genreSelectViewController()!
        viewController.completion = completion
        return viewController
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("ジャンル選択", headerItems: HeaderItems(leftItems: [.close], rightItems: nil))
        tableView.register(GenreSelectTableCell.self)
        genreList = GenreManager.shared.genreListDataFromRealm()
    }
    
    // MARK: - IBAction
    
}

// MARK: - UITableViewDataSource

extension GenreSelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GenreSelectTableCell
        cell.setup(genre: genreList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GenreSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dismissCompletion: () -> Void = {
            self.completion?(self.genreList[indexPath.row])
        }
        dismiss(animated: true, completion: dismissCompletion)
    }
}
