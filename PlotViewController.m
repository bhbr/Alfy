//
//  PlotViewController.m
//  Alfy2
//
//  Created by Ben Hambrecht on 31.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "PlotViewController.h"

@interface PlotViewController ()

@end

@implementation PlotViewController

@synthesize plot = _plot;
@synthesize plotView = _plotView;
@synthesize delegate;


- (instancetype)initWithPlot:(Plot *)initialPlot {
 
    self = [self initWithNibName:@"PlotView" bundle:nil];
    self.view.center = CGPointMake(100, 100);
    _plot = initialPlot;
    self.plot.frame = self.plotView.frame;
    
    _plotView.xmin = self.plot.xmin;
    _plotView.xmax = self.plot.xmax;
    _plotView.ymin = self.plot.ymin;
    _plotView.ymax = self.plot.ymax;
    
    self.plotView.delegate = self.plot;
    
    return self;
}

- (instancetype)init {
    Plot *initialPlot = [[Plot alloc] init];
    self = [self initWithPlot:initialPlot];
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


- (IBAction)plotSingleTapped {
//    [self.delegate highlightTerm:self.plot.variable];
//    [self.delegate highlightTerm:self.plot.xTerm];
//    [self.delegate highlightTerm:self.plot.yTerm];
}

- (IBAction)dragView:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.plotView.previousFrame = self.plotView.frame;
    } else {
        CGPoint translation = [sender translationInView:self.view]; // relative to inner coordinate system
        //self.view.center = CGPointMake(self.view.center.x + newCenter.x - previousCenter.x,
        //                               self.view.center.y + newCenter.y - previousCenter.y);
        [self.plotView setFrame:CGRectMake(self.plotView.previousFrame.origin.x + translation.x,
                                           self.plotView.previousFrame.origin.y + translation.y,
                                           self.plotView.previousFrame.size.width,
                                           self.plotView.previousFrame.size.height)];
        
       //this is relative to the outer coordinate system
        
        // update the model
        self.plot.frame = self.plotView.frame;
        
    }
    
}


- (IBAction)resizePlotView:(UIPanGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.plotView.previousFrame = self.plotView.frame;
    } else {
    
        CGPoint translation = [sender translationInView:self.plotView];
        
        [self.plotView setFrame:CGRectMake(self.plotView.previousFrame.origin.x,
                                           self.plotView.previousFrame.origin.y + translation.y,
                                           self.plotView.previousFrame.size.width + translation.x,
                                           self.plotView.previousFrame.size.height - translation.y)];
    
        self.plot.frame = self.plotView.frame;
        [self.plotView setNeedsDisplay];
    }
    
}



- (IBAction)updateBounds:(id)sender {

    [self.plot updateBounds];

    self.plotView.xmin = self.plot.xmin;
    self.plotView.xmax = self.plot.xmax;
    self.plotView.ymin = self.plot.ymin;
    self.plotView.ymax = self.plot.ymax;

    [self.plotView setNeedsDisplay];
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
