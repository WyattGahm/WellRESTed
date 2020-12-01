//
//  ViewController.swift
//  RestTest
//
//  Created by Wyatt Gahm on 11/25/20.
//

import UIKit
import RestClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let client = RestClient(host: URL(string:"https://your-db.restdb.io/rest/data/")!, key: "your api key here")
        client.extendContext(UUID: "_id for a cell").patchValueForID(id: "state",value: "Hello World!",completion: {response in print(response)})
        client.getValueForID(id: "state", callback: {_, response  in
            print(value)
            print(response)
        })
        client.getUUIDs({UUIDs in
            for n in UUIDs {
                print(n)
            }
        })
    }
    
}
