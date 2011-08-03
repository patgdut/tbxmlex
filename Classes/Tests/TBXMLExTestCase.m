#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import "TBXMLEx.h"

@interface TBXMLExTestCase : GHTestCase { }
@end

@implementation TBXMLExTestCase

-(NSString *) filesXML {
	return @"<files> \
		<file timestamp='1234567890' size='123' createdAt='01/01/20011'>file1.jpg</file> \
		<file timestamp='1234567890' size='8934' createdAt='02/01/20011'>file2.jpg</file> \
		<file timestamp='1234567890' size='2344' createdAt='03/01/20011'>file3.jpg</file> \
		<file timestamp='1234567890' size='2309842' createdAt='04/01/20011'>file4.jpg</file> \
	</files>";
}

-(void) testInvalidTagShouldReturnNil {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"inexistent_tag_name"];
	GHAssertNil(fileNode, @"The tag wasn't supposed to exist");
}

-(void) testShouldRetrieveIntValue {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"file"];
	GHAssertEquals(123, [fileNode intAttribute:@"size"], @"The size attribute is different");
}

-(void) testParserShouldNotCrashWhenXMLIsNil {
	GHAssertNoThrow([TBXMLEx parserWithXML:nil], @"The parser should not crash when with a nil xml");
}

-(void) testParserShouldNotCrashWhenXMLIsEmpty {
	GHAssertNoThrow([TBXMLEx parserWithXML:@""], @"The parser should not crash when with a nil xml");
}

-(void) testParserShouldNotCrashWhenXMLIsInvalid {
	NSString *xml = @"<files><file></file><x";
	TBXMLEx *parser = [TBXMLEx parserWithXML:xml];
	GHAssertTrue(parser.invalidXML, @"XML should be flagged as invalid");
	GHAssertEqualStrings(@"'>' character for the opening tag not found", parser.parsingErrorDescription, @"Incorrect error message");
}

-(void) testExpectInvalidParserWhenTagIsNotClosed {
	NSString *xml = @"<files><file><![CDATA[aaa";
	TBXMLEx *parser = [TBXMLEx parserWithXML:xml];
	GHAssertTrue(parser.invalidXML, @"XML should be flagged as invalid");
	GHAssertEqualStrings(@"CDATA element not closed", parser.parsingErrorDescription, @"Incorrect error message");
}

-(void) testShouldDisplayRootElementName {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	GHAssertEqualStrings(@"files", [parser.rootElement name], @"Root element tag name does not match");
}

@end
