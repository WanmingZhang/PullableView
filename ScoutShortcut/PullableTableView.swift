//
//  PullableTableView.swift
//  ScoutShortcut
//
//  Created by Zhang, Wanming - (p) on 2/8/21.
//  Copyright © 2021 ClaireZhang. All rights reserved.
//

import UIKit

@objc protocol PullableTableViewProtocol: class {

    /**
     Notifies of a changed state
     @param pullView VividPullableView whose state was changed
     @param opened The new state of the view
     */
    func pullableViewDidChangeState(pullableView: PullableTableView, opened: Bool)
}


class PullableTableView: UITableView, UIGestureRecognizerDelegate {
    
    /**
     Delegate that will be notified when the PullableView changes state.
     If the view is set to animate transitions, the delegate will be
     called only when the animation finishes.
     */
    @objc weak var pullableTableViewDelegate: PullableTableViewProtocol?
    
    /**
     The point that defines the center of the view when in its closed
     state. You must set this before using the PullableView.
     */
    var closedCenter: CGPoint

    /**
     The point that defines the center of the view when in its opened
     state. You must set this before using the PullableView.
     */
    var openedCenter: CGPoint

    /**
     Gesture recognizer responsible for the dragging of the handle view.
     It is exposed as a property so you can change the number of touches
     or created dependencies to other recognizers in your views.
     */
    var dragRecognizer: UIPanGestureRecognizer?

    /**
     The current state of the `PullableView`.
     */
    var opened: Bool

    
    var startPos: CGPoint
    var minPos: CGPoint
    var maxPos: CGPoint
    var verticalAxis: Bool
    
    override init(frame: CGRect, style: UITableView.Style) {
        opened = false
        verticalAxis = true
        openedCenter = CGPoint(x: frame.size.width/2, y: 0)
        closedCenter = CGPoint(x: frame.size.width/2, y:frame.size.height/2)
        startPos = closedCenter
        minPos = closedCenter
        maxPos = openedCenter

        super.init(frame: frame, style: style)
        
        let dragRecognizer = UIPanGestureRecognizer.init(target: self, action:#selector(handleDrag(sender:)))
        self.addGestureRecognizer(dragRecognizer)
        self.dragRecognizer = dragRecognizer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleDrag(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            startPos = self.center
            // Determines if the view can be pulled in the x or y axis
            verticalAxis = closedCenter.x == openedCenter.x
            
            // Finds the minimum and maximum points in the axis
            if (verticalAxis) {
                minPos = closedCenter.y < openedCenter.y ? closedCenter : openedCenter
                maxPos = closedCenter.y > openedCenter.y ? closedCenter : openedCenter
            } else {
                minPos = closedCenter.x < openedCenter.x ? closedCenter : openedCenter
                maxPos = closedCenter.x > openedCenter.x ? closedCenter : openedCenter
            }
            
        } else if sender.state == UIGestureRecognizer.State.changed {
            
            var translate = sender.translation(in: self.superview)

            var newPos = CGPoint (x: startPos.x, y: startPos.y + translate.y)

            // Moves the view, keeping it constrained between openedCenter and closedCenter
            if (verticalAxis) {
                if (newPos.y < minPos.y) {
                    newPos.y = minPos.y;
                    translate = CGPoint(x: 0, y: newPos.y - startPos.y);
                }

                if (newPos.y > maxPos.y) {
                    newPos.y = maxPos.y;
                    translate = CGPoint(x: 0, y: newPos.y - startPos.y);
                }
                    
            } else {
                newPos = CGPoint(x: startPos.x + translate.x, y: startPos.y)

                if (newPos.x < minPos.x) {
                    newPos.x = minPos.x;
                    translate = CGPoint(x: newPos.x - startPos.x, y: 0);
                }

                if (newPos.x > maxPos.x) {
                    newPos.x = maxPos.x;
                    translate = CGPoint(x: newPos.x - startPos.x, y: 0);
                }
            }

            sender.setTranslation(translate, in: self.superview)
            self.center = newPos
            
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            
            // Gets the velocity of the gesture in the axis, so it can be
            // determined to which endpoint the state should be set.
            let kCancellationThreshold: CGFloat = 0.2;
            let vectorVelocity = sender.velocity(in: self.superview)
            let axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x

            let progress = verticalAxis ? abs(axisVelocity)/abs(maxPos.y-minPos.y) : abs(axisVelocity)/abs(maxPos.x-minPos.x)

            let shouldComplete = progress > kCancellationThreshold

            if (shouldComplete == true) {
                //self.setOpened(open: !opened, animated: animate)

            } else {
                //self.setOpened(open: opened, animated: animate)
            }
        }
    }
    
    /**
     Toggles the state of the PullableView
     @param op New state of the view
     */
    func setOpened(open:Bool) {
        opened = open
    
        self.center = opened ? openedCenter : closedCenter;

        self.pullableTableViewDelegate?.pullableViewDidChangeState(pullableView: self, opened: opened)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        //let direction = gesture.velocity(in: self).y

        self.isScrollEnabled = false
        return true
    }

}
