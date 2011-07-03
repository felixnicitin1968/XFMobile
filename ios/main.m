//
//  main.m
//  iXfire
//
//  Created by Moti Joseph on 4/1/09.
//  Copyright Gamepe 2009. All rights reserved.
//   /open Terminal, and do the following to increment your build number:
//  /Developer/usr/bin/agvtool next-version -all


#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) 

{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
