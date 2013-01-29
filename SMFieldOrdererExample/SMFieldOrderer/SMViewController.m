//
//  SMViewController.m
//  SMFieldOrderer
//
//  Created by Jerry Jones on 1/29/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()
@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.field4.skipOrderingByFieldOrderer = YES;
	[self.orderer setupOrderingForView:self.view];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return [self.orderer shouldBeginEditingOrderedField:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.orderer didBeginEditingOrderedField:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.orderer pushNextOrderedResponderForReturnKey];
	return YES;
}

@end
