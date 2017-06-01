#import "FakeMewchan.h"

#import "QRViewController.h"

#import <libmewchan/libmewchan.h>



@interface FakeMewchan() {
    
}

@end

@implementation FakeMewchan

- (void)start {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        QRViewController *viewController = [[QRViewController alloc]
                                            initWithNibName: @"QRViewController" bundle: nil];
        
        [viewController setMewchan: (MCMewchan *)self];
        [viewController registerMewchanProcessor: (MCFunction *)[[MCWrapperFunction alloc] initWithImplementation: ^id (NSArray *list) {
            
            if ([@"goBackward" isEqualToString: list[0][@"command"]]) {
                [viewController dismissViewControllerAnimated: YES completion: nil];
            }
            
            return nil;
            
        }]];
        
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController: viewController
                                                                                                 animated: YES
                                                                                               completion: nil];
        
    });
    
}

- (void)dispatchEvent: (id)event {
    
    // Do nothing
    
}

- (id)mewchanActionExecuted: (id)action lastResult: (id)result {
    
    // Do nothing
   
    return result;
}

@end
