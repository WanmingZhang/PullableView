//
//  TnDashboardViewController.m
//  ScoutShortcut
//
//  Created by Zhang, Wanming - (p) on 2/18/17.
//  Copyright © 2017 ClaireZhang. All rights reserved.
//

#import "TnDashboardViewController.h"

@interface TnDashboardViewController ()

@end

@implementation TnDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Map", nil)
                                                    image:nil
                                            selectedImage:nil];
    
    CGFloat xOffset = 20;

    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    pullUpView = [[TnShortcutPullableView alloc] initWithFrame:CGRectMake(xOffset, 0, width-2*xOffset, height)];
    
    pullUpView.openedCenter = CGPointMake(width/2, self.view.frame.size.height);
    pullUpView.closedCenter = CGPointMake(width/2, self.view.frame.size.height + 200);
    pullUpView.center = pullUpView.closedCenter;
    pullUpView.handleView.frame = CGRectMake(0, 0, width-2*xOffset, 40);
    pullUpView.delegate = self;
    
    [self.view addSubview:pullUpView];
    
    pullUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, width-2*xOffset, 20)];
    pullUpLabel.textAlignment = NSTextAlignmentCenter;
    pullUpLabel.backgroundColor = [UIColor clearColor];
    pullUpLabel.textColor = [UIColor lightGrayColor];
    pullUpLabel.text = @"SHORTCUTS";
    
    [pullUpView addSubview:pullUpLabel];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)pullableView:(TnShortcutPullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        pullUpLabel.text = @"Now I'm open!";
    } else {
        pullUpLabel.text = @"Now I'm closed, pull me up again!";
    }
}


@end
