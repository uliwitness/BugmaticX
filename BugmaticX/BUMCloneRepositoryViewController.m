//
//  BUMCloneRepositoryViewController.m
//  BugmaticX
//
//  Created by Uli Kusterer on 11.11.18.
//  Copyright © 2018 Uli Kusterer. All rights reserved.
//

#import "BUMCloneRepositoryViewController.h"


static NSString * BUMLastClonedProjectName = @"BUMLastClonedProjectName";
static NSString * BUMLastClonedProjectAccountName = @"BUMLastClonedProjectAccountName";
static NSString * BUMLastClonedDestinationPath = @"BUMLastClonedDestinationPath";
static NSString * BUMLastClonedUsername = @"BUMLastClonedUsername";

@implementation BUMCloneRepositoryViewController

-(void) dealloc
{
	[NSUserDefaults.standardUserDefaults setObject: self.projectNameField.stringValue forKey: BUMLastClonedProjectName];
	[NSUserDefaults.standardUserDefaults setObject: self.projectAccountNameField.stringValue forKey: BUMLastClonedProjectAccountName];
	[NSUserDefaults.standardUserDefaults setObject: self.destinationPathTextField.stringValue forKey: BUMLastClonedDestinationPath];
	[NSUserDefaults.standardUserDefaults setObject: self.usernameTextField.stringValue forKey: BUMLastClonedUsername];
}


-(void)	viewDidLoad
{
    [super viewDidLoad];
	
	self.projectNameField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedProjectName] ?: @"";
	self.projectAccountNameField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedProjectAccountName] ?: @"";
	self.destinationPathTextField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedDestinationPath] ?: [@"~/" stringByExpandingTildeInPath];
	self.usernameTextField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedUsername] ?: @"";
}


-(IBAction) clone: (id)sender
{
	self.okButton.enabled = NO;
	self.cancelButton.enabled = NO;
	[self.cloneProgressSpinner startAnimation: self];
	
	if( self.view.window.isSheet )
	{
		[self.view.window.sheetParent endSheet:self.view.window returnCode:NSModalResponseOK];
	}
	else
	{
		[NSApplication.sharedApplication stopModalWithCode: NSModalResponseOK];
	}
}


-(IBAction) cancel: (id)sender
{
	if( self.view.window.isSheet )
	{
		[self.view.window.sheetParent endSheet:self.view.window returnCode:NSModalResponseCancel];
	}
	else
	{
		[NSApplication.sharedApplication stopModalWithCode: NSModalResponseCancel];
	}
}

@end
