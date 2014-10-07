//
//  NumberpadViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "NumberpadViewController.h"

@interface NumberpadViewController ()

@property (nonatomic) NSMutableString *enteredNumberString;

@end



@implementation NumberpadViewController

@synthesize enteredNumberString;
@synthesize delegate;



- (IBAction)nonZeroDigitEntered:(UIButton *)sender {

    [self.enteredNumberString appendString:sender.currentTitle];
    [self.delegate updateSelectedValueTo:[self.enteredNumberString floatValue]];

}

- (IBAction)signButtonPressed:(id)sender {
    
    if ([self.enteredNumberString hasPrefix:@"-"]) {
        [self.enteredNumberString replaceOccurrencesOfString:@"-" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [self.enteredNumberString length])];
    } else {
        [self.enteredNumberString insertString:@"-" atIndex:0];
    }
    
    [self.delegate updateSelectedValueTo:[self.enteredNumberString floatValue]];
    
}

- (IBAction)zeroEntered {
    
    if (![self.enteredNumberString isEqualToString:@"0"]) {
        [self.enteredNumberString appendString:@"0"];
    }
    [self.delegate updateSelectedValueTo:[self.enteredNumberString floatValue]];
    
}



- (IBAction)decimalButtonPressed:(id)sender {
    
    if ([self.enteredNumberString rangeOfString:@"."].location == NSNotFound) {
        [self.enteredNumberString appendString:@"."];
    }
    [self.delegate updateSelectedValueTo:[self.enteredNumberString floatValue]];
    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enteredNumberString = [[NSMutableString alloc] initWithString:@""];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
