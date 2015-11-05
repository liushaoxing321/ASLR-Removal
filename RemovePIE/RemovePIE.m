//
//  RemovePIE.m
//  
//
//  Created by Zhang Naville on 15/11/5.
//
//

#import "RemovePIE.h"

@implementation RemovePIE
+(NSData*)RemovePIEThin:(NSData*)headerData Path:(NSString*)Path{
    printf("Current headerData Size:0x%lx\n",headerData.length);
    char* rawData=(char*)[headerData bytes];
    struct mach_header *header = (struct mach_header*)rawData;
    printf("CPUTYPE:0%x CPUSUBTYPE:0%x",CFSwapInt32(header->cputype),CFSwapInt32(header->cpusubtype));

    NSLog(@"Output Wrote To:%@",Path);
    header->flags=header->flags-MH_PIE;
    NSData* OutData=[NSData dataWithBytes:header length:headerData.length];
    [OutData writeToFile:Path atomically:YES];
    
    return headerData;
}
@end
