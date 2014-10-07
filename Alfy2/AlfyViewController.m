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
#import "ComposedTermViewController.h"
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
@property (nonatomic) NSDictionary *argumentDict;

@property (nonatomic) IBOutlet ArrowView *arrowView;
@property (nonatomic) IBOutlet UILabel *helpLabel;

@property (nonatomic) IBOutlet UIView *selectionView;
@property (nonatomic) MenuViewController *menuVC;

@property (nonatomic) UITapGestureRecognizer *menuDismissGR;


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
@synthesize argumentDict;
@synthesize arrowView;
@synthesize selectionView;
@synthesize helpLabel;
@synthesize menuVC;
@synthesize menuDismissGR;

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
    
    self.argumentDict = @{ @"+"    : @2,
                           @"–"    : @2,
                           @"·"    : @2,
                           @"/"    : @2,
                           @"x^y"    : @2,
                           @"x√y"    : @2,
                           @"sin"  : @1,
                           @"cos"  : @1,
                           @"tan"  : @1,
                           @"plot" : @3,
                           @"graph": @2 };

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    self.dataDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"/Alfy2/"];
    
    self.helpLabel.text = @"";
    
    [self.view sendSubviewToBack:self.arrowView];
    
    self.menuDismissGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOperatorMenu)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newVariableButtonPressed:(id)sender {
    
    VariableViewController *variableVC = [[VariableViewController alloc] init];
    variableVC.delegate = self;
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
    constantVC.delegate = self;
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


//- (IBAction)newGraphButtonPressed {
//    self.selectionMode = [@"graph" mutableCopy];
//    self.currentOperatorString = self.selectionMode;
//    self.helpLabel.text = @"";// @"Choose variable...";
//}
//
//
//- (IBAction)newPlotButtonPressed {
//    self.selectionMode = [@"plot" mutableCopy];
//    self.currentOperatorString = self.selectionMode;
//    self.helpLabel.text = @"";// @"Choose variable…";
//}


- (void)termTouchDown:(id<Term>)term {
    
    if ([self.selectedTerms containsObject:term]) {
        return;
    }
    
    [self.selectedTerms addObject:term];
    [self.touchedTerms addObject:term];
    
    
    
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
    
    
}


- (void)handleSelectedTerms {
    
    
    unsigned long nbArguments = [self.selectedTerms count];
    
    NSString *nibName = [[NSString alloc] init];
    if (nbArguments == 1) {
        nibName = @"SingleOperandMenu";
    } else if (nbArguments == 2) {
        nibName = @"TwoOperandMenu";
    } else {
        nibName = @"MultiOperandMenu";
    }
    
    self.menuVC = [[MenuViewController alloc] initWithNibName:nibName bundle:nil];
    self.menuVC.delegate = self;
    self.menuVC.view.center = [self centerFromParents:self.selectedTerms];
    [self.menuVC.view sizeToFit];
    
    self.menuVC.view.transform = CGAffineTransformMakeScale(.01, .01);
    
    [self.view addSubview:self.menuVC.view];
    
    [UIView animateWithDuration:.2 animations:^{
        self.menuVC.view.transform = CGAffineTransformMakeScale(1, 1);
    }];

    [self.view addGestureRecognizer:self.menuDismissGR];
    
}


- (void)selectTerm:(id<Term>)term {
    [self.selectedTerms addObject:term];
}


- (void)deselectTermFromTimer:(NSTimer *)timer {
    
    if ([self.touchedTerms count]) {
    
        NSDictionary *timerUserInfo = [timer userInfo];
        id <Term> term = [timerUserInfo objectForKey:@"term"];
        [self.selectedTerms removeObject:term];
    }

}


- (void)buttonPressedWithText:(NSString *)buttonText {
    [self.menuVC.view removeFromSuperview];
    self.menuVC = nil;
    
    [self newComposedTermFromSelectionAndOperator:buttonText];
    
    [self.selectedTerms removeAllObjects];
    [self unhighlightAllTerms];
    
}

- (IBAction)dismissOperatorMenu {
    [self.menuVC.view removeFromSuperview];
    self.menuVC = nil;
    [self.selectedTerms removeAllObjects];
    [self unhighlightAllTerms];
    
    [self.view removeGestureRecognizer:self.menuDismissGR];

}


- (IBAction)saveState {
    
    [NSKeyedArchiver archiveRootObject:self.variables toFile:[self.dataDirectory stringByAppendingString:@"variables.plist"]];
    [NSKeyedArchiver archiveRootObject:self.constants toFile:[self.dataDirectory stringByAppendingString:@"constants.plist"]];
    [NSKeyedArchiver archiveRootObject:self.composedTerms toFile:[self.dataDirectory stringByAppendingString:@"composedTerms.plist"]];
    [NSKeyedArchiver archiveRootObject:self.plots toFile:[self.dataDirectory stringByAppendingString:@"plots.plist"]];
    
}


- (IBAction)loadState {
    
    [self clearState];
    
    // load variables
    
    self.variables = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.dataDirectory stringByAppendingString:@"variables.plist"]];
    
    for (Variable *variable in self.variables) {
        VariableViewController *variableVC = [[VariableViewController alloc] initWithVariable:variable];
        variableVC.delegate = self;
        variableVC.updaterDelegate = self;
        variableVC.selectionHandlerDelegate = self;
        variableVC.arrowDrawer = self;
        
        [self.view addSubview:variableVC.view];
        [self addChildViewController:variableVC];
        [self.variableVCs addObject:variableVC];
    }
    
    
    // load constants
    
    self.constants = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.dataDirectory stringByAppendingString:@"constants.plist"]];
    
    for (Constant *constant in self.constants) {
        ConstantViewController *constantVC = [[ConstantViewController alloc] initWithConstant:constant];
        constantVC.delegate = self;
        constantVC.updaterDelegate = self;
        constantVC.selectionHandlerDelegate = self;
        constantVC.arrowDrawer = self;

        [self.view addSubview:constantVC.view];
        [self addChildViewController:constantVC];
        [self.constantVCs addObject:constantVC];
    }
    
    
    
    // load composed terms
    
    self.composedTerms = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.dataDirectory stringByAppendingString:@"composedTerms.plist"]];
    
    for (ComposedTerm *composedTerm in self.composedTerms) {
        ComposedTermViewController *composedTermVC = [[ComposedTermViewController alloc] initWithComposedTerm:composedTerm];
        composedTermVC.delegate = self;
        composedTermVC.arrowDrawer = self;
        composedTermVC.selectionHandlerDelegate = self;

        [self.view addSubview:composedTermVC.view];
        [self addChildViewController:composedTermVC];
        [self.composedTermVCs addObject:composedTermVC];
    }
    
    [self updateArrows];
    
    
    
    // load plots
    
