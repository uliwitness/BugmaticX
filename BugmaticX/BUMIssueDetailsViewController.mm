//
//  BUMIssueDetailsViewController.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMIssueDetailsViewController.h"
#import "bugmatic.hpp"


using namespace bugmatic;
using namespace std;


@interface BUMIssueDetailsViewController ()
{
	issue_info _issueInfo;
}

@property NSString * issueTitle;
@property NSString * issueBody;

@end

@implementation BUMIssueDetailsViewController

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
	_issueInfo.set_title( string(inText.UTF8String) );
}


-(NSString*) issueBody
{
	return [NSString stringWithUTF8String: _issueInfo.body().c_str()];
}

-(void) setIssueBody: (NSString*)inText
{
	_issueInfo.set_body( string(inText.UTF8String) );
}

@end
