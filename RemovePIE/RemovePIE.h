//
//  RemovePIE.h
//  
//
//  Created by Zhang Naville on 15/11/5.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach-o/fat.h>

@interface RemovePIE : NSObject
+(NSData*)RemovePIEThin:(NSData*)headerData Path:(NSString*)Path;
@end