//    [self.plots removeAllObjects];
//    
//    for (PlotViewController *plotVC in self.plotVCs) {
//        [plotVC.view removeFromSuperview];
//        [plotVC removeFromParentViewController];
//    }
//    [self.plotVCs removeAllObjects];
//    
//    self.plots = [NSKeyedUnarchiver unarchiveObjectWithFile:[self.dataDirectory stringByAppendingString:@"plots.plist"]];
//    
//    for (Plot *plot in self.plots) {
//        PlotViewController *plotVC = [[PlotViewController alloc] initWithPlot:plot];
//        [self.view addSubview:plotVC.view];
//        [self addChildViewController:plotVC];
//        [self.plotVCs addObject:plotVC];
//    }
    
}

 
- (IBAction)clearState {
   
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

    [self updateArrows];
    
}


- (id <Term>)termForView:(UIView *)touchedView {
    for (TermViewController *termVC in self.termVCs) {
        if ([termVC.view isEqual:touchedView]) {
            return termVC.term;
        }
    }
    return nil;
}




- (void)highlightTermForView:(UIView *)termView {
    
    id <Term> term = [self termForView:termView];
    TermViewController *termVC = [self viewControllerForTerm:term];
    [termVC highlight];
    
}

- (void)unhighlightTermForView:(UIView *)termView {
    
    id <Term> term = [self termForView:termView];
    TermViewController *termVC = [self viewControllerForTerm:term];
    [termVC unhighlight];
    
}


- (BOOL)isTermView:(UIView *)someView {
    for (TermViewController *termVC in self.termVCs) {
        if ([termVC.view isEqual:someView]) {
            return YES;
        }
    }
    return NO;
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




- (void)newComposedTermFromSelectionAndOperator:(NSString *)operatorString {
    
    ComposedTerm *newComposedTerm = [[ComposedTerm alloc] initWithParents:self.selectedTerms andOperator:operatorString];
    
    ComposedTermViewController *newComposedTermVC = [[ComposedTermViewController alloc] initWithComposedTerm:newComposedTerm];

    newComposedTermVC.delegate = self;
    newComposedTermVC.arrowDrawer = self;
    newComposedTermVC.selectionHandlerDelegate = self;
    
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

//- (void)newPlotFromSelection {
//    
//    Variable *variable = [self.selectedTerms objectAtIndex:0];
//    id <Term> xTerm =[self.selectedTerms objectAtIndex:1];
//    id <Term> yTerm =[self.selectedTerms objectAtIndex:2];
//    [self.selectedTerms removeAllObjects];
//    
//    Plot *newPlot = [[Plot alloc] initWithVariable:variable xTerm:xTerm yTerm:yTerm];
//    PlotViewController *newPlotVC = [[PlotViewController alloc] initWithPlot:newPlot];
//    newPlotVC.delegate = self;
//    
//    [self.plots addObject:newPlot];
//    [self.plotVCs addObject:newPlotVC];
//    [self.view addSubview:newPlotVC.plotView];
//    [newPlotVC.plotView setNeedsDisplay];
//    [self addChildViewController:newPlotVC];
//    [self unhighlightAllTerms];
//    
//}



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







@end
