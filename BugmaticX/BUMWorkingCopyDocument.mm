//
//  BUMWorkingCopyDocument.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMWorkingCopyDocument.h"
#import "BUMIssueListViewController.h"
#import "BUMCloneRepositoryViewController.h"
#import "bugmatic.hpp"


using namespace bugmatic;


@interface BUMWorkingCopyDocument ()
{
	working_copy				_workingCopy;
	BUMIssueListViewController *_rootViewController;
}

@end

@implementation BUMWorkingCopyDocument

- (instancetype)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
    }
    return self;
}


+ (BOOL)autosavesInPlace
{
	return YES;
}


- (void)makeWindowControllers
{
	NSWindowController *workingCopyWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"];
	[self addWindowController: workingCopyWindowController];
	_rootViewController = (BUMIssueListViewController*) workingCopyWindowController.contentViewController;
	_rootViewController.workingCopy = &_workingCopy;
}


- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	if( !url.isFileURL )
		return NO;

	_workingCopy.set_path( std::string(url.path.UTF8String) );
	_workingCopy.set_change_handler( [self](working_copy& wc)
	{
		[_rootViewController workingCopyChanged];
	});
	
	return YES;
}


- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	return YES;
}


-(IBAction) createNewIssue: (id)sender
{
	_workingCopy.new_issue("New Issue", "Issue text here.");
}


-(IBAction) pushToGithub: (id)sender
{
	NSStoryboard * mainStoryboard = [NSStoryboard storyboardWithName: @"Main" bundle: NSBundle.mainBundle];
	NSWindowController * cloneWC = [mainStoryboard instantiateControllerWithIdentifier: @"PushToRepository"];
	[cloneWC window];
	
	BUMCloneRepositoryViewController * cloneVC = (BUMCloneRepositoryViewController *) cloneWC.contentViewController;
	
	[_rootViewController.view.window beginSheet:cloneWC.window completionHandler:^(NSModalResponse returnCode)
	{
		if( returnCode == NSModalResponseOK )
		{
			try {
				remote 			theRemote( cloneVC.projectNameField.stringValue.UTF8String, cloneVC.projectAccountNameField.stringValue.UTF8String, cloneVC.usernameTextField.stringValue.UTF8String, cloneVC.passwordTextField.stringValue.UTF8String );
				
				_workingCopy.push(theRemote);
			}
			catch( std::exception& err )
			{
				[NSApplication.sharedApplication presentError:[NSError errorWithDomain:@"BUMCppErrorDomain" code:1 userInfo:@{ NSLocalizedDescriptionKey: @(err.what()) }]];
			}
		}
		
		[cloneWC close];
	}];
}

@end
