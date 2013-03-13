#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface TaskListRAVAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (TaskListRAVAPIClient *)sharedClient;

@end
