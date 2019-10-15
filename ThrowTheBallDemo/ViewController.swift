//
//  ViewController.swift
//  ThrowTheBallDemo
//
//  Created by RTC-HN154 on 10/14/19.
//  Copyright © 2019 RTC-HN154. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    var ball = UIImageView()
    var animator = UIDynamicAnimator()
    
    var attachmentBehavior: UIAttachmentBehavior!
    var pushBehavior: UIPushBehavior!
    
    @IBOutlet weak var brickV1: UIView!
    @IBOutlet weak var brickV2: UIView!
    @IBOutlet weak var brickV3: UIView!
    @IBOutlet weak var brickV4: UIView!
    
    @IBOutlet weak var brickB1: UIView!
    @IBOutlet weak var brickB2: UIView!
    @IBOutlet weak var brickB3: UIView!
    @IBOutlet weak var brickB4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.ball = UIImageView(frame: CGRect(x: 180, y: 180, width: 40, height: 40))
        self.ball.image = UIImage(named: "ball")
        self.view.addSubview(ball)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        let gravityBehavior = UIGravityBehavior(items: [self.ball])
        // Thuộc tính
        
//        gravityBehavior.angle = 0.8       // Thay đổi góc tính theo radian
//        gravityBehavior.magnitude = 10     // Tốc độ bay, rơi, chuyển động...
//        gravityBehavior.gravityDirection = CGVector(dx: -2, dy: 3)     // véc tor hướng bay
        
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [self.ball])
        collisionBehavior.addItem(self.brickV1)
        collisionBehavior.addItem(self.brickV2)
        collisionBehavior.addItem(self.brickV3)
        collisionBehavior.addItem(self.brickV4)
        
        collisionBehavior.addItem(self.brickB1)
        collisionBehavior.addItem(self.brickB2)
        collisionBehavior.addItem(self.brickB3)
        collisionBehavior.addItem(self.brickB4)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true  // va phải màn hình
        
        //  Vài delegate
        collisionBehavior.collisionDelegate = self
        animator.addBehavior(collisionBehavior)
        

      
        // MARK: ActtachmentBehavior( Khi muốn quả bóng bay theo hướng chuột thì hàm này sẽ k được dùng)
        
        attachmentBehavior = UIAttachmentBehavior(item: self.ball, attachedToAnchor: self.ball.center)
        
//        attachmentBehavior.length = 20     // Khoảng cách của quả bóng với con trỏ chuột
//        attachmentBehavior.frequency = 5      // Tốc độ quay của quả bóng, càng lớn quay càng nhanh( Tần số dao động)
//        attachmentBehavior.damping = 10             // Khi quả bóng quay nó có thể dãn thêm khoảng cách từ tâm
//        animator.addBehavior(attachmentBehavior)
        
        // MARK: Push
        self.pushBehavior = UIPushBehavior(items: [self.ball], mode: .continuous)
        self.animator.addBehavior(self.pushBehavior)
        
        // MARK: UIdynamicItemBahavior (Các thuộc tính của quả bóng sau khi va chạm)
        let ballProperty = UIDynamicItemBehavior(items: [self.ball])
                ballProperty.elasticity = 1.3     // Độ nảy nên sau khi va chạm
//                ballProperty.allowsRotation = true        // Mặc định của thuộc tính này là true, nếu để false quả bóng sẽ k xoay khi va đập
        //        ballProperty.resistance = 100       // lực chống lại khi ta xoay
//                ballProperty.friction = 1000       // Lực ma sát
//        ballProperty.angularResistance = 100        // dịch ra nghĩa là kháng góc. Nếu để thuộc tính này thì bóng sẽ dừng lại chứ k nảy vô hạn khi độ này cao
        self.animator.addBehavior(ballProperty)
        
        
        // MARK: Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePush(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        print("ended\(String(describing: identifier))")
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        print("began\(String(describing: behavior.boundaryIdentifiers))")
        print(p)
    }
    
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        attachmentBehavior.anchorPoint = gesture.location(in: self.view)
    }
    
    @objc func handlePush(gesture: UITapGestureRecognizer) {
        let p = gesture.location(in: self.view)     // Điểm click
        let o = self.ball.center        // Tâm quả bóng
        let distance = sqrtf(powf(Float(p.x) - Float(o.x), 2.0) + powf(Float(p.y) - Float(o.y), 2.0))       // Khoảng cách
        let angle = atan2f(Float(p.y - o.y), Float(p.x - o.x))      // Góc
        pushBehavior.magnitude = CGFloat(distance/100.0)        // Độ hút. Chỉ số càng lớn thì bay càng nhanh
        pushBehavior.angle = CGFloat(angle)     // Góc bay
    }

}

