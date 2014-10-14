//
//  ComposedTerm.m
//  Alfy2
//
//  Created by Ben Hambrecht on 25.05.14.
//  Copyright (c) 2014 Ben Hambrecht. All rights reserved.
//

#import "ComposedTerm.h"
#import "Constant.h"




@implementation ComposedTerm

@synthesize parents;
@synthesize operatorString;
@synthesize frame;
@synthesize variableFetcher;


+ (BOOL)isBinaryOperator:(NSString *)anOperatorString {
    NSArray *binaryOperators = @[@"+", @"–", @"·", @"/", @"^", @"√"];
    return [binaryOperators containsObject:anOperatorString];
}

+ (BOOL)startsWithBinaryOperator:(NSString *)formulaString {
    NSString *firstCharacter = [formulaString substringToIndex:1];
    return [ComposedTerm isBinaryOperator:firstCharacter];
}

+ (BOOL)isTrigonometricOperator:(NSString *)anOperatorString {
    NSArray *trigonometricOperators = @[@"sin", @"cos", @"tan"];
    return [trigonometricOperators containsObject:anOperatorString];
}

+ (BOOL)startsWithTrigonometricOperator:(NSString *)formulaString {
    NSString *firstThreeCharacters = [formulaString substringToIndex:3];
    return [ComposedTerm isTrigonometricOperator:firstThreeCharacters];
}

+ (BOOL)isAnOperator:(NSString *)anOperatorString {
    return ([ComposedTerm isBinaryOperator:anOperatorString] || [ComposedTerm isTrigonometricOperator:anOperatorString]);
}

+ (BOOL)startsWithOperator:(NSString *)formulaString {
    return ([ComposedTerm startsWithBinaryOperator:formulaString] || [ComposedTerm startsWithTrigonometricOperator:formulaString]);
}


//+ (NSString *)operatorAtIndex:(long)index inFormulaArray:(NSArray *)formulaArray {
//    
//    
//    NSString *operatorAtIndex = [formulaArray objectAtIndex:index];
//    
//    if ([ComposedTerm isBinaryOperator:operatorAtIndex]) {
//        return operatorAtIndex;
//    } else {
//        operatorAtIndex = [[formulaString substringWithRange:NSMakeRange(index, 1)] mutableCopy];
//        if ([ComposedTerm isTrigonometricOperator:operatorAtIndex]) {
//            return operatorAtIndex;
//        } else {
//            return nil;
//        }
//        
//        
//    }
//    
//}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
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
    self = [super init];
    NSLog(@"Composed Term initWithParents");
    self.parents = [initialParents mutableCopy];
    self.operatorString = [initialOperatorString mutableCopy];
    
    return self;
}


- (instancetype)initWithArray:(NSArray *)formulaArray andVariableFetcher:(id <VariableFetcher>)aFetcher {
    
    self = [super init];
    self = (ComposedTerm *)[ComposedTerm makeTermWithArray:formulaArray andVariableFetcher:aFetcher];
    return self;
    
}


+ (id <Term>)makeTermWithArray:(NSArray *)formulaArray andVariableFetcher:(id <VariableFetcher>)aFetcher {
    
    if ([ComposedTerm arrayContainsASingleNumber:formulaArray]) {
        
        float value = [[formulaArray firstObject] floatValue];
        Constant *constant = [[Constant alloc] init];
        constant.value = value;
        
        return (id <Term>)constant;
        
    } else if ([ComposedTerm arrayContainsASingleVariableName:formulaArray]) {
        
        Variable *variable = [aFetcher variableWithName:[formulaArray firstObject]];
        
        return (id <Term>)variable;
        
    } else {
        
        NSString *operator = [formulaArray firstObject];
        id <Term> rightOperand = [ComposedTerm makeTermWithArray:[formulaArray lastObject] andVariableFetcher:aFetcher];
        
        if ([formulaArray count] == 3) {
            
            id <Term> leftOperand = [ComposedTerm makeTermWithArray:[formulaArray objectAtIndex:1] andVariableFetcher:aFetcher];
            return [[ComposedTerm alloc] initWithParents:@[leftOperand,rightOperand] andOperator:operator];
        } else {
            return [[ComposedTerm alloc] initWithParents:@[rightOperand] andOperator:operator];
        }
        
    }

}


