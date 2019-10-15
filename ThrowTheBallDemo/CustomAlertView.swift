//
//  CustomAlertView.swift
//  ThrowTheBallDemo
//
//  Created by RTC-HN154 on 10/15/19.
//  Copyright © 2019 RTC-HN154. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController {
    
    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: self.view)
        creatOverlay()
        createAlert()
    }
    
    func creatOverlay() {
        // Create a gray view and set its alpha to 0 so it isn't visible
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }
    
    func createAlert()
    {
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.black
        alertView.alpha = 0
        //làm cho alertView đẹp hơn
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10.0
        
        // Create a button and set a listener on it for when it is tapped. Then the button is added to the alert view
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "FuckOff...."
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        alertView.addSubview(label)
        alertView.addSubview(button)
        view.addSubview(alertView)
        
        
    }
    
    @objc func dismissAlert()
    {
        
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.0
            self.alertView.alpha = 0.0
        }) { (finished) in
            self.alertView.removeFromSuperview()
            self.alertView = nil
        }
    }
    
    @IBAction func showAlertView(sender: UIButton)
    {
        showAlert()
    }
    func showAlert()
    {
        if (alertView == nil)
        {
            createAlert()
        }
        //Tạo sự kiên pan
        createGestureRecognizer()
        
        //
        animator.removeAllBehaviors()
        
        // Animate in the overlay
        UIView.animate(withDuration: 0.4) {
            self.overlayView.alpha = 0.4
        }
        
        
        alertView.alpha = 1.0
        let snapBehaviour = UISnapBehavior(item: alertView, snapTo: view.center)
        
        animator.addBehavior(snapBehaviour)
        
    }
    func createGestureRecognizer()
    {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
    }
    @objc func handlePan(sender: UIPanGestureRecognizer)
    {
        if (alertView != nil)
        {
            let panLocationInView = sender.location(in: self.view)
            
            if (sender.state == .began)
            {
                //                let offset = UIOffset(horizontal: panLocationInAlertView.x - CGRectGetMidX(alertView.bounds), vertical: panLocationInAlertView.y - CGRectGetMidY(alertView.bounds))
                let offset = UIOffset(horizontal: panLocationInView.x - alertView.bounds.midX, vertical: panLocationInView.y - alertView.bounds.midY)
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if (sender.state == .changed)
            {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if (sender.state == .ended)
            {
                animator.removeAllBehaviors()
                snapBehavior = UISnapBehavior(item: alertView, snapTo: self.view.center)
                animator.addBehavior(snapBehavior)
            }
            
        }
}
}
