//
//  BUMIssueDetailsViewController.h
//  BugmaticX
//
//  Created by Uli Kusterer on 25.05.17.
//  Copyright © 2017 Uli Kusterer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#if __cplusplus
#import "bugmatic.hpp"
#endif


@interface BUMIssueDetailsViewController : NSViewController

#if __cplusplus
@property bugmatic::issue_info issueInfo;
#endif

@end
