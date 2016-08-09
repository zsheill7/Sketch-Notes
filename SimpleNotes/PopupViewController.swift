//
//  PopupViewController.swift
//  SimpleNotes
//
//  Created by Zoe on 8/6/16.
//  Copyright © 2016 Zoe. All rights reserved.
//

import UIKit


class PopupViewController: UIViewController, UIPopoverControllerDelegate {
    
    
    
        
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 100, height: 400)
        }
        set {
            super.preferredContentSize = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func erase(sender: AnyObject?) {
        resetSelected = true
        self.performSegueWithIdentifier("goBack", sender: self)

    }
    
    @IBAction func textOnly(sender: AnyObject?) {
        
    }
    
    @IBAction func share(sender: AnyObject?) {
        shareSelected = true
       self.performSegueWithIdentifier("goBack", sender: self)
    }
    
    @IBAction func settings(sender: AnyObject?) {
        //var goToSettings = true
       
        settingsSelected = true
        
        
        print("gotosettings")
        self.performSegueWithIdentifier("goBack", sender: self)
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("here1")
        if segue.identifier == "goToSettings" {
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            //settingsViewController.delegate = self
            settingsViewController.brush = brushWidth
            settingsViewController.opacity = opacity
            
            settingsViewController.red = red
            settingsViewController.green = green
            settingsViewController.blue = blue
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
        
            print("here2")
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.goToSettings = true
        
        }
        
        
        
        
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
