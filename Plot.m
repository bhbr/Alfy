//
//  Plot.m
//  Alfy
//
//  Created by Ben Hambrecht on 31.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "Plot.h"
#import "AlfyViewController.h"

@interface Plot ()


@end

@implementation Plot

@synthesize variable;
@synthesize xTerm;
@synthesize yTerm;

@synthesize xmin;
@synthesize xmax;
@synthesize ymin;
@synthesize ymax;

@synthesize frame;


- (instancetype)initWithVariable:(Variable *)initialVariable xTerm:(id <Term>)initialXTerm yTerm:(id <Term>)initialYTerm {
    self = [super init];
    self.variable = initialVariable;
    self.xTerm = initialXTerm;
    self.yTerm = initialYTerm;
    [self updateBounds];
    return self;
}


- (NSArray *)pointCoordinatesForPlot {
    NSMutableArray *pointCoordinates = [[NSMutableArray alloc] init];
    float variableValueBackup = self.variable.value;
    float dt = (self.variable.maxValue - self.variable.minValue)/100.;
    for (float t = self.variable.minValue; t <= self.variable.maxValue; t += dt) {
        self.variable.value = t;
        [pointCoordinates addObject:@[[NSNumber numberWithFloat:[self.xTerm value]],
                                      [NSNumber numberWithFloat:[self.yTerm value]]]];
    }
    self.variable.value = variableValueBackup;
    return pointCoordinates;
}


- (NSArray *)currentPointCoordinates {
    return @[[NSNumber numberWithFloat:[self.xTerm value]],
             [NSNumber numberWithFloat:[self.yTerm value]]];
}



- (CGPoint)convertCoordinatesToCGPoint:(NSArray *)coordinates {
    float x = [[coordinates firstObject] floatValue];
    float y = [[coordinates lastObject] floatValue];
    
    float x2 = (x - self.xmin)/(self.xmax - self.xmin)*self.frame.size.width;
    float y2 = (1 - (y - self.ymin)/(self.ymax - self.ymin))*self.frame.size.height;
    
    return CGPointMake(x2, y2);

}


- (NSArray *)cgPointsForPlot {
    NSMutableArray *cgPoints = [[NSMutableArray alloc] init];
    NSArray *pointCoordinates = [self pointCoordinatesForPlot];
    for (NSArray *pointCoordinate in pointCoordinates) {
        CGPoint cgPoint = [self convertCoordinatesToCGPoint:pointCoordinate];
        [cgPoints addObject:[NSValue valueWithCGPoint:cgPoint]];
    }
    return cgPoints;
}


- (CGPoint)currentCGPoint {
    return [self convertCoordinatesToCGPoint:[self currentPointCoordinates]];
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.variable = [aDecoder decodeObjectForKey:@"variable"];
    self.xTerm = [aDecoder decodeObjectForKey:@"xTerm"];
    self.yTerm = [aDecoder decodeObjectForKey:@"yTerm"];
    
    self.xmin = [aDecoder decodeFloatForKey:@"xmin"];
    self.xmax = [aDecoder decodeFloatForKey:@"xmax"];
    self.ymin = [aDecoder decodeFloatForKey:@"ymin"];
    self.ymax = [aDecoder decodeFloatForKey:@"ymax"];
    
    float originX = [aDecoder decodeFloatForKey:@"originX"];
    float originY = [aDecoder decodeFloatForKey:@"originY"];
    float width = [aDecoder decodeFloatForKey:@"width"];
    float height = [aDecoder decodeFloatForKey:@"height"];
    self.frame = CGRectMake(originX,originY,width,height);
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.variable forKey:@"variable"];
    [aCoder encodeObject:self.xTerm forKey:@"xTerm"];
    [aCoder encodeObject:self.yTerm forKey:@"yTerm"];
    
    [aCoder encodeFloat:self.xmin forKey:@"xmin"];
    [aCoder encodeFloat:self.xmax forKey:@"xmax"];
    [aCoder encodeFloat:self.ymin forKey:@"ymin"];
    [aCoder encodeFloat:self.ymax forKey:@"ymax"];
    
    [aCoder encodeFloat:self.frame.origin.x forKey:@"originX"];
    [aCoder encodeFloat:self.frame.origin.y forKey:@"originY"];
    [aCoder encodeFloat:self.frame.size.width forKey:@"width"];
    [aCoder encodeFloat:self.frame.size.height forKey:@"height"];
    
}


- (BOOL)dependsOnTerm:(id <Term>)term {
    if ([self.xTerm dependsOnTerm:term]) {
        return YES;
    } else if ([self.yTerm dependsOnTerm:term]) {
        return YES;
    } else if (self.variable == term) {
        return YES;
    }
    return NO;
}


- (void)updateBounds {
    
    NSArray *pointCoordinates = [self pointCoordinatesForPlot];
    self.xmin = [self minimumXForCoordinates:pointCoordinates];
    self.xmax = [self maximumXForCoordinates:pointCoordinates];
    self.ymin = [self minimumYForCoordinates:pointCoordinates];
    self.ymax = [self maximumYForCoordinates:pointCoordinates];
    
    
    if (self.xmin == self.xmax) {
        self.xmin -= 1;
        self.xmax +=1;
    }
    
    float xWidth = self.xmax - self.xmin;
    float padding = GRAPHVIEW_PADDING * xWidth;
    self.xmin -= padding;
    self.xmax += padding;
    
    
    
    if (self.ymin == self.ymax) {
        self.ymin -= 1;
        self.ymax +=1;
    }
    
    float yWidth = self.ymax - self.ymin;
    padding = GRAPHVIEW_PADDING * yWidth;
    self.ymin -= padding;
    self.ymax += padding;
    
}

- (float)minimumXForCoordinates:(NSArray *)coordinates {
    NSArray *firstCoordinate = [coordinates firstObject];
    float extremum = [[firstCoordinate firstObject] floatValue];
    float x = extremum;
    for (NSArray *coordinate in coordinates)  {
        x = [[coordinate firstObject] floatValue];
        if (x < extremum) {
            extremum = x;
        }
    }
    return extremum;
}


- (float)maximumXForCoordinates:(NSArray *)coordinates {
    NSArray *firstCoordinate = [coordinates firstObject];
    float extremum = [[firstCoordinate firstObject] floatValue];
    float x = extremum;
    for (NSArray *coordinate in coordinates)  {
        x = [[coordinate firstObject] floatValue];
        if (x > extremum) {
            extremum = x;
        }
    }
    return extremum;
}


- (float)minimumYForCoordinates:(NSArray *)coordinates {
    NSArray *firstCoordinate = [coordinates firstObject];
    float extremum = [[firstCoordinate lastObject] floatValue];
    float y = extremum;
    for (NSArray *coordinate in coordinates) {
        y = [[coordinate lastObject] floatValue];
        if (y < extremum) {
            extremum = y;
        }
    }
    return extremum;
}


- (float)maximumYForCoordinates:(NSArray *)coordinates {
    NSArray *firstCoordinate = [coordinates firstObject];
    float extremum = [[firstCoordinate lastObject] floatValue];
    float y = extremum;
    for (NSArray *coordinate in coordinates)  {
        y = [[coordinate lastObject] floatValue];
        if (y > extremum) {
            extremum = y;
        }
    }
    return extremum;
}



























@end

