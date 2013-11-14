//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*!
 *	The Super class of all custom model.All type of property must be NSObject type
 */
@interface ITTBaseModelObject :NSObject <NSCoding, NSCopying>
{
}

- (id)initWithDataDic:(NSDictionary*)data;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSDictionary*)attributeMapDictionary;
- (NSString*)customDescription;
- (NSString*)description;
- (NSData*)getArchivedData;

- (NSDictionary*)propertiesAndValuesDic;

@end
