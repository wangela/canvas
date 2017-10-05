//
//  ViewController.swift
//  canvas
//
//  Created by Angela Yu on 10/4/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var trayIsOpen: Bool!
    var newlyCreatedFace: UIImageView!
    var newFaceOriginalCenter: CGPoint!
    var existingFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayCenterWhenOpen = CGPoint(x: 187.5, y: 566)
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 726)
        trayView.center = trayCenterWhenClosed
        trayIsOpen = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let point = sender.location(in: view)
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("Gesture began at: \(point)")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture changed at: \(point)")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended at: \(point)")
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                if velocity.y > 0 {
                    self.trayView.center = self.trayCenterWhenClosed
                    self.trayIsOpen = false
                } else {
                    self.trayView.center = self.trayCenterWhenOpen
                    self.trayIsOpen = true
                }
            })
        }
    }
    
    @IBAction func onTapGesture(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            if self.trayIsOpen {
                self.trayView.center = self.trayCenterWhenClosed
                self.trayIsOpen = false
            } else {
                self.trayView.center = self.trayCenterWhenOpen
                self.trayIsOpen = true
            }
        })
    }
    
    @IBAction func onSmileyPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // Gesture recognizers know the view they are attached to
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Initialize the pan gesture recognizer for the new face
            let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPanSmiley(_:)))
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGR)
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
            self.newlyCreatedFace.center = CGPoint(x: self.newFaceOriginalCenter.x + translation.x, y: self.newFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
        }
    }
    
    @objc func didPanSmiley(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        // Gesture recognizers know the view they are attached to
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            existingFaceOriginalCenter = imageView.center
        } else if sender.state == .changed {
            imageView.center = CGPoint(x: self.existingFaceOriginalCenter.x + translation.x, y: self.existingFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
        }
    }
}

