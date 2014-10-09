//
//  PlotViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 31.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plot.h"
#import "PlotView.h"
#import "AlfyViewController.h"

@interface PlotViewController : UIViewController


@property (nonatomic) Plot *plot;
@property (nonatomic) IBOutlet PlotView *plotView;
@property (nonatomic) id <TermHighlighter> delegate;

- (instancetype)initWithPlot:(Plot *)initialPlot;

@end
