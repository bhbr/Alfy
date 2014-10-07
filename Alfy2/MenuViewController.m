//
//  MenuViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 06.10.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowOffset = CGSizeMake(3,3);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = .5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleButtonPress:(UIButton *)sender {
    [self.delegate buttonPressedWithText:sender.titleLabel.text];
}

@end
