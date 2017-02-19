//
//  TnShortcutPullableView.m
//  ScoutShortcut
//
//  Created by Zhang, Wanming - (p) on 2/18/17.
//  Copyright © 2017 ClaireZhang. All rights reserved.
//

#import "TnShortcutPullableView.h"

@interface TnShortcutPullableView()

@property (strong,nonatomic) NSArray * content;

@end

@implementation TnShortcutPullableView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.handleView.backgroundColor = [UIColor colorWithRed:243 green:243 blue:243 alpha:1.0];
        [self configureTableview];
    }
    return self;
}

 -(void)configureTableview
{
    CGFloat handleHeight = self.handleView.bounds.size.height;
    CGRect bounds = CGRectMake(0, handleHeight, self.bounds.size.width, self.bounds.size.height-handleHeight);
    self.tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
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


@end
