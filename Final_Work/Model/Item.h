#import "_Item.h"


@interface Item : _Item{}


- (instancetype)initWithItem:(id)test;

@property (nonatomic) NSDate* lastUpdated;

- (void)updateWithItemName:(NSString*)itemName;

@end


