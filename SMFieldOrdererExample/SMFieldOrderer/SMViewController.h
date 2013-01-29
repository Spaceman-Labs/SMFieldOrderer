//
//  SMViewController.h
//  SMFieldOrderer
//
//  Created by Jerry Jones on 1/29/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMFieldOrderer.h"

@interface SMViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet SMFieldOrderer *orderer;

@property (nonatomic, strong) IBOutlet UITextField *field0;
@property (nonatomic, strong) IBOutlet UITextField *field4;

@end
