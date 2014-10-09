//
//  TermViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "TermViewController.h"

@interface TermViewController () //<HoldGestureRecognizerDelegate>

@property (nonatomic) CGPoint previousCenter;
@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) BOOL highlighted;

@end



@implementation TermViewController

@synthesize previousCenter;
@synthesize valueLabel;
@synthesize term;
@synthesize popoverController;
@synthesize arrowDrawer;
@synthesize formulaWebView;
@synthesize highlighted;
@synthesize highlightColor;
@synthesize unhighlightColor;
@synthesize selectionHandlerDelegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    self.view.layer.masksToBounds = NO;
    self.view.layer.shadowOffset = CGSizeMake(3,3);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = .5;
    
    self.highlightColor = [[UIColor alloc] init];
    self.unhighlightColor = [[UIColor alloc] init];

    return self;
}


- (void)prepareFormulaWebView {
    
    self.formulaWebView.opaque = NO;
    
    [self.formulaWebView loadHTMLString:[self formulaAsHTML] baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.formulaWebView.scrollView sizeToFit];
    [self.formulaWebView sizeToFit];
    self.formulaWebView.center = CGPointMake(self.formulaWebView.center.x, self.view.bounds.size.height*.5);
    self.formulaWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.formulaWebView.backgroundColor = self.unhighlightColor;
    [self.view sizeThatFits:self.formulaWebView.frame.size];
}


- (void)highlight {
    if (!self.highlighted) {
        
        self.highlighted = YES;
        self.view.backgroundColor = self.highlightColor;
        self.formulaWebView.backgroundColor = self.highlightColor;
        [self.view setNeedsDisplay];
    }
}

- (void)unhighlight {
    if (self.highlighted) {
        
        self.highlighted = NO;
        self.view.backgroundColor = self.unhighlightColor;
        self.formulaWebView.backgroundColor = self.unhighlightColor;
        [self.view setNeedsDisplay];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.formulaWebView.scrollView sizeToFit];
    [self.formulaWebView sizeToFit];
    
}



- (IBAction)touchHandler:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self highlight];
        [self.selectionHandlerDelegate termTouchDown:self.term];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self unhighlight];
        [self.selectionHandlerDelegate termTouchUp:self.term];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)dragView:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.previousCenter = [sender locationInView:self.view]; // relative to inner coordinate system
    } else {
        CGPoint newCenter = [sender locationInView:self.view]; // relative to inner coordinate system
        self.view.center = CGPointMake(self.view.center.x + newCenter.x - previousCenter.x,
                                       self.view.center.y + newCenter.y - previousCenter.y);
        //this is relative to the outer coordinate system
        
        // update the model
        self.term.frame = self.view.frame;
        
        // update the arrows
        [self.arrowDrawer updateArrows];
    }
    
}



- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self unhighlight];
}



- (NSString *)formulaAsHTML {
    NSMutableString *returnString = [@"<html><style>p {min-height: 72px; display: table-cell; vertical-align: middle}</style><body align='left'><p id='formula'>&nbsp;<math display='inline'><mstyle fontfamily='Helvetica'>" mutableCopy];
    [returnString appendString:[self.term formula]];
    [returnString appendString:@"</mstyle></math></p></body></html>"];
    return [returnString copy];
}

// <script>document.height = document.body.offsetHeight;</script>


@end
