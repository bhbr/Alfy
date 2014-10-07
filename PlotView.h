//
//  GraphView.h
//  Alfy
//
//  Created by Ben Hambrecht on 31.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plot.h"

#define GRAPH_VIEW_ALPHA .7
#define GRAPH_RESOLUTION 500
#define TICK_WIDTH .1
#define AXES_ARROW_LENGTH 10


@interface PlotView : UIView

@property (nonatomic) CGRect previousFrame;

@property (nonatomic) float xmin;
@property (nonatomic) float xmax;
@property (nonatomic) float ymin;
@property (nonatomic) float ymax;

@property (nonatomic) id <PointConverter> delegate;


@end

