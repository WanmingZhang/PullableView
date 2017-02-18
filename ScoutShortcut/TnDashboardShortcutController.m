//
//  TnDashboardShortcutController.m
//  TelenavNavigator
//
//  Created by Zhang, Wanming - (p) on 2/16/17.
//  Copyright © 2017 Telenav, Inc. All rights reserved.
//

#import "TnDashboardShortcutController.h"

@interface TnDashboardShortcutController () <UIGestureRecognizerDelegate>

// Gesture recognizers
@property (nonatomic, strong) UIPanGestureRecognizer * drag;

@end



@implementation TnDashboardShortcutController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
     self.navigationItem.title = @"SHORTCUTS";
    self.drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:self.drag];
    [self.drag setDelegate:self];
    [self.drag setCancelsTouchesInView:NO];
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
//    CGPoint translation = [recognizer translationInView:self.view];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
//                                         recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    [self.delegate expandShortcut];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

#pragma  mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"ShortcutCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Share ETA";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    //(self.tableView.frame.size.height - 44) / 3;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
