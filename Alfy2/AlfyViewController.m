//
//  AlfyViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "AlfyViewController.h"
#import "ConstantViewController.h"
#import "VariableViewController.h"
//#import "ComposedTermViewController.h"
#import "PlotViewController.h"
#import "MenuViewController.h"


#define CHILD_TERM_VERTICAL_POSITION_OFFSET 150

@interface AlfyViewController ()

@property (nonatomic) NSMutableArray *variables;
@property (nonatomic) NSMutableArray *variableVCs;
@property (nonatomic) NSMutableArray *constants;
@property (nonatomic) NSMutableArray *constantVCs;
@property (nonatomic) NSMutableArray *composedTerms;
@property (nonatomic) NSMutableArray *composedTermVCs;
@property (nonatomic) NSMutableArray *plots;
@property (nonatomic) NSMutableArray *plotVCs;
@property (nonatomic) NSMutableArray *terms;
@property (nonatomic) NSMutableArray *termVCs;
@property (nonatomic) NSString *dataDirectory;
@property (nonatomic) NSMutableArray *selectedTerms;
@property (nonatomic) NSMutableArray *touchedTerms;

@property (nonatomic) IBOutlet ArrowView *arrowView;
@property (nonatomic) MenuViewController *menuVC;
@property (nonatomic) UIPopoverController *popoverController;

@property (nonatomic) IBOutlet UILabel *debugLabel;


@end

@implementation AlfyViewController

@synthesize variables;
@synthesize variableVCs;
@synthesize constants;
@synthesize constantVCs;
@synthesize composedTerms;
@synthesize composedTermVCs;
@synthesize plots;
@synthesize plotVCs;
@synthesize dataDirectory;
@synthesize selectedTerms;
@synthesize touchedTerms;
@synthesize arrowView;
@synthesize menuVC;
@synthesize popoverController;
@synthesize debugDescription;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.variables = [[NSMutableArray alloc] init];
    self.variableVCs = [[NSMutableArray alloc] init];
    self.constants = [[NSMutableArray alloc] init];
    self.constantVCs = [[NSMutableArray alloc] init];
    self.composedTerms = [[NSMutableArray alloc] init];
    self.composedTermVCs = [[NSMutableArray alloc] init];
    self.terms = [[NSMutableArray alloc] init];
    self.termVCs = [[NSMutableArray alloc] init];
    self.plots = [[NSMutableArray alloc] init];
    self.plotVCs = [[NSMutableArray alloc] init];
    
    self.selectedTerms = [[NSMutableArray alloc] init];
    self.touchedTerms = [[NSMutableArray alloc] init];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    self.dataDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"/Alfy2/"];
    
    [self.view sendSubviewToBack:self.arrowView];
    
    self.debugLabel.numberOfLines = 0;
    self.debugLabel.text = @"";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newVariableButtonPressed:(id)sender {
    
    VariableViewController *variableVC = [[VariableViewController alloc] init];

    variableVC.updaterDelegate = self;
    variableVC.selectionHandlerDelegate = self;
    variableVC.arrowDrawer = self;
    
    [self.variables addObject:variableVC.variable];
    [self.terms addObject:variableVC.variable];
    
    variableVC.view.center = CGPointMake(self.view.center.x, 150);
    variableVC.variable.frame = variableVC.view.frame;
    [self.view addSubview:variableVC.view];
    
    [self addChildViewController:variableVC];
    [self.variableVCs addObject:variableVC];
    [self.termVCs addObject:variableVC];
    
    [variableVC promptForVariableName];
    
}

