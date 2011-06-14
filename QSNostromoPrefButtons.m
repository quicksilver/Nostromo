//
//  QSNostromoPrefButtons.m
//  Nostromo
//
//  Created by Rob McBroom on 2011/6/10.
//

#import "QSNostromoPrefButtons.h"

@implementation QSNostromoPrefButtons

- (IBAction)setRecommendedColors:(id)sender
{
    // load colors from a file and set them in Quicksilver's preferences
    NSDictionary *nostromoColors = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle bundleWithIdentifier:@"com.qsapp.Quicksilver.NostromoInterface"] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/QSNostromoColors.plist"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *colorKey in [nostromoColors allKeys]) {
        [defaults setObject:[nostromoColors objectForKey:colorKey] forKey:colorKey];
    }
    [defaults synchronize];
}

@end
