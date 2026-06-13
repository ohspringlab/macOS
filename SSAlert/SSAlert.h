//********* SSAlert.h ******************

#import <Cocoa/Cocoa.h>


@interface SSAlert : NSObject {
    NSButton* helpButton ;
    NSString* helpButtonAnchor ;
    NSButton* checkbox ;
    NSPanel* panel ;
}

@property (nonatomic,strong) NSButton* helpButton ;
@property (nonatomic,strong) NSString* helpButtonAnchor ;
@property (nonatomic,strong) NSButton* checkbox ;
@property (nonatomic,strong) NSPanel* panel ;

+ (void)runModalBadgeCritical:(BOOL)critical
                   bigTopText:(NSString*)bigTopText
              smallBottomText:(NSString*)smallBottomText
           defaultButtonTitle:(NSString*)defaultButtonTitle
              leftButtonTitle:(NSString*)leftButtonTitle
            middleButtonTitle:(NSString*)middleButtonTitle
             helpButtonAnchor:(NSString*)helpButtonAnchor
                checkboxTitle:(NSString*)checkboxTitle
                checkboxState:(NSCellStateValue*)checkboxState
                  alertReturn:(int*)alertReturn ;
@end

/* Any or all of the arguments can be nil or NULL.  Default usage:
[SSAlert runModalBadgeCritical:NO
                    bigTopText:nil
               smallBottomText:nil
            defaultButtonTitle:nil
               leftButtonTitle:nil
             middleButtonTitle:nil
              helpButtonAnchor:nil
                 checkboxTitle:nil
                 checkboxState:NULL
                   alertReturn:NULL ];
*/

/* helpButtonAnchor requires that the applications Help Book contains
a tag, which in this case would be something like:
<a name="helpButtonAnchor"></a>
and also that the Help Book be indexed by Help Book Indexer. */

