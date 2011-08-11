#import "TBXMLElementEx.h"

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
		attributes = [[NSMutableDictionary alloc] init];
		TBXMLAttribute *attr = element->firstAttribute;
		
		while (attr) {
			[attributes setObject:[TBXML attributeValue:attr] forKey:[TBXML attributeName:attr]];
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

-(long long) longAttribute:(NSString *) name {
	return element ? [[self attribute:name] longLongValue] : 0; 
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
	return childElement ? [[[TBXMLElementEx alloc] initWithElement:childElement] autorelease] : nil;
}

-(void) dealloc {
	[attributes release];
	[super dealloc];
}

@end
