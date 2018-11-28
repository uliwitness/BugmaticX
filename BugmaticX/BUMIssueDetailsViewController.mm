//
//  BUMIssueDetailsViewController.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMIssueDetailsViewController.h"
#import "bugmatic.hpp"
#include <vector>


using namespace bugmatic;
using namespace std;


@interface BUMIssueDetailsViewController ()
{
	issue_info _issueInfo;
}

@property IBOutlet NSStackView * commentsStackView;

@property NSString * issueTitle;
@property NSString * issueBody;

@end

@implementation BUMIssueDetailsViewController

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	for( comment_info currComment : _issueInfo.comments() ) {
		NSTextField * commentField = [[NSTextField alloc] initWithFrame: NSZeroRect];
		commentField.translatesAutoresizingMaskIntoConstraints = NO;
		commentField.lineBreakMode = NSLineBreakByWordWrapping;
		commentField.preferredMaxLayoutWidth = 500;
		commentField.stringValue = [NSString stringWithUTF8String: currComment.body().c_str()];
		[commentField sizeToFit];
		[commentField setContentCompressionResistancePriority: NSLayoutPriorityDragThatCannotResizeWindow forOrientation: NSLayoutConstraintOrientationHorizontal];
		[commentField setContentCompressionResistancePriority: NSLayoutPriorityDragThatCanResizeWindow forOrientation: NSLayoutConstraintOrientationVertical];
		[self.commentsStackView addArrangedSubview: commentField];
	}
}

-(void)	setIssueInfo: (issue_info)inInfo
{
	_issueInfo = inInfo;
	
	self.title = [NSString stringWithFormat: @"%d: %@", _issueInfo.issue_number(), [NSString stringWithUTF8String: _issueInfo.title().c_str()]];
}


-(issue_info) issueInfo
{
	return _issueInfo;
}


-(NSString*) issueTitle
{
	return [NSString stringWithUTF8String: _issueInfo.title().c_str()];
}


-(void) setIssueTitle: (NSString*)inText
{
	_issueInfo.set_title( string(inText.UTF8String) ); // TODO: Write issue_info back to repo?
}


-(NSString*) issueBody
{
	return [NSString stringWithUTF8String: _issueInfo.body().c_str()];
}

-(void) setIssueBody: (NSString*)inText
{
	_issueInfo.set_body( string(inText.UTF8String) ); // TODO: Write issue_info back to repo?
}

@end
