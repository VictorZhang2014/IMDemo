//
//  VZLoginViewController.swift
//  IMDemo
//
//  Created by VictorZhang on 03/07/2017.
//  Copyright © 2017 Victor Studio. All rights reserved.
//

import UIKit

class VZLoginViewController: UIViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        VZLoginManager.login(withAccount: "18710290897", password: "123456") { (stateCode, stateDesc) in
            
        }
        
    }
     

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
