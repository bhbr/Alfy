//
//  PlotView.m
//  Alfy
//
//  Created by Ben Hambrecht on 31.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "PlotView.h"

@interface PlotView ()

@property (nonatomic) BOOL justEncounteredNanOrInf;

@end


@implementation PlotView

@synthesize previousFrame;

@synthesize xmin;
@synthesize xmax;
@synthesize ymin;
@synthesize ymax;

@synthesize justEncounteredNanOrInf;
@synthesize delegate;








- (BOOL)pointContainsNoNansNoInfs:(CGPoint)point {
    if (isnan(point.x) | isinf(point.x) | isnan(point.y) | isinf(point.y)) {
        return NO;
    } else {
        return YES;
    }
}


- (void)drawCircleAtPoint:(CGPoint)center {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    
    CGContextSetLineWidth(ctx,5);
    CGContextSetRGBStrokeColor(ctx,0,0,0,1); // black
    if ([self pointContainsNoNansNoInfs:center]) {
        CGContextAddArc(ctx,center.x,center.y,5,0.0,M_PI*2,YES);
        CGContextFillPath(ctx);
    }
}


- (void)drawGraph {
    
    UIBezierPath *graph = [[UIBezierPath alloc] init];
    graph.lineWidth = 2;
    
    NSArray *cgPointsForGraph = [self.delegate cgPointsForPlot];
    for (int i=0;i<[cgPointsForGraph count];i++) {
        CGPoint point = [[cgPointsForGraph objectAtIndex:i] CGPointValue];
        if (graph.empty) {
            [graph moveToPoint:point];
            self.justEncounteredNanOrInf = NO;
        } else {
            if ([self pointContainsNoNansNoInfs:point] && !self.justEncounteredNanOrInf) {
                [graph addLineToPoint:point];
                self.justEncounteredNanOrInf = NO;
            } else {
                [graph moveToPoint:point];
                self.justEncounteredNanOrInf = !self.justEncounteredNanOrInf;
            }
        }
    }
    
    
    
    [graph stroke];
    
    
}


