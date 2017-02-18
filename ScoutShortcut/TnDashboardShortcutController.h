//
//  TnDashboardShortcutController.h
//  TelenavNavigator
//
//  Created by Zhang, Wanming - (p) on 2/16/17.
//  Copyright © 2017 Telenav, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TnShortcutAnimationDelegate <NSObject>

- (void) expandShortcut;
- (void) collapseShortcut;

@end

@interface TnDashboardShortcutController : UITableViewController <UIViewControllerTransitioningDelegate>

@property (nullable, nonatomic, weak) id <TnShortcutAnimationDelegate> delegate;

@end
