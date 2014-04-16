//
//  GHMenuViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 1/3/12.
//  Copyright (c) 2012 Greg Haines. All rights reserved.
//

#import "GHMenuViewController.h"
#import "GHMenuCell.h"
#import "GHRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark Implementation

@interface GHMenuViewController ()
{
    NSIndexPath *activeIndexPath;
    UIView *_header;
    BOOL _fixedHeader;
    
    UIView *_footer;
}
@end

@implementation GHMenuViewController

@synthesize sections=_sections;



#pragma mark Memory Management

- (GHMenuItem *)menuItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= self.sections.count)
        return nil;
    if (indexPath.row >= [[self.sections objectAtIndex:indexPath.section] items].count)
        return nil;
    
    return (GHMenuItem *)[[[self.sections objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row];
}

- (void)showViewControllerForMenuItem:(GHMenuItem *)item;
{
    if (item == nil) return;
    if (item.viewControllerStyle == GHMenuItemViewControllerStyleNone)
        return;
    
    if (item.viewControllerStyle == GHMenuItemViewControllerStyleSegue)
    {
        UIViewController *target = _sidebarVC;
        [target performSegueWithIdentifier:item.segue sender:target];
    } else if (item.viewControllerStyle == GHMenuItemViewControllerStyleViewController)
    {
        _sidebarVC.contentViewController = item.viewController;
        [_sidebarVC toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
    }
}

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC withSearchBar:(UISearchBar *)searchBar sections:(NSArray *)itemSections
{
	if (self = [super initWithNibName:nil bundle:nil]) {
		_sidebarVC = sidebarVC;
		_searchBar = searchBar;
        _sections = itemSections;
		
		_sidebarVC.sidebarViewController = self;
        [self showViewControllerForMenuItem:[self menuItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    return self;
}

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC withHeader:(UIView *)header headerIsFixed:(BOOL)fixedHeader sections:(NSArray *)itemSections
{
    if (self = [super initWithNibName:nil bundle:nil]) {
		_sidebarVC = sidebarVC;
        _sections = itemSections;
        
        _header = header;
        _fixedHeader = fixedHeader;
		
		_sidebarVC.sidebarViewController = self;
        [self showViewControllerForMenuItem:[self menuItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
    return self;
}


#pragma mark UIViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
    UIColor *bgColor;// = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
    
    bgColor = [UIColor colorWithRed:.1f green:.1f blue:.1f alpha:1.0f];
//    bgColor = [UIColor colorWithRed:.78f green:.78f blue:.78f alpha:1.0];
    self.view.backgroundColor = bgColor;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:_searchBar];
	
    bool hasSearchBar = (_searchBar != nil);
    
    CGFloat barOffset = hasSearchBar ? 44.0 : 0.0;
    
    if (_header)
    {
        if (_fixedHeader)
        {
            CGRect b = _header.frame;
            b.origin.y = 0;
            b.size.width = kGHRevealSidebarWidth;
            _header.frame = b;
            [self.view addSubview:_header];
            
            barOffset += b.size.height;
        } 
    }
    
	_menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, barOffset, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds) - barOffset)
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = [UIColor clearColor];
	_menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    if (_header && !_fixedHeader)
    {
        _menuTableView.tableFooterView = _header;
    }

//    if (self.footer)
//    {
//        CGRect frame = self.footer.frame;
//        frame.size.width = _menuTableView.frame.size.width;
//        frame.origin.x = 0;
//        frame.origin.y = self.view.bounds.size.height - frame.size.height;
//        self.footer.frame = frame;
//        
//        frame = _menuTableView.frame;
//        frame.size.height -= self.footer.frame.size.height;
//        _menuTableView.frame = frame;
//        
//        [self.view addSubview:self.footer];
//    }

	[self.view addSubview:_menuTableView];
    
    
    if (self.sections.count > 0 && ([[self.sections objectAtIndex:0] items].count > 0))
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

-(UIView *)footer
{
    return _footer;
}

-(void)setFooter:(UIView *)footer
{
    if (_footer)
        [_footer removeFromSuperview];
    
    _footer = footer;
    
    CGRect frame = self.footer.frame;
    frame.size.width = _menuTableView.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    self.footer.frame = frame;
    
    CGFloat difference = frame.origin.y - (_menuTableView.frame.origin.y + _menuTableView.frame.size.height);
    
    frame = _menuTableView.frame;
    frame.size.height += difference;
    _menuTableView.frame = frame;
    
    [self.view addSubview:self.footer];
}

- (void)viewWillAppear:(BOOL)animated {
	self.view.frame = CGRectMake(0.0f, 0.0f,kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	[_searchBar sizeToFit];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
		? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		: YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] items].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GHMenuItem *item = [self menuItemAtIndexPath:indexPath];
    
    bool isSelected = ([indexPath isEqual:activeIndexPath]);
    
    NSString *CellIdentifier = (isSelected) ? @"GHMenuCellActive" : @"GHMenuCell";
    
    GHMenuCell *cell = (GHMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (isSelected)
        {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:cell.textLabel.font.pointSize];
//            UIFont *f = [UIFont boldSystemFontOfSize:cell.textLabel.font.]
        }
    }
    
	cell.textLabel.text = item.label;
    cell.imageView.image = item.image;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *header = [[_sections objectAtIndex:section] header];
    BOOL isEmpty = (header == nil) || (header.length == 0);
	return (isEmpty) ? 0.0f : 21.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerText = [[_sections objectAtIndex:section] header];
    BOOL isEmpty = (headerText == nil) || (headerText.length == 0);
	UIView *headerView = nil;
	if (!isEmpty) {
        
        // Back Gradient Top
        // Back Gradient Bottom
        // Text Color
        // Text Shadow Color
        // Top Line
        // Bottom Line
        
        NSArray *defaultPalate = @[
            [UIColor colorWithRed:(67.0f/255.0f) green:(74.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(57.0f/255.0f) green:(64.0f/255.0f) blue:(82.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(125.0f/255.0f) green:(129.0f/255.0f) blue:(146.0f/255.0f) alpha:1.0f],
            [UIColor colorWithWhite:0.0f alpha:0.25f],
            [UIColor colorWithRed:(78.0f/255.0f) green:(86.0f/255.0f) blue:(103.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(36.0f/255.0f) green:(42.0f/255.0f) blue:(5.0f/255.0f) alpha:1.0f]
        ];
        
        NSArray *obnoxiousPalate = @[
            [UIColor colorWithRed:168/255.0 green:235/255.0 blue:155/255.0 alpha:1],//[UIColor colorWithRed:126/255.0 green:217/255.0 blue:108/255.0 alpha:1],
            [UIColor colorWithRed:112/255.0 green:191/255.0 blue:96/255.0 alpha:1],
            [UIColor whiteColor],
            [UIColor colorWithRed:20/255.0 green:110/255.0 blue:0 alpha:1],
            [UIColor whiteColor],//[UIColor colorWithRed:168/255.0 green:235/255.0 blue:155/255.0 alpha:1],
            [UIColor colorWithRed:10/255.0 green:60/255.0 blue:0 alpha:1]
        ];
        
        NSArray *colorPalate = obnoxiousPalate;
        //defaultPalate;
        
        
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 21.0f)];
		CAGradientLayer *gradient = [CAGradientLayer layer];
		gradient.frame = headerView.bounds;
		gradient.colors = @[
			(id)[[colorPalate objectAtIndex:0] CGColor],
			(id)[[colorPalate objectAtIndex:1] CGColor]
		];
		[headerView.layer insertSublayer:gradient atIndex:0];
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 12.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:([UIFont systemFontSize] * 0.8f)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.textColor = [colorPalate objectAtIndex:2];
		textLabel.shadowColor = [colorPalate objectAtIndex:3];
		textLabel.backgroundColor = [UIColor clearColor];
		[headerView addSubview:textLabel];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [colorPalate objectAtIndex:4];
		[headerView addSubview:topLine];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 21.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [colorPalate objectAtIndex:5];
		[headerView addSubview:bottomLine];
	}
	return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showViewControllerForMenuItem:[self menuItemAtIndexPath:indexPath]];
	
    [self setHighlightedIndexPath:indexPath];
}

#pragma mark Public Methods
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
	[_menuTableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
	if (scrollPosition == UITableViewScrollPositionNone) {
		[_menuTableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
	}
    [self showViewControllerForMenuItem:[self menuItemAtIndexPath:indexPath]];

    [self setHighlightedIndexPath:indexPath];
}

-(void)setHighlightedIndexPath:(NSIndexPath *)indexPath
{
    [self setHighlightedIndexPath:indexPath scrollPosition:UITableViewScrollPositionNone];
}

-(void)setHighlightedIndexPath:(NSIndexPath *)indexPath scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    if (indexPath == nil)
    {
        NSIndexPath *path = activeIndexPath;
        activeIndexPath = nil;
        
        [_menuTableView beginUpdates];
        [_menuTableView reloadRowsAtIndexPaths:@[ path ] withRowAnimation:UITableViewRowAnimationNone];
        [_menuTableView endUpdates];
        
        return;
    }
    
    NSIndexPath *oldActiveIndexPath = activeIndexPath;
    [_menuTableView beginUpdates];
    activeIndexPath = indexPath;
    if (oldActiveIndexPath)
        [_menuTableView reloadRowsAtIndexPaths:@[oldActiveIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // If the old and new are the same, don't try to reload the same index path twice.
    if (activeIndexPath && !([activeIndexPath isEqual:oldActiveIndexPath]))
        [_menuTableView reloadRowsAtIndexPaths:@[activeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [_menuTableView endUpdates];
    [_menuTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:scrollPosition];
}

@end
