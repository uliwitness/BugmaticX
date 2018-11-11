//
//  BUMAppDelegate.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMAppDelegate.h"
#import "BUMCloneRepositoryViewController.h"

#include "bugmatic.hpp"
#include <string>


using namespace bugmatic;


@interface BUMAppDelegate ()
{
	dispatch_queue_t _dispatchQueue;
}

@end

@implementation BUMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_dispatchQueue = dispatch_queue_create( "com.thevoidsoftware.bugmatic", DISPATCH_QUEUE_SERIAL );
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	// Insert code here to tear down your application
}


-(IBAction) cloneIssueDatabase: (id)sender
{
	NSStoryboard * mainStoryboard = [NSStoryboard storyboardWithName: @"Main" bundle: NSBundle.mainBundle];
	NSWindowController * cloneWC = [mainStoryboard instantiateControllerWithIdentifier: @"CloneRepository"];
	[cloneWC showWindow: self];
	
	BUMCloneRepositoryViewController * cloneVC = (BUMCloneRepositoryViewController *) cloneWC.contentViewController;
	
	NSModalResponse response = [NSApplication.sharedApplication runModalForWindow: cloneWC.window];
	if( response == NSModalResponseOK )
	{
		[self checkOutProject: cloneVC.projectNameField.stringValue inAccount: cloneVC.projectAccountNameField.stringValue toPath: cloneVC.destinationPathTextField.stringValue withUsername: cloneVC.usernameTextField.stringValue password: cloneVC.passwordTextField.stringValue completionHandler:
		 ^{
			 [cloneWC close];
		 }];
	}
	else
	{
		[cloneWC close];
	}
}


-(void) checkOutProject: (NSString *)inProject inAccount: (NSString *)inAccount toPath: (NSString *)inPath withUsername: (NSString *)inUsername password: (NSString *)inPassword completionHandler: (void(^)(void))completionHandler
{
	NSString * destinationPath = [inPath stringByAppendingPathComponent: inProject];
	[NSFileManager.defaultManager createDirectoryAtPath: destinationPath withIntermediateDirectories: NO attributes: nil error: NULL];
	
	dispatch_async(_dispatchQueue, ^()
	{
		working_copy	wc;
		remote 			theRemote( inProject.UTF8String, inAccount.UTF8String, inUsername.UTF8String, inPassword.UTF8String );
		
		wc.set_path( destinationPath.UTF8String );
		wc.clone(theRemote);
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completionHandler();
			
			[self openRepositoryAtURL: [NSURL fileURLWithPath: destinationPath]];
		});
	} );
}


-(void)	openRepositoryAtURL: (NSURL *)inURL
{
	[NSDocumentController.sharedDocumentController openDocumentWithContentsOfURL: inURL display: YES completionHandler:
	 ^(NSDocument * _Nullable document, BOOL documentWasAlreadyOpen, NSError * _Nullable error)
	 {
		 if( error )
		 {
			 [NSApplication.sharedApplication presentError: error];
		 }
	 }];
}


-(IBAction)	openDocument:(id)sender
{
	NSOpenPanel	* folderOpenPanel = [NSOpenPanel openPanel];
	folderOpenPanel.canChooseDirectories = YES;
	folderOpenPanel.canChooseFiles = YES;
	[folderOpenPanel beginWithCompletionHandler:
	 ^( NSModalResponse result )
	 {
		 if( result == NSModalResponseCancel )
		 {
			 return;
		 }
		 
		 __block BOOL alreadyShowedOneError = NO;
		 
		 for( NSURL * currURL in folderOpenPanel.URLs )
		 {
			 [NSDocumentController.sharedDocumentController openDocumentWithContentsOfURL: currURL display: YES completionHandler:
			  ^(NSDocument * _Nullable document, BOOL documentWasAlreadyOpen, NSError * _Nullable error)
			  {
				  if( error && !alreadyShowedOneError ) // Don't stack up error dialogs like crazy.
				  {
					  alreadyShowedOneError = YES;
					  [NSApplication.sharedApplication presentError: error];
				  }
			  }];
		 }
	 }];
}

@end
