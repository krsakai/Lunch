//
//  GenreSelectViewController.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import UIKit

typealias GenreSettingCompletion = () -> Void

internal final class GenreSettingViewController: UIViewController, HeaderViewDisplayable {
    
    // MARK: - IBOutlet
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Property
    fileprivate var genreList: [Genre] = []
    private var completion: GenreSettingCompletion?
    
    // MARK: - Initializer
    
    static func instantiate(completion: GenreSettingCompletion? = nil) -> GenreSettingViewController {
        let viewController =  R.storyboard.genreSettingViewController.genreSettingViewController()!
        viewController.completion = completion
        return viewController
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView("ジャンル設定", headerItems: HeaderItems(leftItems: [.close], rightItems: [.bulk]))
        tableView.register(GenreListCell.self)
        genreList = GenreManager.shared.genreListDataFromRealm()
    }
    // MARK: - IBAction
    
    
    func didTapHeaderButton(buttonType: HeaderButtonType) {
        switch buttonType {
        case .close:
            dismiss(animated: true, completion: completion)
        case .bulk:
            let alert = UIAlertController(title: "一括変更", message: "選択状態を一括で変更します", preferredStyle: .actionSheet)
            let check = UIAlertAction(title: "一括有効", style: UIAlertActionStyle.default) { _ in
                let genreList = GenreManager.shared.genreListDataFromRealm()
                let cloneGenreList = genreList.map { $0.clone }
                cloneGenreList.forEach { $0.isActive = true }
                GenreManager.shared.saveGenreListToRealm(cloneGenreList)
                self.tableView.reloadData()
            }
            let uncheck = UIAlertAction(title: "一括無効",  style: UIAlertActionStyle.default) { _ in
                let genreList = GenreManager.shared.genreListDataFromRealm()
                let cloneGenreList = genreList.map { $0.clone }
                cloneGenreList.forEach { $0.isActive = false }
                GenreManager.shared.saveGenreListToRealm(cloneGenreList)
                self.tableView.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel)
            alert.addAction(check)
            alert.addAction(uncheck)
            alert.addAction(cancelAction)
            AppDelegate.topViewController?.present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource

extension GenreSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GenreListCell
        cell.setup(genre: genreList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GenreSettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! GenreListCell
        cell.toggleCheckBox()
    }
}

