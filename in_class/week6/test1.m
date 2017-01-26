#import <Foundation/Foundation.h>


void executeBlockForRange(bool (^aBlock)(int), int min, int max ){
    for (int i = min; i < max; i++){
       BOOL docontinue =  aBlock(i);
       if(!doContinue)
           break;
    }
}

int main(int argc, char *argv[])
{
    NSLog(@"HELLO");

    executeBlock(^(int i){
        NSLog(@"EXECUTE!! %i", i);
        if(i == 5){return NO};

        }, -10, 10);

    dispatch_queue_t queue = dispatch_queue_create("background", NULL);

    dispatch_sync(queue, ^{
        NSLog(@"in sync");
        sleep(1);
        NSLog(@"sync done");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"a sync");
    });

return 0;
}
