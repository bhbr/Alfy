//
//  ComposedTerm.m
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ComposedTerm.h"

@implementation ComposedTerm

@synthesize parents;
@synthesize operatorString;
@synthesize frame;



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    float originX = [aDecoder decodeFloatForKey:@"originX"];
    float originY = [aDecoder decodeFloatForKey:@"originY"];
    float width = [aDecoder decodeFloatForKey:@"width"];
    float height = [aDecoder decodeFloatForKey:@"height"];
    self.frame = CGRectMake(originX,originY,width,height);
    self.parents = [aDecoder decodeObjectForKey:@"parents"];
    self.operatorString = [aDecoder decodeObjectForKey:@"operatorString"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.frame.origin.x forKey:@"originX"];
    [aCoder encodeFloat:self.frame.origin.y forKey:@"originY"];
    [aCoder encodeFloat:self.frame.size.width forKey:@"width"];
    [aCoder encodeFloat:self.frame.size.height forKey:@"height"];
    [aCoder encodeObject:self.parents forKey:@"parents"];
    [aCoder encodeObject:self.operatorString forKey:@"operatorString"];
}

- (instancetype)initWithParents:(NSArray *)initialParents andOperator:(NSString *)initialOperatorString {
    self.parents = [initialParents mutableCopy];
    self.operatorString = [initialOperatorString mutableCopy];
    
    return self;
}





- (float)value {
    
    float result = 0;
    id <Term> parent1 = [self.parents firstObject];
    id <Term> parent2 = [self.parents lastObject];
    
    if ([self.operatorString isEqualToString:@"+"]) {
        result = [parent1 value] + [parent2 value];
    } else if ([self.operatorString isEqualToString:@"–"]) {
        result = [parent1 value] - [parent2 value];
    } else if ([self.operatorString isEqualToString:@"·"]) {
        result = [parent1 value] * [parent2 value];
    } else if ([self.operatorString isEqualToString:@"/"]) {
        result = [parent1 value] / [parent2 value];
    } else if ([self.operatorString isEqualToString:@"x^y"]) {
        result = powf([parent1 value],[parent2 value]);
    } else if ([self.operatorString isEqualToString:@"y√x"]) {
        result = powf([parent2 value], 1./[parent1 value]);
    } else if ([self.operatorString isEqualToString:@"x²"]) {
        result = [parent1 value] * [parent1 value];
    } else if ([self.operatorString isEqualToString:@"√x"]) {
        result = sqrtf([parent1 value]);
    } else if ([self.operatorString isEqualToString:@"1/x"]) {
        result = 1./[parent1 value];
    } else if ([self.operatorString isEqualToString:@"sin"]) {
        result = sinf([parent1 value]);
    } else if ([self.operatorString isEqualToString:@"cos"]) {
        result = cosf([parent1 value]);
    } else if ([self.operatorString isEqualToString:@"tan"]) {
        result = tanf([parent1 value]);
    }
    
    return result;

}


- (BOOL)dependsOnTerm:(id<Term>)term {
    if (term == self) {
        return YES;
    }
    for (id <Term> parent in self.parents) {
        if ([parent dependsOnTerm:term]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isAVariable {
    return NO;
}

- (BOOL)isAConstant {
    return NO;
}

- (BOOL)isComposed {
    return YES;
}



- (NSString *)formula {
    
    NSMutableString *returnString = [@"" mutableCopy];
    id <Term> parent1 = [self.parents firstObject];
    id <Term> parent2 = [self.parents lastObject];
    
    
    if ([self.parents count] == 1) {
        
        if ([self.operatorString isEqualToString:@"x²"]) {
            if ([parent1 isAVariable] || [parent1 isAConstant]) {
                [returnString appendString:@"<msup>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mn>2</mn></msup>"];
            } else {
                [returnString appendString:@"<msup><mrow><mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow><mn>2</mn></msup>"];
            }
        } else if ([self.operatorString isEqualToString:@"√x"]) {
            [returnString appendString:@"<msqrt>"];
            [returnString appendString:[parent1 formula]];
            [returnString appendString:@"</msqrt>"];
        } else if ([self.operatorString isEqualToString:@"1/x"]) {
            if ([parent1 isAVariable] || [parent1 isAConstant]) {
                [returnString appendString:@"<mfrac><mn>1</mn>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"</mfrac>"];
            } else {
                [returnString appendString:@"<mfrac><mn>1</mn><mrow><mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            }
        } else {
            [returnString appendString:@"<mrow><mn>"];
            [returnString appendString:self.operatorString];
            [returnString appendString:@"</mn>"];
            if ([parent1 isComposed]) {
                [returnString appendString:@"<mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            } else {
                [returnString appendString:[parent1 formula]];
            }
        }
        
    } else if ([self.parents count] == 2) {
        
        if ([self.operatorString isEqualToString:@"+"]) {
            
            [returnString appendString:[parent1 formula]];
            [returnString appendString:@"<mo>+</mo>"];
            [returnString appendString:[parent2 formula]];
            
        } else if ([self.operatorString isEqualToString:@"–"]) {
            
            [returnString appendString:[parent1 formula]];
            [returnString appendString:@"<mo>-</mo>"];
            if ([[parent2 outermostOperator] isEqualToString:@"+"] || [[parent2 outermostOperator] isEqualToString:@"–"]) {
                [returnString appendString:@"<mo>(</mo>"];
                [returnString appendString:[parent2 formula]];
                [returnString appendString:@"<mo>)</mo>"];
            } else {
                [returnString appendString:[parent2 formula]];
            }
            
        } else if ([self.operatorString isEqualToString:@"·"]) {
            
            if ([[parent1 outermostOperator] isEqualToString:@"+"] || [[parent1 outermostOperator] isEqualToString:@"–"]) {
                [returnString appendString:@"<mrow><mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            } else {
                [returnString appendString:[parent1 formula]];
            }
            [returnString appendString:@"<mo>"];
            [returnString appendString:@"&sdot;"];
            [returnString appendString:@"</mo>"];
            if ([[parent2 outermostOperator] isEqualToString:@"+"] || [[parent2 outermostOperator] isEqualToString:@"–"]) {
                [returnString appendString:@"<mrow><mo>(</mo>"];
                [returnString appendString:[parent2 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            } else {
                [returnString appendString:[parent2 formula]];
            }
            
        } else if ([self.operatorString isEqualToString:@"/"]) {
            
            [returnString appendString:@"<mfrac>"];
            [returnString appendString:[parent1 formula]];
            [returnString appendString:[parent2 formula]];
            [returnString appendString:@"</mfrac>"];
        
        } else if ([self.operatorString isEqualToString:@"x^y"]) {

            [returnString appendString:@"<msup>"];
            if ([parent1 isComposed]) {
                [returnString appendString:@"(<mrow><mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            } else {
                [returnString appendString:[parent1 formula]];
            }
            [returnString appendString:[parent2 formula]];
            [returnString appendString:@"</msup>"];

        } else if ([self.operatorString isEqualToString:@"y√x"]) {
            
            [returnString appendString:@"<mroot>"];
            [returnString appendString:[parent1 formula]];
            [returnString appendString:[parent2 formula]];
            [returnString appendString:@"</mroot>"];
            
        }
        
    }
    
    
    return returnString;
    
}



- (NSString *)outermostOperator {
    return self.operatorString;
}





























@end
