#import <Foundation/Foundation.h>

#import <libmewchan/libmewchan.h>

@interface FakeMewchan: NSObject<MCMewchanHelperDelegate>

- (void)start;

- (void)dispatchEvent: (id)event;

@end
