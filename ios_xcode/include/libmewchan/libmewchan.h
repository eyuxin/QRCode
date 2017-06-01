#import <UIKit/UIKit.h>

#include <sys/time.h>
#include <libgen.h>

#ifdef __cplusplus
extern "C" {
#endif

extern NSLock *MCMewLogLock;

#define MCLog(__TAG__, ...) \
    do \
    { \
        if (!MCMewLogLock) { \
            MCMewLogLock = [[NSLock alloc] init]; \
        } \
        [MCMewLogLock lock]; \
        time_t raw_time; time(&raw_time); \
        struct tm *time_data = gmtime(&raw_time); \
        struct timeval time_value; \
        gettimeofday(&time_value, 0); \
        int millisecond = (time_value.tv_usec / 1000) % 1000; \
        fprintf(stdout, (const char *)"%02d-%02d %02d:%02d:%02d.%03d %s ", \
                time_data->tm_mon + 1, \
                time_data->tm_mday, \
                time_data->tm_hour, \
                time_data->tm_min, \
                time_data->tm_sec, \
                millisecond, \
                __TAG__); \
        fprintf(stdout, (const char *)"%s", [[NSString stringWithFormat: __VA_ARGS__] UTF8String]); \
        fprintf(stdout, (const char *)" (%s/", basename(dirname((char *)__FILE__))); \
        fprintf(stdout, (const char *)"%s:%d)\n", basename((char *)__FILE__), __LINE__); \
        [MCMewLogLock unlock]; \
    } while (0)

#define MCDebug(...)   MCLog(" [DEBUG]", __VA_ARGS__)
#define MCInfo(...)    MCLog("  [INFO]", __VA_ARGS__)
#define MCCelebr(...)  MCLog("[CELEBR]", __VA_ARGS__)
#define MCWarn(...)    MCLog("  [WARN]", __VA_ARGS__)
#define MCError(...)   MCLog(" [ERROR]", __VA_ARGS__)

#define MCDump(__OBJECT__) MCLog("  [DUMP]", @"%@", __OBJECT__)
    
    
typedef void (^MCFunctionCallback)(id error, id response);
    
@interface MCFunction: NSObject

- (void)invoke: (NSArray *)arguments callback: (MCFunctionCallback)callback;

@end
    
    
typedef id (^MCWrapperFunctionImplementation)(NSArray *);
    
@interface MCWrapperFunction: NSObject

- (instancetype)initWithImplementation: (MCWrapperFunctionImplementation)implementation;

- (void)invoke: (NSArray *)arguments callback: (MCFunctionCallback)callback;

@end
    
    
@class MCMewchanLoadingView;

typedef void (^MCMewchanLoadingViewListener)(MCMewchanLoadingView *loadingView, NSUInteger playedTimes);

@interface MCMewchan: NSObject

- (id)initWithOptions: (NSDictionary *)options;

- (void)start;

- (BOOL)isFinished;

- (void)dispatchEvent: (id)event;

- (id)executeCommand: (id)command;

@end
    

@interface MCMewchanLoadingView: UIView

@property (nonatomic, strong) UIColor *color;

- (void)play;

- (void)stop;

- (BOOL)isPlaying;

- (NSUInteger)playedTimes;

- (void)callWhenFinished: (MCMewchanLoadingViewListener)listener;

@end
    
    
@interface MCMewchanVillageViewController: UIViewController

- (void)setPrefersStatusBarHidden: (BOOL)prefersStatusBarHidden;

- (void)setSupportedInterfaceOrientations: (UIInterfaceOrientationMask)supportedInterfaceOrientations;
    
@end
    
    
@interface MCExtendedViewController: UIViewController


@property (nonatomic, strong) MCMewchan *mewchan;

@property (nonatomic, strong) id mewchanData;


- (void)dispatchMewchanEvent: (id)event;

- (id)executeMewchanCommand: (id)command;

- (void)registerMewchanProcessor: (MCFunction *)processor;

- (void)updateByMewchanOrder: (id)order;


@end
    
    
@protocol MCMewchanHelperDelegate
    
- (id)mewchanActionExecuted: (id)action lastResult: (id)result;

@end

    
@interface MCMewchanHelper: NSObject

+ (void)registerDelegate: (id<MCMewchanHelperDelegate>)delegate;

+ (id)executeAction: (id)action;

@end
    
    
#ifdef __cplusplus
}
#endif