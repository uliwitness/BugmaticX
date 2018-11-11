//
//  BUMCloneRepositoryViewController.h
//  BugmaticX
//
//  Created by Uli Kusterer on 11.11.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUMCloneRepositoryViewController : NSViewController

@property (weak) IBOutlet NSTextField *projectNameField;
@property (weak) IBOutlet NSTextField *projectAccountNameField;
@property (weak) IBOutlet NSTextField *destinationPathTextField;
@property (weak) IBOutlet NSTextField *usernameTextField;
@property (weak) IBOutlet NSSecureTextField *passwordTextField;
@property (weak) IBOutlet NSProgressIndicator *cloneProgressSpinner;
@property (weak) IBOutlet NSButton *cancelButton;
@property (weak) IBOutlet NSButton *okButton;

@end

NS_ASSUME_NONNULL_END
