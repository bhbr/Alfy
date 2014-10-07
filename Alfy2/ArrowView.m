//
//  ArrowView.m
//  Alfy
//
//  Created by Ben Hambrecht on 28.03.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ArrowView.h"

@implementation ArrowView

@synthesize lines;



- (void)addLineFromPoint:(CGPoint)point1 direction:(NSString *)direction1 toPoint:(CGPoint)point2 direction:(NSString *)direction2 {
    
    if (!self.lines) {
        self.lines = [[NSMutableArray alloc] init];
    }
    
    NSValue *point1Value = [NSValue valueWithCGPoint:point1];
    NSValue *point2Value = [NSValue valueWithCGPoint:point2];
    [self.lines addObject:@[point1Value, direction1, point2Value, direction2]];
}


- (void)addLinesFromFrames:(NSArray *)parentFrames toFrame:(CGRect)childFrame {
    
    CGRect parentFrame1 = [[parentFrames firstObject] CGRectValue];
    CGRect parentFrame2 = [[parentFrames lastObject] CGRectValue];
    
    NSDictionary *edgeCentersParentFrame1 = [self edgeCentersOfFrame:parentFrame1];
    NSDictionary *edgeCentersParentFrame2 = [self edgeCentersOfFrame:parentFrame2];
    NSDictionary *edgeCentersChildFrame = [self edgeCentersOfFrame:childFrame];
    
    float minimumEdgeDistanceSquareSum = 1e12;
    CGPoint startingPoint1 = CGPointZero;
    CGPoint startingPoint2 = CGPointZero;
    CGPoint endPoint = CGPointZero;
    NSMutableString *startingDirection1 = [@"" mutableCopy];
    NSMutableString *startingDirection2 = [@"" mutableCopy];
    NSMutableString *endDirection = [@"" mutableCopy];
    
    for (NSString *key1 in [edgeCentersParentFrame1 allKeys]) {
        for (NSString *key2 in [edgeCentersParentFrame2 allKeys]) {
            NSValue *edgeCenterParent1Value = [edgeCentersParentFrame1 valueForKey:key1];
            NSValue *edgeCenterParent2Value = [edgeCentersParentFrame2 valueForKey:key2];
            for (NSString *key3 in [edgeCentersChildFrame allKeys]) {
                NSValue *edgeCenterChildValue = [edgeCentersChildFrame valueForKey:key3];
                float distanceSquareSum = [self distanceSquaredBetween:[edgeCenterParent1Value CGPointValue] and:[edgeCenterChildValue CGPointValue]] + [self distanceSquaredBetween:[edgeCenterParent2Value CGPointValue] and:[edgeCenterChildValue CGPointValue]];
                if (distanceSquareSum < minimumEdgeDistanceSquareSum) {
                    minimumEdgeDistanceSquareSum = distanceSquareSum;
                    startingPoint1 = [edgeCenterParent1Value CGPointValue];
                    startingDirection1 = [key1 copy];
                    startingPoint2 = [edgeCenterParent2Value CGPointValue];
                    startingDirection2 = [key2 copy];
                    endPoint  = [edgeCenterChildValue CGPointValue];
                    endDirection = [key3 copy];
                }
            }
        }
    }
    [self addLineFromPoint:startingPoint1 direction:startingDirection1 toPoint:endPoint direction:endDirection];
    [self addLineFromPoint:startingPoint2 direction:startingDirection2 toPoint:endPoint direction:endDirection];
}


- (float)distanceSquaredBetween:(CGPoint)point1 and:(CGPoint)point2 {
    return powf((point1.x - point2.x),2) + powf((point1.y - point2.y),2);
}

- (NSDictionary *)edgeCentersOfFrame:(CGRect)frame {
    CGPoint upperCenter = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y);
    CGPoint lowerCenter = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height);
    CGPoint leftCenter = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height/2);
    CGPoint rightCenter = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height/2);
    NSDictionary *edgeCenters = @{@"upper" : [NSValue valueWithCGPoint:upperCenter],
                                  @"lower" : [NSValue valueWithCGPoint:lowerCenter],
                                  @"left" : [NSValue valueWithCGPoint:leftCenter],
                                  @"right" : [NSValue valueWithCGPoint:rightCenter] };
    
    return edgeCenters;
}



- (void) drawArrows {
    
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    
    for (NSArray *line in self.lines) {
        CGPoint startingPoint = [self startingPointOfLine:line];
        NSString *startingDirection = [self startingDirectionOfLine:line];
        CGPoint controlPoint1 = [self controlPointForPoint:startingPoint inDirection:startingDirection];
        [arrow moveToPoint:startingPoint];
        
        CGPoint endPoint = [self endPointOfLine:line];
        NSString *endDirection = [self endDirectionOfLine:line];
        CGPoint controlPoint2 = [self controlPointForPoint:endPoint inDirection:endDirection];
        [arrow addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    }
    
    [[UIColor blackColor] setStroke];
    
    [arrow stroke];
    
}

- (CGPoint)startingPointOfLine:(NSArray *)line {
    return [[line objectAtIndex:0] CGPointValue];
}

- (NSString *)startingDirectionOfLine:(NSArray *)line {
    return [line objectAtIndex:1];
}

- (CGPoint)endPointOfLine:(NSArray *)line {
    return [[line objectAtIndex:2] CGPointValue];
}

- (NSString *)endDirectionOfLine:(NSArray *)line {
    return [line objectAtIndex:3];
}


- (CGPoint)controlPointForPoint:(CGPoint)point inDirection:(NSString *)direction {
    
    CGPoint controlPoint = point;
    float offset = 50;
    if ([direction isEqualToString:@"upper"]) {
        controlPoint.y -= offset;
    } else if ([direction isEqualToString:@"lower"]) {
        controlPoint.y += offset;
    } else if ([direction isEqualToString:@"left"]) {
        controlPoint.x -= offset;
    } else if ([direction isEqualToString:@"right"]) {
        controlPoint.x += offset;
    }
    return controlPoint;
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawArrows];
    
}


@end
