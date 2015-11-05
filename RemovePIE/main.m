//
//  main.m
//  RemovePIE
//
//  Created by Zhang Naville on 15/11/5.
//  Copyright (c) 2015年 Naville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach-o/fat.h>
#import "RemovePIE.h"
int i=CPU_TYPE_ARM64;
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray* ArchDataArray=[NSMutableArray array];
      //  printf("%x",CFSwapInt32(0X100000C));
        NSString* Path=[NSString stringWithUTF8String:argv[1]];
        NSData* InputData=[NSData dataWithContentsOfFile:Path];
        NSFileHandle* NSFH=[NSFileHandle fileHandleForReadingAtPath:Path];
        char* rawData=(char*)[InputData bytes];
        NSMutableData* FinalCombinedData=[NSMutableData data];
        
        
        struct fat_header *FatHeader=(struct fat_header*)rawData;
        if(FatHeader->magic==FAT_CIGAM||FatHeader->magic==FAT_MAGIC){
           // NSData* FatHeaderData=[NSData dataWithBytes:FatHeader length:sizeof(struct fat_header)];
            [FinalCombinedData appendBytes:FatHeader length:sizeof(struct fat_header)];
            
            int numberOfFatArch=CFSwapInt32(FatHeader->nfat_arch);
            //Calculate Corrent Arch Number
          //  printf("Fat Binary Containing %x Architectures Detected.Fat Binary is Currently Unsupported\n",numberOfFatArch);
            //exit(-1);
            for(int i=0;i<numberOfFatArch;i++){
            [NSFH seekToFileOffset:sizeof(struct fat_header)+i*sizeof(struct fat_arch)];
                struct fat_arch* FatArch=(struct fat_arch*)[[NSFH readDataOfLength:sizeof(struct fat_arch)] bytes];
                NSData* currentArchData;
                if(FatArch->cputype==0x0){
                    printf("Wrong Arch");
                    break;
                    
                    
                }
                NSData* fatArchData=[NSData dataWithBytes:FatArch length:sizeof(struct fat_arch)];
                [FinalCombinedData appendBytes:FatArch length:sizeof(struct fat_arch)];
                
                //Solve Endian Issue
                
                if((FatHeader->magic)==FAT_CIGAM){
                    printf("Size:0x%x Offset:0x%x\n",CFSwapInt32(FatArch->size),CFSwapInt32(FatArch->offset));
                    [NSFH seekToFileOffset:CFSwapInt32(FatArch->offset)];
                    
                    currentArchData=[NSFH readDataOfLength:CFSwapInt32(FatArch->size)];
                    
                    
                    NSLog(@"Current Size Data:0x%lx\n",(unsigned long)currentArchData.length);
                    struct mach_header* currentHeader=(struct mach_header*)[currentArchData bytes];
                    currentArchData=[RemovePIE RemovePIEThin:currentArchData Path:[NSString stringWithFormat:@"%@.0%x.0%x",Path,CFSwapInt32(currentHeader->cputype),CFSwapInt32(currentHeader->cpusubtype)]];
                    [ArchDataArray addObject:currentArchData];
                    
                }
                else if((FatHeader->magic)==FAT_MAGIC){
                    printf("Size:%x Offset:%x\n",FatArch->size,FatArch->offset);
                    [NSFH seekToFileOffset:FatArch->offset];
                    currentArchData=[NSFH readDataOfLength:FatArch->size];
                    
                    
                    NSLog(@"Current Size Data:0x%lx\n",(unsigned long)currentArchData.length);
                    struct mach_header* currentHeader=(struct mach_header*)[currentArchData bytes];
                    currentArchData=[RemovePIE RemovePIEThin:currentArchData Path:[NSString stringWithFormat:@"%@.0%x.0%x",Path,currentHeader->cputype,currentHeader->cpusubtype]];
                [ArchDataArray addObject:currentArchData];
                    
                    
                }

         //   NSData* Arch=[NSFH readDataOfLength:<#(NSUInteger)#>]
                
                
            }
            for(int i=0;i<ArchDataArray.count;i++){
                [FinalCombinedData appendData:[ArchDataArray objectAtIndex:i]];
                
                
            }
           // NSLog(@"%@",FinalCombinedData);
            [FinalCombinedData writeToFile:[Path stringByAppendingString:@".NOPIE"] atomically:YES];
            
        }
        else{
            
            [RemovePIE RemovePIEThin:InputData Path:Path];
        }
        
        
        
        
        
        
    }
    return 0;
}
