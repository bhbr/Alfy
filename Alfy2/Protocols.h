//
//  Protocols.h
//  Alfy2
//
//  Created by Ben Hambrecht on 13.10.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "Term.h"

#ifndef Alfy2_Protocols_h
#define Alfy2_Protocols_h

@class ComposedTerm;
@class ComposedTermViewController;

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


//@protocol FormulaParsingDelegate
//
//- (ComposedTerm *)createTermForFormula:(Formula *)formula;
//
//@end


@protocol ComposedTermRegistrator

- (void)registerComposedTermForViewController:(ComposedTermViewController *)composedTermVC;

@end


#endif