- (IBAction)newConstantButtonPressed:(id)sender {
    
    ConstantViewController *constantVC = [[ConstantViewController alloc] init];

    constantVC.updaterDelegate = self;
    constantVC.selectionHandlerDelegate = self;
    constantVC.arrowDrawer = self;
    
    [self.constants addObject:constantVC.constant];
    [self.terms addObject:constantVC.constant];
    
    constantVC.view.center = CGPointMake(self.view.center.x, 150);
    constantVC.constant.frame = constantVC.view.frame;
    [self.view addSubview:constantVC.view];
    
    [self addChildViewController:constantVC];
    [self.constantVCs addObject:constantVC];
    [self.termVCs addObject:constantVC];
    
    [constantVC openNumberpad2];
    
}


- (IBAction)newTermButtonPressed {
    
//    ComposedTerm *newComposedTerm = [[ComposedTerm alloc] init];
//    
    ComposedTermViewController *newComposedTermVC = [[ComposedTermViewController alloc] initWithComposedTerm:nil];//]newComposedTerm];
//    
    newComposedTermVC.arrowDrawer = self;
    newComposedTermVC.selectionHandlerDelegate = self;
    newComposedTermVC.variableFetcher = self;
//    
//    [self.composedTerms addObject:newComposedTermVC.composedTerm];
//    [self.terms addObject:newComposedTermVC.composedTerm];
    
    newComposedTermVC.view.center = CGPointMake(self.view.center.x, self.view.center.y-200);
//    newComposedTerm.frame = newComposedTermVC.view.frame;
    [self.view addSubview:newComposedTermVC.view];
    
    [self addChildViewController:newComposedTermVC];
    [self.composedTermVCs addObject:newComposedTermVC];
    [self.termVCs addObject:newComposedTermVC];
    
    newComposedTermVC.arrowDrawer = self;
    //newComposedTermVC.parser = self;
    newComposedTermVC.registrator = self;
    
   [newComposedTermVC startFormulaEditing];
    
}

//

- (void)registerComposedTermForViewController:(ComposedTermViewController *)composedTermVC {
    
    composedTermVC.composedTerm.frame = composedTermVC.view.frame;
    [self.composedTerms addObject:composedTermVC.composedTerm];
    [self.terms addObject:composedTermVC.composedTerm];
}



- (void)updateDebugLabel {
  //  NSString *text1 = [NSString stringWithFormat:@"%i terms touched\r", [self.touchedTerms count]];
  //  NSString *text2 = [NSString stringWithFormat:@"%i terms selected", [self.selectedTerms count]];
  //  self.debugLabel.text = [text1 stringByAppendingString:text2];
}


- (void)termTouchDown:(id<Term>)term {
    
    if ([self.selectedTerms containsObject:term]) {
        return;
    }
    
    [self.selectedTerms addObject:term];
    [self.touchedTerms addObject:term];
    
    [self updateDebugLabel];
    
}

-(void)termTouchUp:(id<Term>)term {

    if ([self.touchedTerms count] > 1) {
        
        NSArray *argumentObject = [[NSArray alloc] initWithObjects:term, nil];
        NSArray *argumentKey = [[NSArray alloc] initWithObjects:@"term", nil];
        NSDictionary *timerUserInfo = [[NSDictionary alloc] initWithObjects:argumentObject forKeys:argumentKey];
        
        [NSTimer scheduledTimerWithTimeInterval:.5
                                              target:self
                                       selector:@selector(deselectTermFromTimer:)
                                            userInfo:timerUserInfo
                                             repeats:NO];
    } else {
        [self handleSelectedTerms];
        [self.touchedTerms removeAllObjects];
    }
    
    [self.touchedTerms removeObject:term];
    
    [self updateDebugLabel];
    
}


