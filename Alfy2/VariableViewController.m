//
//  VariableViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "VariableViewController.h"
#import "NumberpadViewController.h"

@interface VariableViewController ()

@property (nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) IBOutlet UIButton *minValueButton;
@property (nonatomic) IBOutlet UIButton *maxValueButton;

@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) NumberpadViewController *numberpadVC;

@property (nonatomic) UIButton *editedBoundButton;
@property (nonatomic) BOOL isPanning;

@property (nonatomic) IBOutlet UITextField *nameField;

@end



@implementation VariableViewController

@synthesize variable;

@synthesize slider;
@synthesize minValueButton;
@synthesize maxValueButton;
@synthesize editedBoundButton;

@synthesize popoverController;
@synthesize numberpadVC;

@synthesize updaterDelegate;
@synthesize isPanning;

@synthesize nameField;



- (instancetype)initWithVariable:(Variable *)initialVariable {
    self = [super initWithNibName:@"VariableView" bundle:nil];
    
    self.variable = initialVariable;
    self.term = self.variable;
    
    if (self.variable.frame.size.width == 0) {
        self.variable.frame = self.view.frame;
    } else {
        self.view.frame = self.variable.frame;
    }

    [self.minValueButton setTitle:[NSString stringWithFormat:@"%g", self.variable.minValue] forState:UIControlStateNormal];
    [self.maxValueButton setTitle:[NSString stringWithFormat:@"%g", self.variable.maxValue] forState:UIControlStateNormal];
    self.valueLabel.text = [NSString stringWithFormat:@"%g", self.variable.value];
    self.slider.minimumValue = self.variable.minValue;
    self.slider.maximumValue = self.variable.maxValue;
    self.slider.value = self.variable.value;
    self.isPanning = NO;
    
    [self prepareFormulaWebView];
    
    self.unhighlightColor = [UIColor colorWithRed:171./255. green:218./255. blue:1 alpha:1];
    self.highlightColor = [UIColor colorWithRed:120./255 green:195./255 blue:1 alpha:1];
    
    self.nameField.text = self.variable.name;
    
    [self unhighlight];

    return self;
}


- (instancetype)init {
    Variable *initialVariable = [[Variable alloc] init];
    self = [self initWithVariable:initialVariable];
    return self;
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


- (void)promptForVariableName {
    if ([self.nameField.text isEqualToString:@""]) {
        [self.nameField becomeFirstResponder];
    }
}

- (IBAction)sliderMoved:(UISlider *)sender {

    [self.valueLabel setText:[NSString stringWithFormat:@"%g", sender.value]];
    self.variable.value = sender.value;
    [self.updaterDelegate updateValuesOfTermsDependentOn:self.variable];
    [self.updaterDelegate updatePlotsDependentOn:self.variable];

}



- (IBAction)openNumberpad:(UIButton *)sender {
    
    self.editedBoundButton = sender;
    self.numberpadVC = [[NumberpadViewController alloc] initWithNibName:@"Numberpad" bundle:nil];
    self.numberpadVC.delegate = self;
    
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.numberpadVC];
    self.popoverController.delegate = self;
    self.popoverController.popoverContentSize = self.numberpadVC.view.bounds.size;

    [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


- (void)updateSelectedValueTo:(float)newValue {
    
    [self.editedBoundButton setTitle:[NSString stringWithFormat:@"%g", newValue] forState:UIControlStateNormal];
    [self.editedBoundButton sizeToFit];
    
    if ([self.editedBoundButton isEqual:self.minValueButton]) {
        self.variable.minValue = newValue;
        self.slider.minimumValue = newValue;
    } else if ([self.editedBoundButton isEqual:self.maxValueButton]) {
        self.variable.maxValue = newValue;
        self.slider.maximumValue = newValue;
    }
    
    [self.updaterDelegate updatePlotsDependentOn:self.variable];
    
}



- (IBAction)variableNameFieldTouched:(UITextField *)sender {
    sender.text = @"";
}

- (IBAction)dismissKeyboard:(UITextField *)sender {
    
    if ([sender.text length] == 1) {
        [sender resignFirstResponder];
        self.variable.name = [sender.text mutableCopy];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}





// this method prevents touches on the slider from triggering dragging
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return !CGRectContainsPoint(self.slider.frame, [touch locationInView:gestureRecognizer.view]);
}

@end