- (void)drawAxes {
    
    
    // x axis
    UIBezierPath *xAxis = [[UIBezierPath alloc] init];
    NSArray *xAxisLeftPoint = @[[NSNumber numberWithFloat:self.xmin],
                                [NSNumber numberWithFloat:0]];
    NSArray *xAxisRightPoint = @[[NSNumber numberWithFloat:self.xmax],
                                 [NSNumber numberWithFloat:0]];
    
    CGPoint startPoint = [self.delegate convertCoordinatesToCGPoint:xAxisLeftPoint];
    [xAxis moveToPoint:startPoint];
    [xAxis addLineToPoint:[self.delegate convertCoordinatesToCGPoint:xAxisRightPoint]];
    
    [xAxis stroke];
    
    // arrow on x axis
    UIBezierPath *xAxisArrow = [[UIBezierPath alloc] init];
    CGPoint xAxisArrowTip = [self.delegate convertCoordinatesToCGPoint:xAxisRightPoint];
    [xAxisArrow moveToPoint:CGPointMake(xAxisArrowTip.x - AXES_ARROW_LENGTH, xAxisArrowTip.y + AXES_ARROW_LENGTH/2)];
    [xAxisArrow addLineToPoint:xAxisArrowTip];
    [xAxisArrow addLineToPoint:CGPointMake(xAxisArrowTip.x - AXES_ARROW_LENGTH, xAxisArrowTip.y - AXES_ARROW_LENGTH/2)];
    [xAxisArrow addLineToPoint:CGPointMake(xAxisArrowTip.x - AXES_ARROW_LENGTH, xAxisArrowTip.y + AXES_ARROW_LENGTH/2)];
    [xAxisArrow fill];
    
    // y axis
    UIBezierPath *yAxis = [[UIBezierPath alloc] init];
    NSArray *yAxisLowerPoint = @[[NSNumber numberWithFloat:0],
                                 [NSNumber numberWithFloat:self.ymin]];
    NSArray *yAxisUpperPoint = @[[NSNumber numberWithFloat:0],
                                 [NSNumber numberWithFloat:self.ymax]];
    
    
    [yAxis moveToPoint:[self.delegate convertCoordinatesToCGPoint:yAxisLowerPoint]];
    [yAxis addLineToPoint:[self.delegate convertCoordinatesToCGPoint:yAxisUpperPoint]];
    
    [yAxis stroke];
    
    // arrow on y axis
    UIBezierPath *yAxisArrow = [[UIBezierPath alloc] init];
    CGPoint yAxisArrowTip = [self.delegate convertCoordinatesToCGPoint:yAxisUpperPoint];
    [yAxisArrow moveToPoint:CGPointMake(yAxisArrowTip.x - AXES_ARROW_LENGTH/2, yAxisArrowTip.y + AXES_ARROW_LENGTH)];
    [yAxisArrow addLineToPoint:yAxisArrowTip];
    [yAxisArrow addLineToPoint:CGPointMake(yAxisArrowTip.x + AXES_ARROW_LENGTH/2, yAxisArrowTip.y + AXES_ARROW_LENGTH)];
    [yAxisArrow addLineToPoint:CGPointMake(yAxisArrowTip.x - AXES_ARROW_LENGTH/2, yAxisArrowTip.y + AXES_ARROW_LENGTH)];
    [yAxisArrow fill];
    
    
    
    
    
    float dx = [self findBestTickSizeForRangeFrom:self.xmin to:self.xmax];
    float dy = [self findBestTickSizeForRangeFrom:self.ymin to:self.ymax];
    
    
    
    // x ticks
    for (float x = ceilf(self.xmin/dx)*dx;x < floorf(self.xmax/dx)*dx;x+=dx) {
        
        UIBezierPath *xTick = [[UIBezierPath alloc] init];
        NSArray *xTickLowerPoint = @[[NSNumber numberWithFloat:x],
                                     [NSNumber numberWithFloat:-TICK_WIDTH*dy]];
        NSArray *xTickUpperPoint = @[[NSNumber numberWithFloat:x],
                                     [NSNumber numberWithFloat:TICK_WIDTH*dy]];
        [xTick moveToPoint:[self.delegate convertCoordinatesToCGPoint:xTickLowerPoint]];
        [xTick addLineToPoint:[self.delegate convertCoordinatesToCGPoint:xTickUpperPoint]];
        [xTick stroke];
        
        // tick label
        
        NSString *ticklabelText = [NSString stringWithFormat:@"%g", x];
        
        if (fabs(x) < dx/2) {
            ticklabelText = @"";
        }
        
        // load tick label view from nib
        UILabel *currentTickLabel = nil;
        NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"TickLabel" owner:self options: nil];
        for (id anObject in elements) {
            if ([anObject isKindOfClass:[UILabel class]]) {
                currentTickLabel = anObject;
                break;
            }
        }
        
        currentTickLabel.text = ticklabelText;
        [currentTickLabel sizeToFit];
        
        float tickLabelWidth = currentTickLabel.bounds.size.width;
        float tickLabelHeight = currentTickLabel.bounds.size.height;
        
        NSArray *tickCoordinates = @[[NSNumber numberWithFloat:x],
                                     [NSNumber numberWithFloat:0]];
        currentTickLabel.frame = CGRectMake([self.delegate convertCoordinatesToCGPoint:tickCoordinates].x - .5*tickLabelWidth,
                                            [self.delegate convertCoordinatesToCGPoint:tickCoordinates].y + .25*tickLabelHeight,
                                            tickLabelWidth, tickLabelHeight);
        
        if (CGRectContainsRect(self.frame, [self.superview convertRect:currentTickLabel.frame fromView:self])) {
            [self addSubview:currentTickLabel];
        }
    }
    

    
    
    // y ticks
    for (float y = ceilf(self.ymin/dy)*dy;y < floorf(self.ymax/dy)*dy;y+=dy) {
        
        UIBezierPath *yTick = [[UIBezierPath alloc] init];
        NSArray *yTickLeftPoint = @[[NSNumber numberWithFloat:-TICK_WIDTH*dx],
                                    [NSNumber numberWithFloat:y]];
        NSArray *yTickRightPoint = @[[NSNumber numberWithFloat:TICK_WIDTH*dx],
                                     [NSNumber numberWithFloat:y]];
        [yTick moveToPoint:[self.delegate convertCoordinatesToCGPoint:yTickLeftPoint]];
        [yTick addLineToPoint:[self.delegate convertCoordinatesToCGPoint:yTickRightPoint]];
        [yTick stroke];
        
        // tick label
        
        NSString *ticklabelText = [NSString stringWithFormat:@"%g", y];
        
        if (fabs(y) < dy/2) {
            ticklabelText = @"";
        }
        
        // load variable view from nib
        UILabel *currentTickLabel = nil;
        NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"TickLabel" owner:self options: nil];
        for (id anObject in elements) {
            if ([anObject isKindOfClass:[UILabel class]]) {
                currentTickLabel = anObject;
                break;
            }
        }
        
        currentTickLabel.text = ticklabelText;
        [currentTickLabel sizeToFit];
        float tickLabelWidth = currentTickLabel.bounds.size.width;
        float tickLabelHeight = currentTickLabel.bounds.size.height;
        
        NSArray *tickCoordinates = @[[NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:y]];
        currentTickLabel.frame = CGRectMake([self.delegate convertCoordinatesToCGPoint:tickCoordinates].x - 1.25*tickLabelWidth,
                                            [self.delegate convertCoordinatesToCGPoint:tickCoordinates].y - .5*tickLabelHeight,
                                            tickLabelWidth, tickLabelHeight);
        
        if (CGRectContainsRect(self.frame, [self.superview convertRect:currentTickLabel.frame fromView:self])) {
            [self addSubview:currentTickLabel];
        }
        
    }
    

}




- (float)findBestTickSizeForRangeFrom:(float)min to:(float)max {
    
    float Dx = (max - min);
    float exponent = floorf(log10f(Dx));
    float mantisse = Dx/powf(10,exponent);
    float dx = powf(10,exponent-1);
    
    if (mantisse < 1.5) {
        dx *= 1;
    } else if (mantisse < 3) {
        dx *=2;
    } else {
        dx *=5;
    }
    
    return dx;
    
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // delete everything except for the resize button
    for (UIView *subview in self.subviews) {
        if (![subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [[UIColor blackColor] setStroke];
    
    [self drawCircleAtPoint:[self.delegate currentCGPoint]];
    
    [self drawAxes];
    
    [self drawGraph];
    
}





@end
