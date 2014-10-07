//
//  Plot.h
//  Alfy
//
//  Created by Ben Hambrecht on 31.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Variable.h"

#define GRAPHVIEW_PADDING .1

@protocol PointConverter

- (CGPoint)convertCoordinatesToCGPoint:(NSArray *)coordinates;
- (NSArray *)cgPointsForPlot;
- (CGPoint)currentCGPoint;

@end


@interface Plot : NSObject <NSCoding, PointConverter>

@property (nonatomic) Variable *variable;
@property (nonatomic) id <Term> xTerm;
@property (nonatomic) id <Term> yTerm;

@property (nonatomic) float xmin;
@property (nonatomic) float xmax;
@property (nonatomic) float ymin;
@property (nonatomic) float ymax;

@property (nonatomic) CGRect frame;


- (instancetype)initWithVariable:(Variable *)initialVariable xTerm:(id <Term>)initialXTerm yTerm:(id <Term>)initialYTerm;

- (BOOL)dependsOnTerm:(id <Term>)term;

- (NSArray *)pointCoordinatesForPlot;
- (NSArray *)currentPointCoordinates;
- (NSArray *)cgPointsForPlot;
- (CGPoint)currentCGPoint;
- (void)updateBounds;

@end
