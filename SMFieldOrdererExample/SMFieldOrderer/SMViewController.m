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
	self.field4.enabled = NO;
	self.field0.enabled = NO;
	
	// Must be called once on a vier hierarchy to let the controller determine the desired order.
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
