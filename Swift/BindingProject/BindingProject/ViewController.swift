//
//  ViewController.swift
//  BindingProject
//
//  Created by Apple on 28/11/16.
//  Copyright © 2016 vijayvirSingh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "BindTable",
                                                 in:context)
        
        let user = NSManagedObject(entity: entity!,
                                   insertInto: context)
        
        var data : Dictionary<  String, Any>? =  [:]
        
        
        data?["stringBind"] = "VijayVir"
        
        data?["intBind"] = "33"
        
        data?["floatBind"] = 43
        
        data?["doubleBind"] = 4343
   
   
        data?["boolBind"] = true
        
        data?["dateBind"] =  "Mon, 28 Nov 2016 03:49:20 -0500"  //Date()

        user.dataBinding(dictionary: data ,dateformat: basicDateformat.g.rawValue )
        
        print(user)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

