//
//  ViewController.swift
//  StackX App
//
//  Created by User on 1/31/20.
//  Copyright © 2020 Jason B. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    let notificationName = Notification.Name("didReceiveData")
    var questionArray = [String]()
    let tableview: UITableView = {
        let stackxTableView = UITableView()
        stackxTableView.backgroundColor = UIColor.white
        stackxTableView.translatesAutoresizingMaskIntoConstraints = false
        return stackxTableView
    }()
    let networkClient = NetworkClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name:notificationName , object: nil)
        setupTableView()
        networkClient.retrieveApiData()
        
    }
    // Set Constraints and add the subview for the table
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    //use notification to know when api call is complete then reload tableview
    @objc func onDidReceiveData(_ notification:Notification) {
        //Get questions from model, pass into array
        self.questionArray = DataModel.questionModel.questions
        //reload table with questionModel on the main thread
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = self.questionArray[indexPath.row]
        return cell
    }
}

