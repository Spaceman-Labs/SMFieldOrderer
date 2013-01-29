//
//  SMFieldOrderer.h
//  SMFieldOrderer
//
//  Created by Jerry Jones on 1/29/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMFieldOrderer : NSObject

@property (nonatomic, copy, readonly) NSMutableArray *orderArray;

- (void)setupOrderingForView:(UIView *)view;
- (UIView *)nextOrderedFirstResponder;
- (IBAction)pushNextOrderedResponder;

- (BOOL)shouldBeginEditingOrderedField:(UITextField *)field;
- (void)didBeginEditingOrderedField:(UITextField *)field;
- (BOOL)pushNextOrderedResponderForReturnKey;

@end


@interface UIView (SMFieldOrderer)

// Default value is NO, set to YES if you want a view to be skipped by the field orderer
@property (nonatomic, assign) BOOL skipOrderingByFieldOrderer;
@property (nonatomic, assign, readonly) BOOL isOrderedByFieldOrderer;

@end
