//
//  ComposedTermViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ComposedTermViewController.h"

@interface ComposedTermViewController ()

//@property (nonatomic) IBOutlet UILabel *operatorLabel;
@property (nonatomic) IBOutlet UIWebView *formula;

@end

@implementation ComposedTermViewController

@synthesize composedTerm;
//@synthesize operatorLabel;
@synthesize formula;


- (instancetype)initWithComposedTerm:(ComposedTerm *)initialComposedTerm {
    self = [self initWithNibName:@"ComposedTermView" bundle:nil];
    self.composedTerm = initialComposedTerm;
    self.term = self.composedTerm;
    
    if (self.composedTerm.frame.size.width == 0) {
        self.composedTerm.frame = self.view.frame;
    } else {
        self.view.frame = self.composedTerm.frame;
    }
    
//    self.operatorLabel.text = self.composedTerm.operatorString;
    self.valueLabel.text = [NSString stringWithFormat:@"%g", self.composedTerm.value];
    
    [self prepareFormulaWebView];

    self.unhighlightColor = [UIColor colorWithRed:183./255. green:247./255. blue:180./255 alpha:1];
    self.highlightColor = [UIColor colorWithRed:142./255 green:235./255 blue:180./255 alpha:1];
    
    [self unhighlight];

    return self;
}


- (instancetype)init {
    ComposedTerm *initialComposedTerm = [[ComposedTerm alloc] init];
    self = [self initWithComposedTerm:initialComposedTerm];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    self.composedTerm.frame = self.view.frame;
    [self.arrowDrawer updateArrows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
