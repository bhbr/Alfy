//
//  AlfyViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Variable.h"
#import "ArrowView.h"

@protocol TermSelectionHandler <UIGestureRecognizerDelegate>


- (void)termTouchDown:(id <Term>)term;
- (void)termTouchUp:(id <Term>)term;

- (void)selectTerm:(id <Term>)term;

@end


@protocol TermUpdater

- (void)updateValuesOfTermsDependentOn:(id <Term>)term;
- (void)updatePlotsDependentOn:(id <Term>)term;

@end


@protocol ArrowDrawer

- (void)updateArrows;

@end


@protocol MenuVCDelegate

- (void)buttonPressedWithText:(NSString *)buttonText;

@end


@protocol TermHighlighter

- (void)highlightTerm:(id <Term>)term;
- (void)unhighlightTerm:(id <Term>)term;

@end


@interface AlfyViewController : UIViewController <TermSelectionHandler,
                                                  TermUpdater,
                                                  ArrowDrawer,
                                                  MenuVCDelegate,
                                                  UIPopoverControllerDelegate,
                                                  TermHighlighter>


@end
