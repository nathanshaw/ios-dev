// main.m

// NSString
// NSValue - can hold any type of objectj
// NSNumber - a class that can contain ints or floats or any number
// NSArray - imutable object
// NSDictionary - mapping of value to another object
// NSSet - Array where all the elements are unique - unordered
// NSData - raw binary data - if you read in a file or something
// NSMutableArray

#import <Foundation/Foundation.h>

@interface MyCoolClass : NSObject
{
    int _numberOfTimesCalled;
    NSString *_someString;
}
- (id)init;

- (void)doSomethingCool:(NSString *)msg
    numberOfTImes:(int)times
    numberOfExclamations:(int)numExcl;
@end

@implementation MyCoolClass
- (id)init
{
    if(self = [super init])
    {
       _numberOfTimesCalled = 0; 
       _someStirng = "Init String Default Value";
    }
    return self
}

- (void)doSomethingCool:(NSString *)msg
    numberOfTimes:(int)times
    numberOfExclamations:(int)numExcl
{
        _numberOfTimesCalled++;
        NSLog(@"Number of times called %i", _numberOfTimesCalled);
        for(int i =0; i < times; i++) {
            NSLog(@"HEY");
    }
}
@end

int main(int argc, char *argv[])
{
    MyCoolClass *coolDude = [MyCoolClass new];
    [coolDude doSomethingCool:@"Hello buddy"
                numberOfTImes:10
         numberOfExclamations:5];

    NSLog(@"Hello World");
    NSString *str = @"HOWDY";
    // the @ sign allows NSLog to decode whatever data type is passed into it
    NSLog(@"str : %@", str);

    NSArray *myArray = @[@"Hello", @"Goog", @"gle"];
    NSLog(@"This is the array : %@", myArray);
    NSLog(@"Item zero is : %@", myArray[0]);

    NSMutableArray *mutArray = [NSMutableArray new];

    [mutArray addObject:@"uno"];
    [mutArray addObject:@"two"];
    [mutArray addObject:@"three"];

    NSLog(@"My array is : %@", mutArray);

    NSDictionary *dict = @{ @"name": @"Jake",
                            @"position": @"Friend",
                             @"Hobbies": @[@"stuff", @"Things"]};

    NSLog(@"my dict : %@", dict);

    NSLog(@"My name is %@", dict[@"name"]);

    NSMutableDictionary *students = [NSMutableDictionary new];

    students[@"name"] = @"Nathan";
    students[@"Grade"] = @"Awesome";

    return 0;
}