- (instancetype)initWithFormulaString:(NSString *)formulaString andVariableFetcher:(id<VariableFetcher>)aFetcher {
    
    self = [super init];
    NSArray *formulaArray = [ComposedTerm formulaStringParser:formulaString];
    self = [self initWithArray:formulaArray andVariableFetcher:aFetcher];
    return self;
    
}

//- (instancetype)initWithFormulaString:(NSString *)formulaString andVariableFetcher:(id <VariableFetcher>)aFetcher {
//    NSLog([NSString stringWithFormat:@"ComposedTerm initWithFormulaString: %@", formulaString]);
//    self = [super init];
//    
//    NSArray *formulaArray = [ComposedTerm arrayDescriptionOfFormulaString:formulaString];
//    NSArray *firstLevelDescription = [ComposedTerm firstLevelDescriptionOfFormulaArray:formulaArray];
//    
//    self.operatorString = [firstLevelDescription objectAtIndex:0];
//    
//    self.variableFetcher = aFetcher;
//    
//    NSArray *parentFormulaArrays = [firstLevelDescription objectAtIndex:1];
//    
//    if ([parentFormulaArrays count] == 1) {
//        id <Term> parent = [self makeTermWithFormulaArray:[parentFormulaArrays objectAtIndex:0]];
//        self.parents = [@[parent] mutableCopy];
//    } else if ([parentFormulaArrays count] == 2) {
//        id <Term> parent1 = [self makeTermWithFormulaArray:[parentFormulaArrays objectAtIndex:0]];
//        id <Term> parent2 = [self makeTermWithFormulaArray:[parentFormulaArrays objectAtIndex:1]];
//        self.parents = [@[parent1, parent2] mutableCopy];
//    }
//    
//    return self;
//}
//
//
//- (id <Term>) makeTermWithFormulaArray:(NSArray *)formulaArray {
//    NSLog([NSString stringWithFormat:@"ComposedTerm makeTermWithFormulaArray: %@", formulaArray]);
//    
//    if ([ComposedTerm arrayContainsASingleNumber:formulaArray]) {
//        
//        Constant *constant = [[Constant alloc] init];
//        constant.value = [[formulaArray firstObject] floatValue];
//        return constant;
//    
//    } else if ([ComposedTerm arrayContainsASingleVariableName:formulaArray]) {
//        
//        return (id <Term>)[self.variableFetcher variableWithName:[formulaArray firstObject]];
//        
//    } else {
//        
//        NSMutableString *formulaString = [@"" mutableCopy];
//        for (NSString *element in formulaArray) {
//            [formulaString appendString:element];
//        }
//        
//        ComposedTerm *composedTerm = [[ComposedTerm alloc] initWithFormulaString:formulaString andVariableFetcher:self.variableFetcher];
//        return composedTerm;
//    }
//    
//}


