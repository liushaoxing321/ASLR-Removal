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
+(void)RemovePIEThin:(struct mach_header*)header Path:(NSString*)Path;
@end
