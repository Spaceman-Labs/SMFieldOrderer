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
/// if NO, pushNextOrderedResponderForReturnKey will set no responder and return NO when the last responder is currently responding. Defaults to YES.
@property (nonatomic, assign) BOOL wrapsAround;

- (void)setupOrderingForView:(UIView *)view;
- (UIView *)nextOrderedFirstResponder;
- (BOOL)pushNextOrderedResponder;

- (BOOL)shouldBeginEditingOrderedField:(UITextField *)field;
- (void)didBeginEditingOrderedField:(UITextField *)field;
- (BOOL)pushNextOrderedResponderForReturnKey;

@end


@interface UIView (SMFieldOrderer)

// Default value is NO, set to YES if you want a view to be skipped by the field orderer
@property (nonatomic, assign) BOOL skipOrderingByFieldOrderer;
@property (nonatomic, assign, readonly) BOOL isOrderedByFieldOrderer;
@end
