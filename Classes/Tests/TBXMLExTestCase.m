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

-(void) testInvalidTagShouldBeFlaggedAsNotExists {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"notATagName"];
	GHAssertFalse(fileNode.exists, @"The tag wasn't supposed to exist");
}

-(void) testShouldRetrieveIntValue {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"file"];
	GHAssertTrue(fileNode.exists, @"The first file node does not exist");
	GHAssertEquals(123, [fileNode intAttribute:@"size"], @"The size attribute is different");
}

-(void) testParserShouldNotCrashWhenXMLIsNil {
	GHAssertNoThrow([TBXMLEx parserWithXML:nil], @"The parser should not crash when with a nil xml");
}

-(void) testShouldDisplayRootElementName {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	GHAssertEqualStrings(@"files", [parser.rootElement name], @"Root element tag name does not match");
}

@end
