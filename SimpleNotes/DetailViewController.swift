//
//  DetailViewController.swift
//  SimpleNotes
//
//  Created by Zoe on 8/4/16.
//  Copyright © 2016 Zoe. All rights reserved.
//

import UIKit

extension DetailViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
}

var settingsSelected = false
var resetSelected = false
var textViewSelected = false
var shareSelected = false

class DetailViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate{
    
    
 
    
    var imageChanged = false
    
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        
        
        if objects.count == 0 {
            return
        }
        
       if images.count == 0 {
            self.mainImageView.image = nil
       } else if let currentImage = self.mainImageView {
            currentImage.image = images[currentIndex]
        }
        
        
        print(objects)
        if let label = self.detailDescriptionLabel {
            label.text = objects[currentIndex]
            if label.text == BLANK_NOTE {
                label.text = ""
            }
        }
        
        
        
    }

    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        print(resetSelected)
        if resetSelected == true {
            resetSelected = false
            reset()
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        
        detailViewController = self
        detailDescriptionLabel.becomeFirstResponder()
        detailDescriptionLabel.delegate = self
        self.configureView()
        
        detailDescriptionLabel.userInteractionEnabled = false
        
        
        self.view.bringSubviewToFront(detailDescriptionLabel)
    }
    
    override func viewDidAppear(animated: Bool) {
        configureView()
        print("view did appear")
        if settingsSelected == true {
            settingsSelected = false
            self.performSegueWithIdentifier("goToSettings", sender: self)
        }
        else if shareSelected == true {
            settingsSelected = false
            share()
        }
    }
    override func viewWillAppear(animated: Bool) {
        if resetSelected == true {
            resetSelected = false
            reset()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if objects.count == 0 {
            objects.append("")
        } else {
            objects[currentIndex] = detailDescriptionLabel.text
        }
        
        if detailDescriptionLabel.text == "" && imageChanged == false {
            objects[currentIndex] = BLANK_NOTE
        }
        print(currentIndex)
       
        if images.count == 0 {
            return 
        }
        if let endImage = mainImageView.image{
            images[currentIndex] = endImage
        }
        
        
        saveAndUpdate()
    }
    
    func saveAndUpdate() {
        masterView?.save()
        masterView?.tableView.reloadData()
    }

    func textViewDidChange(textView: UITextView) {
        objects[currentIndex] = detailDescriptionLabel.text
        saveAndUpdate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.view.endEditing(true)
        swiped = false
        if let touch = touches.first  {
            lastPoint = touch.locationInView(self.view)
        }
    }
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        CGContextMoveToPoint(context!, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context!, toPoint.x, toPoint.y)
        /*CGPoint dir = ccpSub(fromPoint, toPoint);
         CGPoint perpendicular = ccpNormalize(ccpPerp(dir));
         CGPoint A = ccpAdd(prevPoint, ccpMult(perpendicular, prevValue / 2));
         CGPoint B = ccpSub(prevPoint, ccpMult(perpendicular, prevValue / 2));
         CGPoint C = ccpAdd(curPoint, ccpMult(perpendicular, curValue / 2));
         CGPoint D = ccpSub(curPoint, ccpMult(perpendicular, curValue / 2))*/
        
        
        CGContextSetLineCap(context!, CGLineCap.Round)
        CGContextSetLineWidth(context!, brushWidth)
        CGContextSetRGBStrokeColor(context!, red, green, blue, 1.0)
        CGContextSetBlendMode(context!, CGBlendMode.Normal)
        
        CGContextStrokePath(context!)
        
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        
        imageChanged = true
    }
    
    @IBAction func reset(sender: AnyObject) {
        
        mainImageView.image = nil
        
        imageChanged = false
    }
    
    func reset() {
    mainImageView.image = nil
    
    imageChanged = false
    }

    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width:  mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func share() {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width:  mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }

    
    @IBAction func pencilPressed(sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    func settings() {
        print("here@settings")

         //self.performSegueWithIdentifier("goToSettings", sender: self)
        //let settingsVC = storyboard?.instantiateViewControllerWithIdentifier("settingsVC")// as! SettingsViewController
        //self.navigationController?.setViewControllers([settingsVC!], animated: false)
    }
    
    
    func createPicker() {
        
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popupView = segue.destinationViewController as! PopupViewController
            if let popup = popupView.popoverPresentationController
            {
                popup.delegate = self
                
            }
            //popupView.delegate = self
            
        } else {
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.delegate = self
            settingsViewController.brush = brushWidth
            settingsViewController.opacity = opacity
            
            settingsViewController.red = red
            settingsViewController.green = green
            settingsViewController.blue = blue
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController){
        
        print("@popoverpresentation")
        
        
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    
   /* func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return
    }*/
   
    
    

}

