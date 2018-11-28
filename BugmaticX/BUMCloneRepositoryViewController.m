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

-(void) saveFieldContents
{
	NSString * userName = self.usernameTextField.stringValue;
	if (userName.length > 0 && self.passwordTextField.stringValue.length > 0)
	{
		NSDictionary * secItemInfo = @{
									   (__bridge NSString *)kSecAttrService: @"github.com",
									   (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
									   (__bridge NSString *)kSecAttrAccount: userName,
									   (__bridge NSString *)kSecValueData: [self.passwordTextField.stringValue dataUsingEncoding: NSUTF8StringEncoding]
									   };
		SecItemDelete( (__bridge CFDictionaryRef) secItemInfo );
		SecItemAdd( (__bridge CFDictionaryRef) secItemInfo, NULL );
	}

	[NSUserDefaults.standardUserDefaults setObject: self.projectNameField.stringValue forKey: BUMLastClonedProjectName];
	[NSUserDefaults.standardUserDefaults setObject: self.projectAccountNameField.stringValue forKey: BUMLastClonedProjectAccountName];
	[NSUserDefaults.standardUserDefaults setObject: self.destinationPathTextField.stringValue forKey: BUMLastClonedDestinationPath];
	[NSUserDefaults.standardUserDefaults setObject: userName forKey: BUMLastClonedUsername];
}


-(void)	viewDidLoad
{
    [super viewDidLoad];
	
	NSString * userName = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedUsername] ?: @"";
	
	self.projectNameField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedProjectName] ?: @"";
	self.projectAccountNameField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedProjectAccountName] ?: @"";
	self.destinationPathTextField.stringValue = [NSUserDefaults.standardUserDefaults objectForKey: BUMLastClonedDestinationPath] ?: [@"~/" stringByExpandingTildeInPath];
	self.usernameTextField.stringValue = userName;

	if( userName.length > 0 )
	{
		NSDictionary * secItemInfo = @{
									   (__bridge NSString *)kSecAttrService: @"github.com",
									   (__bridge NSString *)kSecClass: (__bridge NSString *)kSecClassGenericPassword,
									   (__bridge NSString *)kSecAttrAccount: userName,
									   (__bridge NSString *)kSecReturnData: @YES,
									   (__bridge NSString *)kSecMatchLimit: (__bridge NSString *)kSecMatchLimitOne
									   };
		CFTypeRef outData = NULL;
		if (SecItemCopyMatching( (__bridge CFDictionaryRef) secItemInfo, &outData ) == noErr)
		{
			NSData * theData = (__bridge_transfer NSData*)outData;
			NSString *passwordString = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
			if (passwordString)
			{
				self.passwordTextField.stringValue = passwordString;
			}
		}
	}
}


-(IBAction) clone: (id)sender
{
	[self saveFieldContents];
	
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
