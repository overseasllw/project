//
//  GHSidebarViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHRevealViewController.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark -
#pragma mark Constants
const NSTimeInterval kGHRevealSidebarDefaultAnimationDuration = 0.25;
const CGFloat kGHRevealSidebarWidth = 245.0f;
const CGFloat kGHRevealSidebarFlickVelocity = 1000.0f;


#pragma mark -
#pragma mark Private Interface
@interface GHRevealViewController ()
{
    UIView *_tapView;
    NSMutableArray *_stack;
}

@property (nonatomic, readwrite, getter = isSidebarShowing) BOOL sidebarShowing;
@property (nonatomic, readwrite, getter = isSearching) BOOL searching;
@property (nonatomic, strong) UIView *searchView;
- (void)hideSidebar;

@end


#pragma mark -
#pragma mark Implementation
@implementation GHRevealViewController

#pragma mark Properties
@synthesize sidebarShowing;
@synthesize searching;
@synthesize sidebarViewController;
@synthesize contentViewController;
@synthesize searchView;

@synthesize mainContainerView, moveableView;
@synthesize defaultNavigationBarTint;

- (void)setSidebarViewController:(UIViewController *)svc {
	if (sidebarViewController == nil) {
		svc.view.frame = _sidebarView.bounds;
		sidebarViewController = svc;
		[self addChildViewController:sidebarViewController];
		[_sidebarView addSubview:sidebarViewController.view];
		[sidebarViewController didMoveToParentViewController:self];
	} else if (sidebarViewController != svc) {
		svc.view.frame = _sidebarView.bounds;
		[sidebarViewController willMoveToParentViewController:nil];
		[self addChildViewController:svc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:sidebarViewController 
						  toViewController:svc 
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{} 
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[sidebarViewController removeFromParentViewController];
									[svc didMoveToParentViewController:self];
									sidebarViewController = svc;
								}
		 ];
	}
}

- (void)setContentViewController:(UIViewController *)cvc {
    [self viewControllerWillBeShown:cvc];
    
    while (_stack.count)
    {
        [self popViewController:NO];
    }
    
	if (contentViewController == nil) {
		cvc.view.frame = _contentView.bounds;
		contentViewController = cvc;
		[self addChildViewController:contentViewController];
		[_contentView addSubview:contentViewController.view];
		[contentViewController didMoveToParentViewController:self];
	} else if (contentViewController != cvc) {
		cvc.view.frame = _contentView.bounds;
		[contentViewController willMoveToParentViewController:nil];
		[self addChildViewController:cvc];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:contentViewController 
						  toViewController:cvc 
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[contentViewController removeFromParentViewController];
									[cvc didMoveToParentViewController:self];
									contentViewController = cvc;
								}
		];
	}
}

#pragma mark Memory Management

- (void)initViewsAndStuff
{
    self.sidebarShowing = NO;
    self.searching = NO;
    _tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidebar)];
//    _tapRecog.
    _tapRecog.cancelsTouchesInView = YES;
    
    self.defaultNavigationBarTint = [UIColor yellowColor];
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    _sidebarView = [[UIView alloc] initWithFrame:self.view.bounds];
    _sidebarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _sidebarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sidebarView];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.layer.masksToBounds = NO;
    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _contentView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _contentView.layer.shadowOpacity = 1.0f;
    _contentView.layer.shadowRadius = 2.5f;
    _contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath;
    [self.view addSubview:_contentView];
    
    _stack = [[NSMutableArray alloc] init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self initViewsAndStuff];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //[self initViewsAndStuff];
    }
    return self;
}

-(void)viewDidLoad
{
    [self initViewsAndStuff];
    [super viewDidLoad];
}

#pragma mark - Q

- (void)setTapGestureActive:(BOOL)active
{
    if (active)
    {
        if (_tapView == nil)
        {
            _tapView = [[UIView alloc] init];
            _tapView.userInteractionEnabled = YES;
            _tapView.backgroundColor = [UIColor clearColor];
            
            [_tapView addGestureRecognizer:_tapRecog];
            [self addPanGestureToView:_tapView];
        }
        _tapView.frame = self.moveableView.bounds;
        [self.moveableView addSubview:_tapView];
    } else
    {
        [_tapView removeFromSuperview];
    }
}

- (void)showViewControllerSemiModal:(UIViewController *)controller
{
    controller.view.frame = CGRectMake(0, self.moveableView.bounds.size.height, self.moveableView.bounds.size.width, self.moveableView.bounds.size.height- 100);
    [self addChildViewController:controller];
    [self.moveableView addSubview:controller.view];
    if ([controller isKindOfClass:[UINavigationController class]])
        [self addPanGestureToView:((UINavigationController *)controller).navigationBar];
    [UIView animateWithDuration:.5 animations:^{
        self.moveableView.frame = CGRectMake(0, -1 * self.moveableView.frame.size.height, self.moveableView.frame.size.width, 2 * self.view.frame.size.height);
//        self.moveableView.frame = CGRectOffset(self.moveableView.frame, 0, -1 * self.moveableView.frame.size.height);
    }];
}

- (void)showViewControllerPushed:(UIViewController *)controller
{
    CGFloat dx = -1 * self.view.frame.size.width;
    [self addChildViewController:controller];
    controller.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.moveableView.frame.size.height);
    [self.moveableView addSubview:controller.view];
    if ([controller isKindOfClass:[UINavigationController class]])
        [self addPanGestureToView:((UINavigationController *)controller).navigationBar];
    else if ([controller isKindOfClass:[UITabBarController class]])
        [self addPanGestureToView:((UITabBarController *)controller).tabBar];
    
    [_stack addObject:controller];
    
    [UIView animateWithDuration:.35 animations:^{
        controller.view.frame = CGRectOffset(controller.view.frame, dx, 0);
//        for (UIView *view in self.moveableView.subviews)
//        {
//            view.frame = CGRectOffset(view.frame, dx, 0);
//        }
        
    } completion:^(BOOL finished) {
//        for (UIView *view in self.moveableView.subviews)
//        {
//            if (view != controller.view)
//                view.frame = CGRectOffset(view.frame, dx, 0);
//        }
    }];
}

