//
//  TalksTableViewController.m
//  NSConfArg2015Handoff
//
//  Created by Martín Blech on 2/4/15.
//  Copyright (c) 2015 Martin Blech. All rights reserved.
//

#import "TalksTableViewController.h"
#import "Talk.h"

@interface TalksTableViewController ()

@property (nonatomic, strong) NSArray *talks;

@end

@implementation TalksTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"TalksSelected"];
    self.talks = [Talk defaultTalks];
    [self setupUserActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark - Handoff

- (void)setupUserActivity
{
    if ([self respondsToSelector:@selector(setUserActivity:)]) {
        NSString *activityType = @"com.martinblech.NSConfArg2015Handoff.browsing-talks";
        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:activityType];
        userActivity.title = @"Browsing NSConfArg 2015 Location";
        userActivity.webpageURL = [NSURL URLWithString:@"http://nsconfarg.com/#programa"];
        self.userActivity = userActivity;
    }
}

- (void)updateUserActivityState:(NSUserActivity *)activity
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.talks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdentifier = @"talkCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Talk *talk = self.talks[indexPath.row];
    
    cell.textLabel.text = talk.title;
    cell.detailTextLabel.text = talk.speakerName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
