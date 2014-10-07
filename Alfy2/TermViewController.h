//
//  TermViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Term.h"
#import "AlfyViewController.h"
#import "OperatorMenuViewController.h"



@interface TermViewController : UIViewController <UIPopoverControllerDelegate,
                                                  //OperatorMenuVCDelegate,
                                                  UIWebViewDelegate>

@property (nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic) id <Term> term;
@property (nonatomic) id <TermSelectionHandler> delegate;
@property (nonatomic) id <ArrowDrawer> arrowDrawer;
@property (nonatomic) IBOutlet UIWebView *formulaWebView;
@property (nonatomic) UIColor *highlightColor;
@property (nonatomic) UIColor *unhighlightColor;
@property (nonatomic) id <TermSelectionHandler> selectionHandlerDelegate;

- (IBAction)dragView:(UIPanGestureRecognizer *)sender;
//- (void)openOperatorMenu;
- (void)highlight;
- (void)unhighlight;
- (NSString *)formulaAsHTML;
- (void)prepareFormulaWebView;

//- (CGPoint)menuCenter;


@end

