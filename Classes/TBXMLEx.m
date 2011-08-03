#import "TBXMLEx.h"

@interface TBXMLEx ()
-(void) setTBXML:(TBXML *) value;
@end

@implementation TBXMLEx

+(TBXMLEx *) parserWithXML:(NSString *) xml {
	TBXMLEx *ex = [[[TBXMLEx alloc] init] autorelease];
	[ex setTBXML:[[TBXML alloc] initWithXMLString:xml]];
	return ex;
}

-(void) setTBXML:(TBXML *) value {
	tbxml = value;
}

-(BOOL) invalidXML {
	return tbxml.invalidXML;
}

-(NSString *) parsingErrorDescription {
	return tbxml.parsingErrorDescription;
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
