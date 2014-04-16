//
//  GHMenuViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 1/3/12.
//  Copyright (c) 2012 Greg Haines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHMenuCell.h"
#import "GHMenuItem.h"

@class GHRevealViewController;

@interface GHMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
@private
	GHRevealViewController *_sidebarVC;
	UISearchBar *_searchBar;
	UITableView *_menuTableView;
    
    NSArray *_sections;
    
    
    // Obsolete:
//	NSArray *_headers;
//	NSArray *_controllers;
//	NSArray *_cellInfos;
    
    
}

@property NSArray *sections;
@property UIView *footer;

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC
					  withSearchBar:(UISearchBar *)searchBar
                           sections:(NSArray *)itemSections;

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC withHeader:(UIView *)header headerIsFixed:(BOOL)fixedHeader sections:(NSArray *)itemSections;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath 
					animated:(BOOL)animated 
			  scrollPosition:(UITableViewScrollPosition)scrollPosition;

-(void)setHighlightedIndexPath:(NSIndexPath *)indexPath;
-(void)setHighlightedIndexPath:(NSIndexPath *)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
