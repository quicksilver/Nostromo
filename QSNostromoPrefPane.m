//
//  QSNostromoPrefPane.m
//  Nostromo
//
//  Created by Rob McBroom on 2012/02/27.
//

#import "QSNostromoPrefPane.h"

@implementation QSNostromoPrefPane

- (void)awakeFromNib
{
	themes = [[NSArray alloc] initWithObjects:@"Nostromo Default", @"Shiny", @"Solarized Light", @"The Hulk", nil];
	[themePicker removeAllItems];
	[themePicker addItemsWithTitles:themes];
}

- (void)dealloc
{
    [themes release];
    [super dealloc];
}

- (IBAction)setNostromoTheme:(id)sender {
    // load colors from a file and set them in Quicksilver's preferences
	NSString *themeKey = [[[themePicker selectedItem] title] stringByReplacingOccurrencesOfString:@" " withString:@""];
	NSString *themePath = [NSString stringWithFormat:@"Contents/Resources/%@.plist", themeKey];
	//NSLog(@"setting theme using plist: %@", [themes objectForKey:themeKey]);
    NSDictionary *nostromoColors = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle bundleWithIdentifier:@"com.qsapp.Quicksilver.NostromoInterface"] bundlePath] stringByAppendingPathComponent:themePath]];
	if (nostromoColors) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		for (NSString *colorKey in [nostromoColors allKeys]) {
			[defaults setObject:[nostromoColors objectForKey:colorKey] forKey:colorKey];
		}
		[defaults synchronize];
	} else {
		NSBeep();
	}
}
@end
