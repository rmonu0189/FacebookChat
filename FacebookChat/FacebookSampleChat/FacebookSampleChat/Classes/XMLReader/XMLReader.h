//
//  XMLReader.h
//

/*
 * This class is used for parse xml data into dictionary.
 */


#import <Foundation/Foundation.h>


@interface XMLReader : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *__autoreleasing *errorPointer;
    
}
// This method is used for return NSDictionary from xml data
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *__autoreleasing *)error;

// This method is used for return NSDictionary from xml string
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *__autoreleasing *)error;

// This method is used for initialize object
- (id)initWithError:(NSError *__autoreleasing *)error;

// This method is used for return NSDictionary from data
- (NSDictionary *)objectWithData:(NSData *)data;
@end
