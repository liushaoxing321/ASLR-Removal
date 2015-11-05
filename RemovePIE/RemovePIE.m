//
//  RemovePIE.m
//  
//
//  Created by Zhang Naville on 15/11/5.
//
//

#import "RemovePIE.h"

@implementation RemovePIE
+(void)RemovePIEThin:(struct mach_header*)header Path:(NSString*)Path{
    printf("cputype:0x%x cpusubtype:0x%x Flags:0x%x",header->cputype,header->cpusubtype,header->flags);
    header->flags=header->flags-MH_PIE;
    char* Data=(char*)header;
    NSData* dataout=[NSData dataWithBytes:Data length:sizeof(header)];
    NSString* OutPath=[Path stringByAppendingString:@".NOPIE"];
    [dataout writeToFile:OutPath atomically:YES];
    
    
    
}
@end
