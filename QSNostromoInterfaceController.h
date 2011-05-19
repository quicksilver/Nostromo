//
//  QSNostromoInterfaceController.h
//  Nostromo
//
//  Created by Eric Doughty-Papassideris on 29/04/2011.
//

#import <Cocoa/Cocoa.h>
#import <QSFoundation/QSFoundation.h>
#import <QSCore/QSCore.h>
#import <QSInterface/QSResizingInterfaceController.h>

@interface QSNostromoInterfaceController : QSResizingInterfaceController {
    NSRect standardRect;
    NSRect standardIObjectRect;
    CGFloat heightDifference;
}

- (NSRect) rectForState:(BOOL)shouldExpand;
@end
