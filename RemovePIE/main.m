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
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* Path=[NSString stringWithUTF8String:argv[1]];
        NSData* InputData=[NSData dataWithContentsOfFile:Path];
        char* rawData=(char*)[InputData bytes];
        
        
        struct mach_header *header = (struct mach_header*)rawData;
        struct fat_header *FatHeader=(struct fat_header*)rawData;
        if(FatHeader->magic==FAT_CIGAM||FatHeader->magic==FAT_MAGIC){
            
            int numberOfFatArch=FatHeader->nfat_arch/0x1000000;
            printf("Fat Binary Containing %x Architectures Detected.Fat Binary is Currently Unsupported",numberOfFatArch);
            //exit(-1);
            for(int i=0;i<numberOfFatArch;i++){
            NSFileHandle* NSFH=[NSFileHandle fileHandleForReadingAtPath:Path];
            [NSFH seekToFileOffset:sizeof(struct fat_header)+sizeof(struct fat_arch)];
                struct fat_arch* FatArch=(struct fat_arch*)[[NSFH readDataOfLength:sizeof(struct fat_arch)] bytes];
                printf("Size:%x",FatArch->size);
                
         //   NSData* Arch=[NSFH readDataOfLength:<#(NSUInteger)#>]
                
                
            }
            
        }
        else{
            
            [RemovePIE RemovePIEThin:header Path:Path];
        }
        
        
        
        
        
        
    }
    return 0;
}
