//
//  PullableView.swift
//  ScoutShortcut
//
//  Created by Zhang, Wanming - (p) on 2/8/21.
//  Copyright © 2021 ClaireZhang. All rights reserved.
//


import UIKit

@objc protocol PullableViewProtocol: class {

    /**
     Notifies of a changed state
     @param pullView VividPullableView whose state was changed
     @param opened The new state of the view
     */
    func pullableViewDidChangeState(pullableView: PullableView, opened: Bool)
}

class PullableView: UIView {
    let handleHeight: CGFloat = 50.0
    
    /**
     Delegate that will be notified when the PullableView changes state.
     If the view is set to animate transitions, the delegate will be
     called only when the animation finishes.
     */
    @objc weak var pullableViewDelegate: PullableViewProtocol?
    
    /**
     The view that is used as the handle for the PullableView. You
     can style it, add subviews or set its frame at will.
     */
    
    var handleView: UIView

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
     Gesture recognizer responsible for handling tapping of the handle view.
     It is exposed as a property so you can change the number of touches
     or created dependencies to other recognizers in your views.
     */
    var tapRecognizer: UITapGestureRecognizer?

    /**
     If set to YES, tapping the handle view will toggle the PullableView.
     Default value is YES.
     */
    var toggleOnTap: Bool

    /**
     If set to YES, the opening or closing of the PullableView will
     be animated. Default value is YES.
     */
    var animate: Bool

    /**
     Duration of the opening/closing animation, if enabled. Default
     value is 0.2.
     */
    var animationDuration: Double

    /**
     The current state of the `PullableView`.
     */
    var opened: Bool

    
    var startPos: CGPoint
    var minPos: CGPoint
    var maxPos: CGPoint
    var verticalAxis: Bool
    
    override init(frame: CGRect) {
        animate = false
        animationDuration = 0.2
        opened = false
        toggleOnTap = true
        verticalAxis = true
        
        openedCenter = CGPoint(x: frame.size.width/2, y: 0)
        closedCenter = CGPoint(x: frame.size.width/2, y:frame.size.height/2)
        
        
        startPos = closedCenter
        minPos = closedCenter
        maxPos = openedCenter
        
        // Creates the handle view. Subclasses should resize, reposition and style this view
        handleView = UIView.init(frame: CGRect(x: 0, y:0 , width: frame.size.width, height: handleHeight))
        
        super.init(frame: frame)
        
        let dragRecognizer = UIPanGestureRecognizer.init(target: self, action:#selector(handleDrag(sender:)))
        self.addGestureRecognizer(dragRecognizer)
        self.dragRecognizer = dragRecognizer
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        handleView.addGestureRecognizer(tapRecognizer)
        self.tapRecognizer = tapRecognizer
        
        self.addSubview(handleView)
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

    @objc func handleTap(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            self.setOpened(open: !opened, animated: animate)
        }
    }
    
    /**
     Toggles the state of the PullableView
     @param op New state of the view
     @param anim Flag indicating if the transition should be animated
     */
    func setOpened(open:Bool, animated: Bool) {
        opened = open
        
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(animationDuration)
            UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(animationDidStop(animationID:finished:)))
        }
        
        self.center = opened ? openedCenter : closedCenter;

        if (animated) {
            // For the duration of the animation, no further interaction with the view is permitted
            dragRecognizer?.isEnabled = false
            tapRecognizer?.isEnabled = false
            UIView.commitAnimations()

        } else {
            self.pullableViewDelegate?.pullableViewDidChangeState(pullableView: self, opened: opened)
        }
    }

    @objc func animationDidStop(animationID: String, finished: Bool) {
        
        if finished {
            // Restores interaction after the animation is over
            dragRecognizer?.isEnabled = true
            tapRecognizer?.isEnabled = toggleOnTap
        }
        guard let delegate = pullableViewDelegate else {
            return
        }
        
        delegate.pullableViewDidChangeState(pullableView: self, opened: opened)
    }


}
