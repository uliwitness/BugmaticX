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
#include <cmath>


using namespace bugmatic;
using namespace std;


struct BUMIssueDetailsViewControllerCppIVars
{
	issue_info &_issueInfo;
};


@interface BUMIssueDetailsViewController ()
{
	BUMIssueDetailsViewControllerCppIVars *_ivars;
}

@property IBOutlet NSStackView * commentsStackView;

@property NSString * issueTitle;
@property NSString * issueBody;

@end

@implementation BUMIssueDetailsViewController

-(void) dealloc
{
	delete _ivars;
}

-(void) viewDidLoad
{
	[super viewDidLoad];
	
	for( comment_info& currComment : _ivars->_issueInfo.comments() ) {
		[self addOneCommentField: currComment];
	}
}


-(void) addOneCommentField:(comment_info&)inComment
{
	NSTextField * commentField = [[NSTextField alloc] initWithFrame: NSZeroRect];
	commentField.translatesAutoresizingMaskIntoConstraints = NO;
	commentField.lineBreakMode = NSLineBreakByWordWrapping;
	commentField.preferredMaxLayoutWidth = 500;
	commentField.stringValue = [NSString stringWithUTF8String: inComment.body().c_str()];
	[commentField sizeToFit];
	[commentField setContentCompressionResistancePriority: NSLayoutPriorityDragThatCannotResizeWindow forOrientation: NSLayoutConstraintOrientationHorizontal];
	[commentField setContentCompressionResistancePriority: NSLayoutPriorityDragThatCanResizeWindow forOrientation: NSLayoutConstraintOrientationVertical];
	[self.commentsStackView insertArrangedSubview: commentField atIndex: (self.commentsStackView.arrangedSubviews.count > 0) ? (self.commentsStackView.arrangedSubviews.count -1UL) : 0UL];
}


-(void)	setIssueInfo: (issue_info&)inInfo
{
	if( !_ivars )
	{
		_ivars = new BUMIssueDetailsViewControllerCppIVars{ inInfo };
	}
	else
	{
		_ivars->_issueInfo = inInfo;
	}

	self.title = [NSString stringWithFormat: @"%d: %@", _ivars->_issueInfo.issue_number(), [NSString stringWithUTF8String: _ivars->_issueInfo.title().c_str()]];
}


-(issue_info&) issueInfo
{
	return _ivars->_issueInfo;
}


-(NSString*) issueTitle
{
	return [NSString stringWithUTF8String: _ivars->_issueInfo.title().c_str()];
}


-(void) setIssueTitle: (NSString*)inText
{
	_ivars->_issueInfo.set_title( string(inText.UTF8String) ); // TODO: Write issue_info back to repo?
}


-(NSString*) issueBody
{
	return [NSString stringWithUTF8String: _ivars->_issueInfo.body().c_str()];
}

-(void) setIssueBody: (NSString*)inText
{
	_ivars->_issueInfo.set_body( string(inText.UTF8String) ); // TODO: Write issue_info back to repo?
}

-(IBAction)addNewComment:(id)sender
{
	_ivars->_issueInfo.add_comment("New Comment");
	
	std::vector<comment_info> comments = _ivars->_issueInfo.comments();
	if( comments.size() > 0 )
	{
		[self addOneCommentField: comments.back()];
	}
}

@end
