//
//  NetworkClient.swift
//  StackX App
//
//  Created by User on 2/3/20.
//  Copyright © 2020 Jason B. All rights reserved.
//
import UIKit

class NetworkClient: NSObject {
    var questionArray = [String]()
    //Retrieve questions from API
    func retrieveApiData() {
        guard let url = URL(string: "https://api.stackexchange.com/2.2/questions?fromdate=1580688000&order=desc&sort=activity&site=stackoverflow") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Could not retrieve data")
                    return }
            do {
                //handle response from api/ parse api and pass data into our data model
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                
                if let dictionary = jsonResponse as? [String: Any] {
                    for object in dictionary {
                        if object.key == "items" {
                            let objDict = object.value  as! [Dictionary<String, AnyObject>]
                            for item in objDict {
                                let questionString = item["title"] as? String
                                self.questionArray.append(questionString ?? "N/A")
                                DataModel.questionModel.questions = self.questionArray
                            }
                        }
                    }
                }
                //post notification when api call is finished
                let notificationName = Notification.Name("didReceiveData")
                NotificationCenter.default.post(name: notificationName, object: nil)
                
            } catch let parsingError {
                print("Could not parse json", parsingError)
            }
        }
        task.resume()
    }
}
