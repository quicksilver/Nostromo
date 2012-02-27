//
//  QSNostromoPrefPane.h
//  Nostromo
//
//  Created by Rob McBroom on 2012/02/27.
//

#import <QSInterface/QSInterface.h>

@interface QSNostromoPrefPane : QSPreferencePane
{
	NSDictionary *themes;
	IBOutlet NSPopUpButton *themePicker;
}
- (IBAction)setNostromoTheme:(id)sender;
@end
