#import <Foundation/Foundation.h>
#import "TBXML.h"

@interface TBXMLElementEx : NSObject {
	TBXMLElement *element;
	BOOL firstPass;
	NSDictionary *attributes;
}

@property (nonatomic, readonly) NSDictionary *attributes;

-(id) initWithElement:(TBXMLElement *) value;
-(TBXMLElementEx *) child:(NSString *) elementName;
-(BOOL) next;
-(NSString *) attribute:(NSString *) name;
-(int) intAttribute:(NSString *) name;
-(NSString *) value;
-(NSString *) name;
-(BOOL) exists;

@end

@interface TBXMLEx : NSObject {
	TBXML *tbxml;
	TBXMLElementEx *currentElement;
	TBXMLElementEx *rootElement;
}

+(TBXMLEx *) parserWithXML:(NSString *) xml;
-(TBXMLElementEx *) rootElement;

@property (nonatomic, readonly) TBXMLElementEx *currentElement;

@end

