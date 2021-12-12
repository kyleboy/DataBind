//
//  ViewController.swift
//  DataBind
//
//  Created by iyinghui@163.com on 12/01/2021.
//  Copyright (c) 2021 iyinghui@163.com. All rights reserved.
//

import UIKit

import DataBind

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signIn: UIButton!
    
    var user: String?
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let data = DataBind()
        print(data.user ?? "")
        
        let data1 = DataBind()
        print(data1.user ?? "")
        print(user ?? "")
        
        user = "newTest"
//        titleLabel.addObserver(self, forKeyPath: "./.text", options: .new, context: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func accountChanged(_ sender: UITextField) {
        viewModel.account.value = sender.text
    }
    
    @IBAction func presentSelf(_ sender: Any) {
        
        self.present(Self(), animated: true, completion: nil)
    }
}


class ViewModel: NSObject {
    var account = Observable<String?>(nil)
    var password: String?
    
    override init() {
        super.init()
        
        let sub1 = account.afterChange.add(owner: self) { value in
            print("newValue: \(value.newValue ?? ""), oldValue: \(value.oldValue ?? "")")
        }
        account.afterChange.remove(subscriber: sub1)
        
        let sub2 = account.afterChange.add(owner: self) { value in
            print("newValue: \(value.newValue ?? ""), oldValue: \(value.oldValue ?? "")")
        }
        account.afterChange.remove(subscriber: sub2)
        
        let sub3 = account.afterChange.add(owner: self) { value in
            print("newValue: \(value.newValue ?? ""), oldValue: \(value.oldValue ?? "")")
        }
    }
    
    deinit {
        
    }
}
