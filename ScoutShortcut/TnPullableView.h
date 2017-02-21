//
//  TnShortcutPullableView.h
//  PullableView
//
//  Created by Zhang, Wanming - (p) on 2/18/17.
//  Copyright © 2017 ClaireZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TnPullableView;

/**
 Protocol for objects that wish to be notified when the state of a
 PullableView changes
 */
@protocol PullableViewDelegate <NSObject>

/**
 Notifies of a changed state
 @param pView PullableView whose state was changed
 @param opened The new state of the view
 */
- (void)pullableView:(TnPullableView *)pView didChangeState:(BOOL)opened;

@end

@interface TnPullableView : UIView {
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    UIView *handleView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL opened;
    BOOL verticalAxis;
    
    BOOL toggleOnTap;
    
    BOOL animate;
    float animationDuration;

    __weak id<PullableViewDelegate> delegate;
}

//@property (nonatomic, weak) id <PullableViewDelegate> delegate;

/**
 The view that is used as the handle for the PullableView. You
 can style it, add subviews or set its frame at will.
 */
@property (nonatomic,readonly) UIView *handleView;

/**
 The point that defines the center of the view when in its closed
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint closedCenter;

/**
 The point that defines the center of the view when in its opened
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint openedCenter;

/**
 Gesture recognizer responsible for the dragging of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UIPanGestureRecognizer *dragRecognizer;

/**
 Gesture recognizer responsible for handling tapping of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UITapGestureRecognizer *tapRecognizer;

/**
 If set to YES, tapping the handle view will toggle the PullableView.
 Default value is YES.
 */
@property (readwrite,assign) BOOL toggleOnTap;

/**
 If set to YES, the opening or closing of the PullableView will
 be animated. Default value is YES.
 */
@property (readwrite,assign) BOOL animate;

/**
 Duration of the opening/closing animation, if enabled. Default
 value is 0.2.
 */
@property (readwrite,assign) float animationDuration;

/**
 Delegate that will be notified when the PullableView changes state.
 If the view is set to animate transitions, the delegate will be
 called only when the animation finishes.
 */
@property (readwrite, weak) id<PullableViewDelegate> delegate;

/**
 The current state of the `PullableView`.
 */
@property (readonly, assign) BOOL opened;

/**
 Toggles the state of the PullableView
 @param op New state of the view
 @param anim Flag indicating if the transition should be animated
 */
- (void)setOpened:(BOOL)op animated:(BOOL)anim;

@end
