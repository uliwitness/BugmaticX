//
//  BUMIssueListViewController.m
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import "BUMIssueListViewController.h"
#include <vector>


using namespace bugmatic;
using namespace std;


@interface BUMIssueListViewController () <NSTableViewDataSource,NSTableViewDelegate>
{
	working_copy *_workingCopy;
	vector<issue_info> _issues;
}

-(IBAction)	issueRowDoubleClicked: (id)sender;

@end


@implementation BUMIssueListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	if (_workingCopy) {
		std::vector<std::string>	whereClauses;
		_issues.clear();
		_workingCopy->list( whereClauses, [self](issue_info theIssue) {
			_issues.push_back( theIssue );
			[self.issuesTable noteNumberOfRowsChanged];
		});
	}
}


-(void) setWorkingCopy: (working_copy*)inWC
{
	_workingCopy = inWC;
	
	if( _workingCopy ) {
		std::vector<std::string>	whereClauses;
		_issues.clear();
		_workingCopy->list( whereClauses, [self](issue_info theIssue) {
			_issues.push_back( theIssue );
			[self.issuesTable noteNumberOfRowsChanged];
		});
	}
}


-(working_copy*) workingCopy
{
	return _workingCopy;
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return _issues.size();
}


- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
	if( [tableColumn.identifier isEqualToString: @"issue_number"] ) {
		return @(_issues[row].issue_number());
	} else {
		return [NSString stringWithUTF8String: _issues[row].title().c_str()];
	}
}


-(IBAction)	issueRowDoubleClicked: (id)sender
{
	NSIndexSet *rowIndexes = self.issuesTable.selectedRowIndexes;
	if( rowIndexes.count > 1 ) {
		
	} else if( rowIndexes.count == 1 ) {
		
	}
}

@end