//
//  SMFieldOrderer.m
//  SMFieldOrderer
//
//  Created by Jerry Jones on 1/29/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import "SMFieldOrderer.h"
#import <objc/runtime.h>

static NSString *__SMFieldOrdererIsOrderedByFieldOrderer = @"com.spacemanlabs.smtabcommander.orderedbytabcommander";
static NSString *__SMFieldOrdererIsOrderableByFieldOrderer = @"com.spacemanlabs.smtabcommander.orderablebytabcommander";

@interface UIView ()
@property (nonatomic, assign, readwrite) BOOL isOrderedByFieldOrderer;
@end

@interface SMFieldOrderer ()
@property (nonatomic, weak) UIView *lastKnownFirstResponder;
@property (nonatomic, weak) UIView *pushingFirstResponder;
@property (nonatomic, weak) UIView *maybeTabbingFirstResponder;
@property (nonatomic, assign) BOOL maybeTabbing;
@property (nonatomic, assign) BOOL isTabbing;
@property (nonatomic, copy, readwrite) NSMutableArray *orderArray;
@end

@implementation SMFieldOrderer

- (void)_walkSubviewsOfView:(UIView *)view action:(void (^)(UIView *view, BOOL *stop))action
{
	[[view subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop) {
		[self _walkSubviewsOfView:view action:action];
		if (action) {
			action(view, stop);
		}
	}];
}

- (void)setupOrderingForView:(UIView *)view
{
	NSMutableArray *orderArray = [NSMutableArray array];
	
	[self _walkSubviewsOfView:view action:^(UIView *view, BOOL *stop){
		if (NO == [view isKindOfClass:[UITextField class]] && NO == [view isKindOfClass:[UITextView class]]) {
			return;
		}else if (YES == view.skipOrderingByFieldOrderer) {
			return;
		}
		
		[orderArray addObject:view];
		view.isOrderedByFieldOrderer = YES;
	}];
	
	[orderArray sortUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
		NSInteger tag1 = view1.tag;
		NSInteger tag2 = view2.tag;
		
		NSComparisonResult result = tag1 > tag2 ? NSOrderedDescending : NSOrderedAscending;
		return result;
	}];
	
	self.orderArray = orderArray;
}

- (UIView *)_orderedFirstResponder:(NSUInteger *)orderIndex
{
	// Shortcut, first lets try to use the last first responder we found
	if (self.lastKnownFirstResponder.isFirstResponder) {
		if (orderIndex) {
			*orderIndex = [self.orderArray indexOfObject:self.lastKnownFirstResponder];
		}
		return self.lastKnownFirstResponder;
	}
	
	__block UIView *firstResponder = nil;
	if (orderIndex) {
		*orderIndex = NSNotFound;
	}
	[self.orderArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger index, BOOL *stop){
		if (view.isFirstResponder) {
			firstResponder = view;
			if (orderIndex) {
				*orderIndex = index;
			}
			*stop = YES;
		}
	}];
	
	self.lastKnownFirstResponder = firstResponder;
	
	return firstResponder;
}

- (UIView *)nextOrderedFirstResponder
{
	NSArray *orderArray = self.orderArray;
	
	if (orderArray.count < 1) {
		return nil;
	}
	
	NSUInteger firstResponderOrderIndex;
	UIView *firstResponder = [self _orderedFirstResponder:&firstResponderOrderIndex];
	
	if (nil == firstResponder) {
		// If there is no currently known first responder, start at the beginning of our ordered fields
		// If we have no fields, then we've got nothin' to return
		if (orderArray.count > 0) {
			return orderArray[0];
		} else {
			return nil;
		}
	}
	
	if (orderArray.count > firstResponderOrderIndex + 1) {
		return orderArray[firstResponderOrderIndex + 1];
	} else {
		return orderArray[0];
	}
	
	return nil;
}

- (void)pushNextOrderedResponder
{
	[[self nextOrderedFirstResponder] becomeFirstResponder];
}

- (BOOL)shouldBeginEditingOrderedField:(UITextField *)field
{
	return [self shouldBeginEditingOrderedResponder:field];
}

- (BOOL)shouldBeginEditingOrderedResponder:(UIView <UITextInput>*)textFieldOrView
{
	if (self.maybeTabbing) {
		if (NO == self.isTabbing) {
			self.isTabbing = YES;
			self.pushingFirstResponder = [self nextOrderedFirstResponder];
		}
	} else {
		self.maybeTabbing = YES;
		self.maybeTabbingFirstResponder = textFieldOrView;
		return YES;
	}
	
	if (textFieldOrView == self.lastKnownFirstResponder) {
		return YES;
	}
	
	if (textFieldOrView == self.maybeTabbingFirstResponder) {
		return YES;
	}
	
	return self.pushingFirstResponder == textFieldOrView;
}

- (void)didBeginEditingOrderedField:(UITextField *)field
{
	if (self.isTabbing) {
		[self.pushingFirstResponder becomeFirstResponder];
	}
	
	self.isTabbing = NO;
	self.maybeTabbing = NO;
	self.lastKnownFirstResponder = field;
	self.pushingFirstResponder = nil;
	self.maybeTabbingFirstResponder = nil;
}

- (BOOL)pushNextOrderedResponderForReturnKey
{
	UIView <UITextInput>*currentResponder = (UIView <UITextInput> *)[self _orderedFirstResponder:NULL];
	if (nil == currentResponder) {
		return NO;
	}
	
	if (UIReturnKeyNext != [currentResponder returnKeyType] && UIReturnKeyDefault != [currentResponder returnKeyType]) {
		return NO;
	}
	
	[self pushNextOrderedResponder];
	
	return YES;
}

@end


@implementation UIView (SMFieldOrderer)

@dynamic isOrderedByFieldOrderer;

- (BOOL)skipOrderingByFieldOrderer
{
	NSNumber *isOrderedNumber = objc_getAssociatedObject(self, (__bridge const void *)__SMFieldOrdererIsOrderableByFieldOrderer);
	return [isOrderedNumber boolValue];
}

- (void)setSkipOrderingByFieldOrderer:(BOOL)ordered
{
	objc_setAssociatedObject(self, (__bridge const void *)__SMFieldOrdererIsOrderableByFieldOrderer, @(ordered), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isOrderedByFieldOrderer
{
	NSNumber *isOrderedNumber = objc_getAssociatedObject(self, (__bridge const void *)__SMFieldOrdererIsOrderedByFieldOrderer);
	return [isOrderedNumber boolValue];
}

- (void)setIsOrderedByFieldOrderer:(BOOL)ordered
{
	objc_setAssociatedObject(self, (__bridge const void *)__SMFieldOrdererIsOrderedByFieldOrderer, @(ordered), OBJC_ASSOCIATION_RETAIN);
}

@end
