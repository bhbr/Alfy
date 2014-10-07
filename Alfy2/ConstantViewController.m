//
//  ConstantViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 24.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ConstantViewController.h"
#import "NumberpadViewController.h"

@interface ConstantViewController ()

@property (nonatomic) NumberpadViewController *numberpadVC;
@property (nonatomic) UIPopoverController *popoverController;

@end 

@implementation ConstantViewController

@synthesize numberpadVC;
@synthesize popoverController;
@synthesize updaterDelegate;


- (instancetype)initWithConstant:(Constant *)initialConstant {
    self = [self initWithNibName:@"ConstantView" bundle:nil];
    self.constant = initialConstant;
    self.term = self.constant;
    
    if (self.constant.frame.size.width == 0) {
        self.constant.frame = self.view.frame;
    } else {
        self.view.frame = self.constant.frame;
    }
    
    self.valueLabel.text = [NSString stringWithFormat:@"%g", self.constant.value];

    [self prepareFormulaWebView];

    self.unhighlightColor = [UIColor colorWithRed:1 green:193./255 blue:189./255 alpha:1];
    self.highlightColor = [UIColor colorWithRed:1 green:160./255 blue:160./255 alpha:1];
    
    [self unhighlight];

    return self;
}



- (instancetype)init {
    Constant *constant = [[Constant alloc] init];
    self = [self initWithConstant:constant];
    return self;
}


- (void)updateSelectedValueTo:(float)newValue {
    
    self.constant.value = newValue;
    self.valueLabel.text = [NSString stringWithFormat:@"%g", newValue];
    [self.updaterDelegate updateValuesOfTermsDependentOn:self.constant];
    [self.updaterDelegate updatePlotsDependentOn:self.constant];
    
}



- (IBAction)tapHandler:(UIGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self openNumberpad2];
    }
}

- (void)openNumberpad2 {
    
    self.numberpadVC = [[NumberpadViewController alloc] initWithNibName:@"Numberpad" bundle:nil];
    self.numberpadVC.delegate = self;
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.numberpadVC];
    self.popoverController.delegate = self;
    self.popoverController.popoverContentSize = self.numberpadVC.view.bounds.size;
    
    [self.popoverController presentPopoverFromRect:self.view.frame inView:self.view.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
