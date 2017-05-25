//
//  BUMWorkingCopyDocument.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMWorkingCopyDocument.h"
#import "BUMIssueListViewController.h"
#import "bugmatic.hpp"


using namespace bugmatic;


@interface BUMWorkingCopyDocument ()
{
	working_copy	_workingCopy;
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
	BUMIssueListViewController *rootViewController = (BUMIssueListViewController*) workingCopyWindowController.contentViewController;
	rootViewController.workingCopy = &_workingCopy;
}


- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	if( !url.isFileURL )
		return NO;

	_workingCopy.set_path( std::string(url.path.UTF8String) );
	
	return YES;
}


- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
	return YES;
}

@end
