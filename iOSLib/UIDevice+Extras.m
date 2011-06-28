//
//  UIDevice+Extras.m
//  Voddler
//
//  Created by Christoffer Lernö on 2011-29-03.
//  Copyright 2011 Aegik AB. All rights reserved.
//

#import "UIDevice+Extras.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation UIDevice (Extras)

- (NSString *)platform {
    size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
    return platform;
}

- (BOOL)isiPod2GOrEarlier
{
    NSArray *components = [[self platform] componentsSeparatedByString:@","];
    if ([components count] != 2) return NO;
    NSString *firstPart = [components objectAtIndex:0];
    return [firstPart isEqualToString:@"iPod1"] || [firstPart isEqualToString:@"iPod2"];     
}

- (BOOL)isiPhone3GOrEarlier
{
    NSArray *components = [[self platform] componentsSeparatedByString:@","];
    if ([components count] != 2) return NO;
    NSString *firstPart = [components objectAtIndex:0];
    return [firstPart isEqualToString:@"iPhone1"]; 
}

- (size_t)freeMemory {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    return vm_stat.free_count * pagesize;
}

@end
