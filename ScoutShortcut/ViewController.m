//
//  ViewController.m
//  ScoutShortcut
//
//  Created by Zhang, Wanming - (p) on 2/17/17.
//  Copyright © 2017 ClaireZhang. All rights reserved.
//

#import "ViewController.h"
#import "TnDashboardShortcutController.h"
//#import "TnDashboardShortcutNavController.h"

@interface ViewController () <TnShortcutAnimationDelegate>
// DashboardShortcut

@property (nonatomic, strong) TnDashboardShortcutController * shortcutController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Map", nil)
                                                    image:nil
                                            selectedImage:nil];
    
    // present shortcut tableview controller
    //self.shortcutController = [[TnDashboardShortcutController alloc] initWithStyle:UITableViewStylePlain];
    self.shortcutController = [[TnDashboardShortcutController alloc] initWithStyle:UITableViewStylePlain];
    self.shortcutController.delegate = self;
    
    [self addGestureRecognizerToDismissShortcut];
    
    UIView * aView = self.shortcutController.view;
    UITapGestureRecognizer *panRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [panRecognizer setNumberOfTapsRequired:1];
    panRecognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [aView addGestureRecognizer:panRecognizer];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIView * aView = self.shortcutController.view;
    aView.frame = CGRectMake(10, bounds.size.height-44-44, bounds.size.width - 20, 44);
    [self.view insertSubview:aView atIndex:0];
    
    [self expandShortcut];
    
}

- (void) addGestureRecognizerToDismissShortcut {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    
    [self.view addGestureRecognizer:recognizer];
    //[self.mapTouchView.view addGestureRecognizer:recognizer];
    //[self.shortcutNavController.view.superview addGestureRecognizer:recognizer];
    //[self.shortcutNavController.view addGestureRecognizer:recognizer];
}


- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if ([self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            
            [self collapseShortcut];
            //[self dismissModalViewControllerAnimated:YES];
            //[self.view.window removeGestureRecognizer:sender];
        }
        
    }
}

- (void) expandShortcut {
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIView * aView = self.shortcutController.view;
    
    [self.view insertSubview:aView atIndex:0];
    float duration = 1;
    float delay = 0;
    float damping = 0;
    float velocity = 0;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    
    [UIView animateWithDuration:duration
                          delay:delay
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:options animations:^{
                            //Animations
                            
                            //aView.frame = CGRectMake(10, bounds.size.height-44-62, bounds.size.width - 20, 44);
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                         aView.frame = CGRectMake(10, bounds.size.height/2, bounds.size.width-20, bounds.size.height/2 - 44);
                         
                     }];
}


- (void) collapseShortcut {
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIView * aView = self.shortcutController.view;
    
    float duration = 1;
    float delay = 0;
    float damping = 0;
    float velocity = 0;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    
    [UIView animateWithDuration:duration
                          delay:delay
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:options animations:^{
                            //Animations
                            //aView.frame = CGRectMake(10, bounds.size.height/2, bounds.size.width-20, bounds.size.height/2 - 44);;
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                         aView.frame = CGRectMake(10, bounds.size.height-44-62, bounds.size.width - 20, 44);
                         
                         
                     }];
}



@end
