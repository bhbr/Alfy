//
//  Variable.h
//  Alfy2
//
//  Created by Ben Hambrecht on 20.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Term.h"

@interface Variable : NSObject <NSCoding, Term>

@property (nonatomic) float minValue;
@property (nonatomic) float maxValue;
@property (nonatomic) float value;
@property (nonatomic) NSMutableString *name;


@end
