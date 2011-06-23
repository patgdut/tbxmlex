#import "TBXMLEx.h"

#define SafeRelease(__p__) { [__p__ release]; __p__ = nil; }

@interface TBXMLEx ()
-(void) setTBXML:(TBXML *) value;
@end

@implementation TBXMLEx
@synthesize currentElement;

+(TBXMLEx *) parserWithXML:(NSString *) xml {
	TBXMLEx *ex = [[TBXMLEx alloc] init];
	[ex setTBXML:[[TBXML alloc] initWithXMLString:xml]];
	return ex;
}

-(void) setTBXML:(TBXML *) value {
	tbxml = value;
}

-(TBXMLElementEx *) rootElement {
	if (!rootElement) {
		rootElement = [[TBXMLElementEx alloc] initWithElement:tbxml.rootXMLElement];
	}

	return rootElement;
}

-(void) dealloc {
	[tbxml release];
	[rootElement release];
	[super dealloc];
}

@end

// ***
@implementation TBXMLElementEx
@synthesize attributes;

-(id) initWithElement:(TBXMLElement *) value {
	if (self = [super init]) {
		element = value;
		firstPass = YES;
	}
	
	return self;
}

-(NSDictionary *) attributes {
	if (!attributes) {
		attributes = [[NSDictionary alloc] init];
		TBXMLAttribute *attr = element->firstAttribute;
		
		while (attr) {
			[attributes setValue:[TBXML attributeName:attr] forKey:[TBXML attributeValue:attr]];
			attr = attr->next;
		}
	}
	
	return attributes;
}

-(NSString *) name {
	return element ? [TBXML elementName:element] : nil;
}

-(int) intAttribute:(NSString *) name {
	return element ? [[self attribute:name] intValue] : 0;
}

-(NSString *) attribute:(NSString *) name {
	return element ? [TBXML valueOfAttributeNamed:name forElement:element] : nil;
}

-(int) intValue {
	return [[self value] intValue];
}

-(long long) longValue {
	return [[self value] longLongValue];
}

-(NSString *) value {
	return element ? [TBXML textForElement:element] : nil;
}

-(NSString *) text {
	return [self value];
}

-(BOOL) exists {
	return element != nil;
}

-(BOOL) next {
	if (!element) {
		return NO;
	}
	
	if (firstPass) {
		firstPass = NO;
		return YES;
	}
	
	element = [TBXML nextSiblingNamed:[TBXML elementName:element] searchFromElement:element];
	return element != nil;
}

-(TBXMLElementEx *) child:(NSString *) elementName {
	TBXMLElement *childElement = [TBXML childElementNamed:elementName parentElement:element];
	return [[TBXMLElementEx alloc] initWithElement:childElement];
}

-(void) dealloc {
	[attributes release];
	[super dealloc];
}

@end

