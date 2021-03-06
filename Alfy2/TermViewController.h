//
//  TermViewController.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Term.h"
#import "Protocols.h"
#import "OperatorMenuViewController.h"



@interface TermViewController : UIViewController <UIPopoverControllerDelegate,
                                                  UIWebViewDelegate>

@property (nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic) id <Term> term;
@property (nonatomic) id <ArrowDrawer> arrowDrawer;
@property (nonatomic) IBOutlet UIWebView *formulaWebView;
@property (nonatomic) UIColor *highlightColor;
@property (nonatomic) UIColor *unhighlightColor;
@property (nonatomic) id <TermSelectionHandler> selectionHandlerDelegate;

- (IBAction)dragView:(UIPanGestureRecognizer *)sender;
- (void)highlight;
- (void)unhighlight;
- (NSString *)formulaAsHTML;
- (void)prepareFormulaWebView;



@end