- (void)popViewController:(BOOL)animated
{
    if (_stack.count == 0)
        return;
    UIViewController *controller = [_stack objectAtIndex:(_stack.count - 1)];
    [_stack removeObjectAtIndex:(_stack.count - 1)];
    
    if (!animated)
    {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
        return;
    }
    
    [UIView animateWithDuration:kGHRevealSidebarDefaultAnimationDuration animations:^{
        controller.view.frame = CGRectOffset(controller.view.frame, self.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }];
}

#pragma mark UIViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
		? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		: YES;
}

#pragma mark Public Methods

- (void)addPanGestureToView:(UIView *)view
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(dragContentView:)];
    panGesture.cancelsTouchesInView = YES;
    [view addGestureRecognizer:panGesture];
}

- (void)dragContentView:(UIPanGestureRecognizer *)panGesture {
	CGFloat translation = [panGesture translationInView:self.view].x;
	if (panGesture.state == UIGestureRecognizerStateChanged) {
		if (sidebarShowing) {
			if (translation > 0.0f) {
				self.moveableView.frame = CGRectOffset(self.moveableView.bounds, kGHRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else if (translation < -kGHRevealSidebarWidth) {
				self.moveableView.frame = self.moveableView.bounds;
				self.sidebarShowing = NO;
			} else {
				self.moveableView.frame = CGRectOffset(self.moveableView.bounds, (kGHRevealSidebarWidth + translation), 0.0f);
			}
		} else {
			if (translation < 0.0f) {
				self.moveableView.frame = self.moveableView.bounds;
				self.sidebarShowing = NO;
			} else if (translation > kGHRevealSidebarWidth) {
				self.moveableView.frame = CGRectOffset(self.moveableView.bounds, kGHRevealSidebarWidth, 0.0f);
				self.sidebarShowing = YES;
			} else {
				self.moveableView.frame = CGRectOffset(self.moveableView.bounds, translation, 0.0f);
			}
		}
	} else if (panGesture.state == UIGestureRecognizerStateEnded) {
		CGFloat velocity = [panGesture velocityInView:self.view].x;
		BOOL show = (fabs(velocity) > kGHRevealSidebarFlickVelocity)
			? (velocity > 0)
        //    : (self.sidebarShowing);
         : (fabs(translation) > (kGHRevealSidebarWidth / 2)) ^ (self.sidebarShowing);
        if (fabs(translation) >= kGHRevealSidebarWidth)
            show = self.sidebarShowing;
		[self toggleSidebar:show duration:kGHRevealSidebarDefaultAnimationDuration];
		
	}
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration {
	[self toggleSidebar:show duration:duration completion:^(BOOL finshed){}];
}

- (void)toggleSidebar:(BOOL)show duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	void (^animations)(void) = ^{
		if (show) {
			self.moveableView.frame = CGRectOffset(self.moveableView.bounds, kGHRevealSidebarWidth, 0.0f);
            [self setTapGestureActive:YES];
		} else {
			if (self.isSearching) {
				_sidebarView.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			} else {
                [self setTapGestureActive:NO];
			}
			self.moveableView.frame = self.moveableView.bounds;
		}
		self.sidebarShowing = show;
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:completion];
	} else {
		animations();
		completion(YES);
	}
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration {
	[self toggleSearch:showSearch withSearchView:srchView duration:duration completion:^(BOOL finished){}];
}

- (void)toggleSearch:(BOOL)showSearch withSearchView:(UIView *)srchView duration:(NSTimeInterval)duration completion:(void (^)(BOOL finsihed))completion {
	if (showSearch) {
		srchView.frame = self.view.bounds;
	} else {
		_sidebarView.alpha = 0.0f;
		_contentView.frame = CGRectOffset(self.view.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
		[self.view addSubview:_contentView];
	}
	void (^animations)(void) = ^{
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetWidth(self.view.bounds), 0.0f);
            [self setTapGestureActive:NO];
			[_sidebarView removeFromSuperview];
			self.searchView = srchView;
			[self.view insertSubview:self.searchView atIndex:0];
		} else {
			_sidebarView.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
			_sidebarView.alpha = 1.0f;
			[self.view insertSubview:_sidebarView atIndex:0];
			self.searchView.frame = _sidebarView.frame;
			_contentView.frame = CGRectOffset(_contentView.bounds, kGHRevealSidebarWidth, 0.0f);
		}
	};
	void (^fullCompletion)(BOOL) = ^(BOOL finished){
		if (showSearch) {
			_contentView.frame = CGRectOffset(_contentView.bounds, CGRectGetHeight([UIScreen mainScreen].bounds), 0.0f);
			[_contentView removeFromSuperview];
		} else {
            [self setTapGestureActive:YES];
			[self.searchView removeFromSuperview];
			self.searchView = nil;
		}
		self.sidebarShowing = YES;
		self.searching = showSearch;
		completion(finished);
	};
	if (duration > 0.0) {
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:animations
						 completion:fullCompletion];
	} else {
		animations();
		fullCompletion(YES);
	}
}

- (void)viewControllerWillBeShown:(UIViewController *)controller
{
    
}

#pragma mark Private Methods
- (void)hideSidebar {
	[self toggleSidebar:NO duration:kGHRevealSidebarDefaultAnimationDuration];
}

@end