- (void)handleSelectedTerms {
    
    unsigned long nbArguments = [self.selectedTerms count];
    
    NSString *nibName = [[NSString alloc] init];
    if (nbArguments == 1) {
        nibName = @"SingleOperandMenu";
    } else if (nbArguments == 2) {
        if ([[self.selectedTerms firstObject] isAVariable] || [[self.selectedTerms lastObject] isAVariable]) {
            nibName = @"TwoOperandMenuWithGraphButton";
        } else {
            nibName = @"TwoOperandMenu";
        }
    } else {
        nibName = @"MultiOperandMenu";
    }

    [self updateDebugLabel];

    self.menuVC = [[MenuViewController alloc] initWithNibName:nibName bundle:nil];
    self.menuVC.delegate = self;
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:self.menuVC];
//    pop.delegate = self;
    self.popoverController = pop;
    self.popoverController.delegate = self;

    CGRect presenterRect = CGRectZero;
    presenterRect.origin = [self centerFromParents:self.selectedTerms];
    presenterRect.size = CGSizeMake(1,1);
    
    [self.popoverController setPopoverContentSize:self.menuVC.view.frame.size];
    [self.popoverController presentPopoverFromRect:presenterRect inView:self.view permittedArrowDirections:0 animated:YES];
    
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverController = nil;
    [self.selectedTerms removeAllObjects];
    [self updateDebugLabel];
}

- (void)selectTerm:(id<Term>)term {
    [self.selectedTerms addObject:term];
    [self updateDebugLabel];
}


- (void)deselectTermFromTimer:(NSTimer *)timer {
    
    if ([self.touchedTerms count]) {
    
        NSDictionary *timerUserInfo = [timer userInfo];
        id <Term> term = [timerUserInfo objectForKey:@"term"];
        [self.selectedTerms removeObject:term];
        [self updateDebugLabel];

    }

}


- (void)buttonPressedWithText:(NSString *)buttonText {
    
    if ([buttonText isEqualToString:@"Graph"]) {
        [self newGraphFromSelection];
    } else if ([buttonText isEqualToString:@"Plot"]) {
        [self newPlotFromSelection];
    } else if ([buttonText isEqualToString:@"x^y"]) {
        [self newComposedTermFromSelectionAndOperator:@"^"];
    } else if ([buttonText isEqualToString:@"y√x"]) {
        [self newComposedTermFromSelectionAndOperator:@"√"];
    } else {
        [self newComposedTermFromSelectionAndOperator:buttonText];
    }
    
    [self unhighlightAllTerms];
    
    [self.popoverController dismissPopoverAnimated:YES];
    
    self.popoverController = nil;
    [self.selectedTerms removeAllObjects];
    [self updateDebugLabel];

    
}


- (IBAction)saveState {
    
    NSArray *termsAndPlots = [self.terms arrayByAddingObjectsFromArray:self.plots];
    
    [NSKeyedArchiver archiveRootObject:termsAndPlots toFile:[self.dataDirectory stringByAppendingString:@"termsAndPlots.plist"]];
}