+ (BOOL)isAVariableName:(NSString *)formulaString {
    NSLog([NSString stringWithFormat:@"ComposedTerm isAVariableName: %@", formulaString]);
    
    NSArray *lowercaseAlphabet = @[@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z"];
    NSArray *uppercaseAlphabet = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    
    if ([lowercaseAlphabet containsObject:formulaString]) return YES;
    if ([uppercaseAlphabet containsObject:formulaString]) return YES;
    return NO;
    
}


+ (BOOL)isANumber:(NSString *)formulaString {
    NSLog([NSString stringWithFormat:@"ComposedTerm isANumber: %@", formulaString]);

    if ([formulaString isEqualToString:@"0"])
        return YES;
    
    float value = [formulaString floatValue];
    if (value != 0)
        return YES;
    else
        return NO;
    
}


+ (BOOL)arrayContainsASingleNumber:(NSArray *)formulaArray {
    if ([formulaArray count] != 1) {
        return NO;
    } else {
        return [ComposedTerm isANumber:[formulaArray firstObject]];
    }
}

+ (BOOL)arrayContainsASingleVariableName:(NSArray *)formulaArray {
    if ([formulaArray count] != 1) {
        return NO;
    } else {
        return [ComposedTerm isAVariableName:[formulaArray firstObject]];
    }
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
    } else if ([self.operatorString isEqualToString:@"^"]) {
        result = powf([parent1 value],[parent2 value]);
    } else if ([self.operatorString isEqualToString:@"√"]) {
        if ([self.parents count] == 1) {
            return sqrtf([parent1 value]);
        } else if ([self.parents count] == 2) {
            result = powf([parent2 value], 1./[parent1 value]);
        }
    } else if ([self.operatorString isEqualToString:@"x²"]) {
        result = [parent1 value] * [parent1 value];
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
        } else if ([self.operatorString isEqualToString:@"√"]) {
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
        
        } else if ([self.operatorString isEqualToString:@"^"]) {

            [returnString appendString:@"<msup>"];
            if ([parent1 isComposed]) {
                [returnString appendString:@"(<mrow><mo>(</mo>"];
                [returnString appendString:[parent1 formula]];
                [returnString appendString:@"<mo>)</mo></mrow>"];
            } else {
                [returnString appendString:[parent1 formula]];
            }
            [returnString appendString:@"<mrow>"];
            [returnString appendString:[parent2 formula]];
            [returnString appendString:@"</mrow></msup>"];

        } else if ([self.operatorString isEqualToString:@"√"]) {
            
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







+ (int)bracketLevelAtIndex:(long)index inFormulaArray:(NSArray *)formulaArray {
    
    int bracketLevel = 0;
    NSArray *subArray;
    
    for (long i = [formulaArray count] - 1; i >= index; i--) {
        
        subArray = [formulaArray subarrayWithRange:NSMakeRange(i, [formulaArray count] - i)];
        if ([[subArray firstObject] isEqual:@")"]) {
            bracketLevel++;
        } else if ([[subArray firstObject] isEqual:@"("]) {
            bracketLevel--;
        }
        
    }
    
    return bracketLevel;
    
}



+ (int)precedenceLevelOfOperator:(NSString *)anOperatorString {
    
    NSDictionary *precedences = @{ @"sin" : @1,
                                   @"cos" : @1,
                                   @"tan" : @1,
                                   @"^"   : @2,
                                   @"√"   : @2,
                                   @"·"   : @3,
                                   @"/"   : @3,
                                   @"+"   : @4,
                                   @"–"   : @4 };
    
    return [[precedences valueForKey:anOperatorString] intValue];
    
}


+ (NSArray *)arrayDescriptionOfFormulaString:(NSString *)formulaString {
    
    NSString *stringToDissect = [formulaString mutableCopy];
    NSMutableArray *arrayDescription = [@[] mutableCopy];
    NSString *currentElement = [@"" mutableCopy];
    
    while (![stringToDissect isEqualToString:@""]) {
    
        if ([ComposedTerm startsWithTrigonometricOperator:formulaString]) {
            currentElement = [stringToDissect substringToIndex:3];
        } else {
            currentElement = [stringToDissect substringToIndex:1];
        }

        [arrayDescription addObject:currentElement];
        stringToDissect = [stringToDissect substringFromIndex:[currentElement length]];

    }
    
    return arrayDescription;
}


//+ (NSArray *)firstLevelDescriptionOfFormulaArray:(NSArray *)formulaArray {
//    
//    NSMutableArray *indexesOfOuterOperators = [[NSMutableArray alloc] init];
//    for (long i = [formulaArray count] - 1; i >= 0; i--) {
//        if ([ComposedTerm bracketLevelAtIndex:i inFormulaArray:formulaArray] == 0
//            && [ComposedTerm isAnOperator:[formulaArray objectAtIndex:i]]) {
//            [indexesOfOuterOperators addObject:[NSNumber numberWithLong:i]];
//        }
//    }
//    
//    // if there are no outer operators, delete enclosing parentheses and feed back into yourself
//    if (!indexesOfOuterOperators) {
//        NSRange innerRange = NSMakeRange(1, [formulaArray count] - 2);
//        NSArray *innerFormulaArray = [formulaArray subarrayWithRange:innerRange];
//        return [ComposedTerm firstLevelDescriptionOfFormulaArray:innerFormulaArray];
//    } else {
//        
//        NSMutableString *currentOutermostOperator = [[NSMutableString alloc] init];
//        NSMutableString *weakestEncounteredOutermostOperator = [[NSMutableString alloc] init];
//        int highestEncounteredPrecedenceLevel = 0;
//        int newPrecedenceLevel;
//        long indexOfWeakestEncounteredOutermostOperator = 0;
//        long index = 0;
//        
//        for (long i = [indexesOfOuterOperators count] - 1; i >= 0; i--) {
//            index = [[indexesOfOuterOperators objectAtIndex:i] longValue];
//            currentOutermostOperator = [formulaArray objectAtIndex:index];
//            newPrecedenceLevel = [ComposedTerm precedenceLevelOfOperator:currentOutermostOperator];
//            if (currentOutermostOperator && newPrecedenceLevel > highestEncounteredPrecedenceLevel) {
//                weakestEncounteredOutermostOperator = currentOutermostOperator;
//                indexOfWeakestEncounteredOutermostOperator = index;
//            }
//        }
//        
//        long indexRightFromWeakestEncounteredoutermostOperator = indexOfWeakestEncounteredOutermostOperator + [weakestEncounteredOutermostOperator length];
//        NSArray *rightOperand = [formulaArray subarrayWithRange:NSMakeRange(indexRightFromWeakestEncounteredoutermostOperator, [formulaArray count] - indexRightFromWeakestEncounteredoutermostOperator)];
//        
//        if ([ComposedTerm isTrigonometricOperator:weakestEncounteredOutermostOperator]) {
//            return @[weakestEncounteredOutermostOperator, @[rightOperand]];
//        } else if ([ComposedTerm isBinaryOperator:weakestEncounteredOutermostOperator]) {
//            NSArray *leftOperand = [formulaArray subarrayWithRange:NSMakeRange(0, indexOfWeakestEncounteredOutermostOperator)];
//            return @[weakestEncounteredOutermostOperator, @[leftOperand, rightOperand]];
//        } else {
//            return nil;
//        }
//        
//    }
//    
//}



+ (NSArray *)formulaStringParser:(NSString *)formulaString {
    
    NSArray *formulaArray = [ComposedTerm arrayDescriptionOfFormulaString:formulaString];
    
    return [ComposedTerm formulaArrayParser:formulaArray];
    
}




+ (NSArray *)formulaArrayParser:(NSArray *)formulaArray {
    
    if ([ComposedTerm arrayContainsASingleNumber:formulaArray] || [ComposedTerm arrayContainsASingleVariableName:formulaArray]) {
        
        return formulaArray;
        
    } else {
        
        long i = [ComposedTerm indexOfOutermostWeakestOperatorInFormulaArray:formulaArray];
        
        if (i == NSNotFound) {
            // remove outer brackets
            NSArray *innerFormulaArray = [formulaArray subarrayWithRange:NSMakeRange(1, [formulaArray count] - 2)];
            return [ComposedTerm formulaArrayParser:innerFormulaArray];
        }
        
        NSString *outermostWeakestOperator = [formulaArray objectAtIndex:i];
        NSArray *rightOperandArray = [formulaArray subarrayWithRange:NSMakeRange(i+1, [formulaArray count] - i - 1)];
        if (i != 0) {
            NSArray *leftOperandArray = [formulaArray subarrayWithRange:NSMakeRange(0, i)];
            return @[outermostWeakestOperator,[ComposedTerm formulaArrayParser:leftOperandArray],[ComposedTerm formulaArrayParser:rightOperandArray]];
        } else {
            return @[outermostWeakestOperator,[ComposedTerm formulaArrayParser:rightOperandArray]];
        }
        
    }
    

}

+ (long)indexOfOutermostWeakestOperatorInFormulaArray:(NSArray *)formulaArray {
    
    int highestPrecedenceLevel = 0;
    int currentPrecedenceLevel;
    long currentIndex = NSNotFound;
    NSString *currentSymbol = [[NSString alloc] init];
    
    for (long i = [formulaArray count] - 1; i >= 0; i--) {
        
        currentSymbol = [formulaArray objectAtIndex:i];
        if ([ComposedTerm isAnOperator:currentSymbol] && [ComposedTerm bracketLevelAtIndex:i inFormulaArray:formulaArray] == 0) {
            currentPrecedenceLevel = [ComposedTerm precedenceLevelOfOperator:currentSymbol];
            if (currentPrecedenceLevel > highestPrecedenceLevel) {
                currentIndex = i;
                highestPrecedenceLevel = currentPrecedenceLevel;
            }
        }
        
    }
    
    return currentIndex;
}











@end
