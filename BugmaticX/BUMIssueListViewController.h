//
//  BUMIssueListViewController.h
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#if __cplusplus
#import "bugmatic.hpp"
#endif


@interface BUMIssueListViewController : NSViewController

@property IBOutlet NSTableView	*issuesTable;

#if __cplusplus
@property bugmatic::working_copy *workingCopy;
#endif

-(void) workingCopyChanged;

@end