- (IBAction)loadState {
    
    [self clearState];
    
    NSArray *termsAndPlots = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.dataDirectory stringByAppendingString:@"termsAndPlots.plist"]];
    
    for (id element in termsAndPlots) {
        if ([element conformsToProtocol:@protocol(Term)]) {
            [self.terms addObject:element];
        } else if ([element isMemberOfClass:[Plot class]]) {
            [self.plots addObject:(Plot *)element];
        }
    }
    

    for (id <Term> term in self.terms) {
     
        if ([term isAVariable]) {
            [self.variables addObject:(Variable *)term];
            VariableViewController *variableVC = [[VariableViewController alloc] initWithVariable:(Variable *)term];
            variableVC.arrowDrawer = self;
            variableVC.updaterDelegate = self;
            variableVC.selectionHandlerDelegate = self;
            [self.view addSubview:variableVC.view];
            [self addChildViewController:variableVC];
            [self.variableVCs addObject:variableVC];
        } else if ([term isAConstant]) {
            [self.constants addObject:(Constant *)term];
            ConstantViewController *constantVC = [[ConstantViewController alloc] initWithConstant:(Constant *)term];
            constantVC.arrowDrawer = self;
            constantVC.updaterDelegate = self;
            constantVC.selectionHandlerDelegate = self;
            [self.view addSubview:constantVC.view];
            [self addChildViewController:constantVC];
            [self.constantVCs addObject:constantVC];
        } else if ([term isComposed]) {
            [self.composedTerms addObject:(ComposedTerm *)term];
            ComposedTermViewController *composedTermVC = [[ComposedTermViewController alloc] initWithComposedTerm:(ComposedTerm *)term];
            composedTermVC.selectionHandlerDelegate = self;
            composedTermVC.arrowDrawer = self;
            [self.view addSubview:composedTermVC.view];
            [self addChildViewController:composedTermVC];
            [self.composedTermVCs addObject:composedTermVC];
        }
        
    }

    [self updateArrows];
    
    
    for (Plot *plot in self.plots) {
        PlotViewController *plotVC = [[PlotViewController alloc] initWithPlot:plot];
        [self.view addSubview:plotVC.view];
        [self addChildViewController:plotVC];
        [self.plotVCs addObject:plotVC];
    }
    
}

 
- (IBAction)clearState {
   
    
    [self.touchedTerms removeAllObjects];
    [self.selectedTerms removeAllObjects];
    
    [self updateDebugLabel];
    
    [self.terms removeAllObjects];
    
    [self.variables removeAllObjects];
    
    for (VariableViewController *variableVC in self.variableVCs) {
        [variableVC.view removeFromSuperview];
        [variableVC removeFromParentViewController];
    }
    [self.variableVCs removeAllObjects];
    
    
    [self.constants removeAllObjects];
    
    for (ConstantViewController *constantVC in self.constantVCs) {
        [constantVC.view removeFromSuperview];
        [constantVC removeFromParentViewController];
    }
    [self.constantVCs removeAllObjects];

    
    [self.composedTerms removeAllObjects];
    
    for (ComposedTermViewController *composedTermVC in self.composedTermVCs) {
        [composedTermVC.view removeFromSuperview];
        [composedTermVC removeFromParentViewController];
    }
    [self.composedTermVCs removeAllObjects];
    
    [self.plots removeAllObjects];
    
    for (PlotViewController *plotVC in self.plotVCs) {
        [plotVC.view removeFromSuperview];
        [plotVC removeFromParentViewController];
    }
    [self.plotVCs removeAllObjects];
    
    [self updateArrows];
    
}





- (TermViewController *)viewControllerForTerm:(id <Term>)someTerm {
    for (TermViewController *possibleTermVC in self.termVCs) {
        if (possibleTermVC.term == someTerm) {
            return possibleTermVC;
        }
    }
    return nil;
}



- (void)unhighlightAllTerms {
    for (TermViewController *termVC in self.termVCs) {
        [termVC unhighlight];
    }
}

- (void)highlightTerm:(id <Term>)term {
    [[self viewControllerForTerm:term] highlight];
}


- (void)unhighlightTerm:(id <Term>)term {
    [[self viewControllerForTerm:term] unhighlight];
}



- (void)newComposedTermFromSelectionAndOperator:(NSString *)operatorString {
    
    ComposedTerm *newComposedTerm = [[ComposedTerm alloc] initWithParents:self.selectedTerms andOperator:operatorString];
    
    newComposedTerm.variableFetcher = self;
    
    ComposedTermViewController *newComposedTermVC = [[ComposedTermViewController alloc] initWithComposedTerm:newComposedTerm];

    newComposedTermVC.arrowDrawer = self;
    newComposedTermVC.selectionHandlerDelegate = self;
    newComposedTermVC.variableFetcher = self;
    
    [self.composedTerms addObject:newComposedTermVC.composedTerm];
    [self.terms addObject:newComposedTermVC.composedTerm];
    
    newComposedTermVC.view.center = [self centerFromParents:newComposedTerm.parents];
    newComposedTerm.frame = newComposedTermVC.view.frame;
    [self.view addSubview:newComposedTermVC.view];
    
    [self addChildViewController:newComposedTermVC];
    [self.composedTermVCs addObject:newComposedTermVC];
    [self.termVCs addObject:newComposedTermVC];
    
    newComposedTermVC.arrowDrawer = self;
    [self updateArrows];

}


