//
//  GHSidebarMenuCell.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHMenuCell.h"


#pragma mark -
#pragma mark Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

#pragma mark -
#pragma mark Implementation
@implementation GHMenuCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
        
        
        // Background Color
        // Selected Background Color
        // Text Color
        // Text Shadow Color
        // Top Line Color
        // Top Line Color 2
        // Bottom Line Color
        
        // The palate that came with the project.
        NSArray *defaultPalate = @[
            [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(38.0f/255.0f) green:(44.0f/255.0f) blue:(58.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f],
            [UIColor colorWithWhite:0.0f alpha:0.25f],
            [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f],
            [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f]
        ];
        
        NSArray *obnoxiousPalate = @[
            [UIColor whiteColor],
            [UIColor yellowColor],
            [UIColor blackColor],
            [UIColor redColor],
            [UIColor orangeColor],
            [UIColor greenColor],
            [UIColor purpleColor]
        ];
        
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:(a/255.0)];
#define RGB(r, g, b) RGBA(r, g, b, 255);
        
        NSArray *testPalate1 = @[
        [UIColor colorWithWhite:.65 alpha:1.0],
        [UIColor colorWithWhite:.3 alpha:1.0],
        [UIColor colorWithWhite:1.0 alpha:1.0],
        [UIColor colorWithWhite:0.0f alpha:0.5f],
        [UIColor colorWithWhite:.80 alpha:1.0],//[UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(76.0f/255.0f) alpha:1.0f],
        [UIColor colorWithWhite:.70 alpha:1.0],//[UIColor colorWithRed:(54.0f/255.0f) green:(61.0f/255.0f) blue:(77.0f/255.0f) alpha:1.0f],
        [UIColor colorWithWhite:.3 alpha:1.0]//[UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f]
        ];
        
        NSArray *colorPalate = testPalate1;//obnoxiousPalate;//defaultPalate;
        
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [colorPalate objectAtIndex:0];
        self.backgroundView = bgView;
        
		
        bgView = [[UIView alloc] init];
		bgView.backgroundColor = [colorPalate objectAtIndex:1];
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.textColor = [colorPalate objectAtIndex:2];
		self.textLabel.shadowColor = [colorPalate objectAtIndex:3];
		
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [colorPalate objectAtIndex:4];
		[self.textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [colorPalate objectAtIndex:5];
		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		bottomLine.backgroundColor = [colorPalate objectAtIndex:6];
		[self.textLabel.superview addSubview:bottomLine];
	}
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    
//    CGFloat totalWidth = self.frame.size.width - 10;
    
    if (self.imageView.image)
    {
        self.textLabel.frame = CGRectMake(50.0f, 0.0f, 200.0f, 43.0f);
        self.imageView.frame = CGRectMake(0.0f, 0.0f, 50.0f, 43.0f);
    } else {
        self.textLabel.frame = CGRectMake(15.0f, 0.0f, 250.0f, 43.0f);
        self.imageView.frame = CGRectMake(0.0f, 0.0f, 0.0f, 43.0f);
    }
}

@end
