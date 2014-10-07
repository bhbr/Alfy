//
//  TouchCounter.m
//  Toucher
//
//  Created by Ben Hambrecht on 02.10.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "TouchCounter.h"

@class TermView;

@interface TouchCounter()

@property (nonatomic) CFTimeInterval timeOfLastTouchUp;
@property (nonatomic) BOOL lastEventWasTouchUp;
@property (nonatomic) NSMutableArray *touchedViews;

@end

@implementation TouchCounter

@synthesize delegate;
@synthesize timeOfLastTouchUp;
@synthesize touchedViews;

- (instancetype)init {
    self = [super init];
    self.touchedViews = [[NSMutableArray alloc] init];
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if ([self.delegate isTermView:touch.view]) {
            
            NSLog([NSString stringWithFormat:@"%lu touch(es) began", (unsigned long) [touches count]]);
            //[self.delegate updateNbTouches:[[event allTouches] count]];
            self.timeOfLastTouchUp = 0;
            self.lastEventWasTouchUp = NO;
            CGPoint location = [touch locationInView:self.view];
            [self.touchedViews addObject:[touch view]];
            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog([NSString stringWithFormat:@"%i touches moved", [touches count]]);
//    [self.delegate updateNbTouches:[[event allTouches] count]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        if (![self.delegate isTermView:touch.view]) {
            return;
        }
    }

    NSLog([NSString stringWithFormat:@"%lu touch(es) ended", (unsigned long) [touches count]]);
    //[self.delegate updateNbTouches:[[event allTouches] count] - [touches count]];
    BOOL touchesLeft = [[event allTouches] count] - [touches count];

    
    if (self.lastEventWasTouchUp && CACurrentMediaTime() - self.timeOfLastTouchUp > .5) {
        [self.touchedViews removeLastObject];
    }
    
    if (touchesLeft) {
        self.timeOfLastTouchUp = CACurrentMediaTime();
    } else {
        if ([touches count] == 1 & CACurrentMediaTime() - self.timeOfLastTouchUp > .5) {
            NSLog(@"present single operand menu");
            [self logTouchLocations];
            [self.delegate handleSelectionOfViews:self.touchedViews];
            [self.touchedViews removeAllObjects];
        } else if ([touches count] > 1) {
            NSLog(@"present multi-operand menu");
            [self logTouchLocations];
            [self.delegate handleSelectionOfViews:self.touchedViews];
            [self.touchedViews removeAllObjects];
        } else {
            if (CACurrentMediaTime() - self.timeOfLastTouchUp < .5) {
                NSLog(@"present multi-operand menu");
                [self logTouchLocations];
                [self.delegate handleSelectionOfViews:self.touchedViews];
                [self.touchedViews removeAllObjects];
            } else {
                self.timeOfLastTouchUp = CACurrentMediaTime();
                [self.touchedViews removeLastObject];
            }
        }
    }
    
    self.lastEventWasTouchUp = YES;
 
}


- (void)logTouchLocations {
    for (UIView *touchedView in self.touchedViews) {
        CGPoint location = touchedView.center;
        NSLog([NSString stringWithFormat:@"(%f, %f)", location.x, location.y]);
    }
}

@end
