//
//  TnDashboardViewController.h
//  PullableView
//
//  Created by Zhang, Wanming - (p) on 2/18/17.
//  Copyright © 2017 ClaireZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TnShortcutPullableView.h"

@interface TnDashboardViewController : UIViewController <PullableViewDelegate> {
    TnShortcutPullableView *pullDownView;
    
    TnShortcutPullableView *pullUpView;
    UILabel *pullUpLabel;
    
    TnPullableView *pullRightView;
}


@end
