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

@interface ViewController ()

@end

@implementation ViewController

- (NSString*)jsonStringFromArray:(NSArray*)array
{
	NSMutableString *jsonString = [NSMutableString string];
	[self serializeArray:array jsonString:jsonString];
	if ([jsonString length]) {
		[jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
	}
	return jsonString;
}

- (NSString*)jsonStringFromDictionary:(NSDictionary*)dictionary
{
	NSMutableString *jsonString = [NSMutableString string];
	[self serializeDictionary:dictionary jsonString:jsonString];
	if ([jsonString length]) {
		[jsonString deleteCharactersInRange:NSMakeRange([jsonString length] - 1, 1)];
	}
	return jsonString;
}

- (void)serializeArray:(NSArray*)array jsonString:(NSMutableString*)string
{
	[string appendString:@"["];
	NSInteger count = 0;
	for (id object in array) {
		if ([object isKindOfClass:[ITTBaseModelObject class]]) {
			NSDictionary *propertiesValuesDic = [object getPropertiesAndValues];
			[self serializeDictionary:propertiesValuesDic jsonString:string];
		}
		else if ([object isKindOfClass:[NSDictionary class]]){
			[self serializeDictionary:object jsonString:string];
		}
		else if([object isKindOfClass:[NSArray class]]) {
			[self serializeArray:object jsonString:string];
		}
		else {
			[string appendFormat:@"\"%@\",", object];
		}
		count++;
	}
	[string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
	[string appendString:@"]"];
	[string appendString:@","];
}

- (void)serializeDictionary:(NSDictionary*)dictionary jsonString:(NSMutableString*)string
{
	[string appendString:@"{"];
	NSArray *allKeys = [dictionary allKeys];
	for (NSString *key in allKeys) {
		id value = dictionary[key];
		if ([value isKindOfClass:[ITTBaseModelObject class]]) {
			[string appendFormat:@"\"%@\":", key];
			[self serializeDictionary:[value getPropertiesAndValues] jsonString:string];
		}
		else if ([value isKindOfClass:[NSArray class]]) {
			[string appendFormat:@"\"%@\":", key];
			[self serializeArray:value jsonString:string];
		}
		else if ([value isKindOfClass:[NSDictionary class]]) {
			[string appendFormat:@"\"%@\":", key];
			[self serializeDictionary:value jsonString:string];
		}
		else {
			[string appendFormat:@"\"%@\":\"%@\",", key, [value description]];
		}
	}
   [string deleteCharactersInRange:NSMakeRange([string length] - 1, 1)];
	[string appendString:@"}"];
	[string appendString:@","];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	User *user = [[User alloc] init];
	user.userName = @"hello world!";
	user.password = @"password";
	user.age = @"10";
	NSLog(@"property names and value dic %@", [user getPropertiesAndValues]);
	
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
		[self jsonStringFromArray:objects];
	}
	interval = [[NSDate date] timeIntervalSince1970] - interval;
	NSLog(@"end of custom json serialize");
	NSLog(@"time escape of custom %lf seconds", interval);
	
	NSLog(@"begin of JSONKit json serialize");
   interval = [[NSDate date] timeIntervalSince1970];
	for (NSInteger i = 0; i < 10; i++) {
		[compareObjects JSONString];
	}
	interval = [[NSDate date] timeIntervalSince1970] - interval;
	NSLog(@"end of JSONKit json serialize");
	NSLog(@"time escape of JSONKIt %lf seconds", interval);
	
//	NSLog(@"-------------------------------------------------\n");
//	[self jsonStringFromDictionary:@{@"balance":@{@"user":user, @"level":@"10"}}];
//	NSLog(@"-------------------------------------------------\n");
//	[self jsonStringFromDictionary:@{@"array":@[@"1", @"2"]}];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
