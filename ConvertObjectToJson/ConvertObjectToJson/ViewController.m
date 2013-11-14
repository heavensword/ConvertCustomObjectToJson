//
//  ViewController.m
//  ConvertObjectToJson
//
//  Created by Sword on 13-11-12.
//  Copyright (c) 2013年 Sword. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "Credit.h"
#import "JSONKit.h"
#import "NSJSONSerialization+ITTAdditions.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	User *user = [[User alloc] init];
	user.userName = @"hello world!";
	user.password = @"password";
	user.age = @"10";
//	NSLog(@"property names and value dic %@", [user propertiesAndValuesDic]);
	
	NSMutableArray *objects = [NSMutableArray array];
	NSMutableArray *compareObjects = [NSMutableArray array];
	for (NSInteger i = 0; i < 100; i++) {
		User *user = [[User alloc] init];
		user.userName = [NSString stringWithFormat:@"hello world %d!", i];
		user.password = [NSString stringWithFormat:@"password %d!", i];
		user.age = [NSString stringWithFormat:@"%d", 10 + i];
		if (i % 2) {
			Credit *credit = [[Credit alloc] init];
			credit.level = [NSString stringWithFormat:@"level%d", i];
			credit.balance = [NSString stringWithFormat:@"%d", i * 100000];
			user.credit = credit;
			
			[compareObjects addObject:@{@"userName":user.userName, @"password":user.password, @"age":user.age, @"credit":@{@"level":credit.level, @"balance":credit.balance}}];
		}
		[objects addObject:user];
	}
	[objects addObject:@{@"balance":@{@"user":user, @"level":@"10"}}];
	[objects addObject:@{@"array":@[@"1", @"2"]}];
	[objects addObject:@[@"3", @"4"]];
	[objects addObject:@"5"];
	NSLog(@"begin of custom json serialize");
	NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
	for (NSInteger i = 0; i < 10; i++) {
		[NSJSONSerialization jsonStringFromArray:objects];
	}
	interval = [[NSDate date] timeIntervalSince1970] - interval;
	NSLog(@"end of custom json serialize");
	NSLog(@"time escape of custom %lf seconds", interval);
	NSLog(@"%@", [NSJSONSerialization jsonStringFromArray:objects]);
	NSLog(@"begin of JSONKit json serialize");
   interval = [[NSDate date] timeIntervalSince1970];
	for (NSInteger i = 0; i < 10; i++) {
		[compareObjects JSONString];
	}
	interval = [[NSDate date] timeIntervalSince1970] - interval;
	NSLog(@"end of JSONKit json serialize");
	NSLog(@"time escape of JSONKIt %lf seconds", interval);
	
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"balance":@{@"user":user, @"level":@"10"}}]);
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"array":@[@"1", @"2"]}]);
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"test":@"admin"}]);
	NSLog(@"-------------------------------------------------\n");
	NSLog(@"%@", [NSJSONSerialization jsonStringFromDictionary:@{@"array":@[@"1", @"2"]}]);	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
