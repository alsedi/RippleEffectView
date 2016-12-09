//
//  EntryViewController.swift
//  RippleEffectView
//
//  Created by Max Alexander on 12/8/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


class EntryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var exampleViewControllers : [UIViewController] = {
        return [
            Example1ViewController()
        ]
    }()

    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome To Ripple Effect View"

        view.addSubview(tableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleViewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell()
        cell.textLabel?.text = "Example \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = exampleViewControllers[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
