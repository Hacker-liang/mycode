#import <Foundation/Foundation.h>

@interface Base64 : NSObject {
	
}

//+ (NSString *) encodeBase64:(NSString *) input;
//+ (NSString *) decodeBase64:(NSString *) input;
+ (NSString*) base64Encode:(NSData *)data;
+ (NSData*) base64Decode:(NSString *)string;

@end