- (CGPoint)centerFromParents:(NSArray *)parents {

    CGFloat frameCenterX = 0;
    CGFloat frameCenterY = 0;
    
    for (id <Term> parent in parents) {
        frameCenterX += parent.frame.origin.x + parent.frame.size.width/2;
        CGFloat newCenterY = parent.frame.origin.y + parent.frame.size.height/2;
        if (newCenterY > frameCenterY) {
            frameCenterY = newCenterY;
        }
    }
    
    frameCenterX /= [parents count];
    frameCenterY += CHILD_TERM_VERTICAL_POSITION_OFFSET;
    
    return CGPointMake(frameCenterX, frameCenterY);
    
}

- (void)newPlotFromSelection {
    
    Variable *variable = [self.selectedTerms objectAtIndex:0];
    id <Term> xTerm =[self.selectedTerms objectAtIndex:1];
    id <Term> yTerm =[self.selectedTerms objectAtIndex:2];
    [self.selectedTerms removeAllObjects];
    
    [self updateDebugLabel];

    
    Plot *newPlot = [[Plot alloc] initWithVariable:variable xTerm:xTerm yTerm:yTerm];
    PlotViewController *newPlotVC = [[PlotViewController alloc] initWithPlot:newPlot];
    newPlotVC.delegate = self;
    
    [self.plots addObject:newPlot];
    [self.plotVCs addObject:newPlotVC];
    [self.view addSubview:newPlotVC.plotView];
    [newPlotVC.plotView setNeedsDisplay];
    [self addChildViewController:newPlotVC];
    [self unhighlightAllTerms];
    
}



- (void)updateArrows {
    
    [self.arrowView.lines removeAllObjects];
    
    for (ComposedTerm *composedTerm in self.composedTerms) {
        
        NSArray *parentTerms = composedTerm.parents;
        NSMutableArray *parentFrames = [[NSMutableArray alloc] init];
        
        for (id <Term> parent in parentTerms) {
            [parentFrames addObject:[NSValue valueWithCGRect:parent.frame]];
        }
        
        [self.arrowView addLinesFromFrames:parentFrames toFrame:composedTerm.frame];
        
    }
    
    [self.arrowView setNeedsDisplay];
}

- (void)updateValuesOfTermsDependentOn:(id<Term>)term {
    
    for (ComposedTermViewController *possibleChildTermVC in self.composedTermVCs) {
        if ([possibleChildTermVC.term dependsOnTerm:term]) {
            possibleChildTermVC.valueLabel.text = [NSString stringWithFormat:@"%g", [possibleChildTermVC.term value]];
        }
    }
    
}


- (void)updatePlotsDependentOn:(id<Term>)term {
    for (PlotViewController *possibleChildPlotVC in self.plotVCs) {
        if ([possibleChildPlotVC.plot dependsOnTerm:term]) {
            [possibleChildPlotVC.plotView setNeedsDisplay];
        }
    }
}


- (void)newGraphFromSelection {
    
    id <Term> firstTerm = [self.selectedTerms firstObject];
    id <Term> secondTerm = [self.selectedTerms lastObject];
    
    if ([firstTerm isAVariable]) {
        self.selectedTerms = [@[firstTerm, firstTerm, secondTerm] mutableCopy];
    } else if ([secondTerm isAVariable]) {
        self.selectedTerms = [@[secondTerm, secondTerm, firstTerm] mutableCopy];
    }
    [self updateDebugLabel];


    [self newPlotFromSelection];

}


- (Variable *)variableWithName:(NSString *)name {
    
    for (Variable *variable in self.variables) {
        if ([variable.name isEqualToString:name]) {
            return variable;
        }
    }
    
    return nil;
    
}



@end
