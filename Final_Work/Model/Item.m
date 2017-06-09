#import "Item.h"
#import <MagicalRecord/MagicalRecord.h>

@interface Item ()
// Custom logic goes here.
@end

@implementation Item

@synthesize lastUpdated;

- (instancetype)initWithItem:(id)test {
    
    if (self = [super initWithContext:[NSManagedObjectContext MR_defaultContext]]) {
        self.name = @"id";
        self.lastUpdated = [NSDate new];
    }
    
    
    return self;
}

- (void)updateWithItemName:(Item*)items {
    self.type = items.type;
    self.name = items.name;
    self.price = items.price;
    self.date = items.date;
    self.image = items.image;
    self.lastUpdated = [NSDate new];
}

@end
