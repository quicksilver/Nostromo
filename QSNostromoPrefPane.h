//
//  QSNostromoPrefPane.h
//  Nostromo
//
//  Created by Rob McBroom on 2012/02/27.
//

#import <QSInterface/QSInterface.h>

@interface QSNostromoPrefPane : QSPreferencePane
{
	NSArray *themes;
	IBOutlet NSPopUpButton *themePicker;
    IBOutlet NSTextField *fontDisplay;
    NSFont *interfaceFont;
}
- (IBAction)setNostromoTheme:(id)sender;
- (IBAction)selectInterfaceFont:(id)sender;
@end
