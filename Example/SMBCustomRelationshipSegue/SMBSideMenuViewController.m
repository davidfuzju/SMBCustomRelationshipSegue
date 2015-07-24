//
//  SMBSideMenuViewController.m
//  SMBRelationShipSegue
//
//  Created by David Fu on 7/24/15.
//  Copyright (c) 2015 David Fu. All rights reserved.
//

#import "SMBSideMenuViewController.h"

@interface SMBSideMenuViewController ()

@end

@implementation SMBSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)relationships {
  return @[@"contentViewController",
           @"leftMenuViewController",
           @"rightMenuViewController"];
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
