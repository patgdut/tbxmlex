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

-(NSString *) queryXML {
	return @"<data> \
		<a> \
			<a1/> \
			<a1/> \
			<a1/> \
		</a> \
		 \
		<b/> \
		<b/> \
		<c/> \
		 \
		<d> \
			<d1> \
				<d11/> \
				<d21/> \
			</d1> \
			 \
			<d2> \
				<d21/> \
				<d22> \
					<d221/> \
				</d22> \
			</d2> \
		</d> \
	</data>";	
}

-(void) testQueryEndsWithSlashShoulShouldWorkAnyway {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"/c/"];
	GHAssertEquals(1, (int)result.count, @"One element was expected");
	GHAssertEqualStrings(@"c", [[result objectAtIndex:0] name], @"The tag's name is wrong");
}

-(void) testQueryDoesNotStartWithSlashShoulShouldFindAnyway {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"d/d2"];
	GHAssertEquals(1, (int)result.count, @"One element was expected");
	GHAssertEqualStrings(@"d2", [[result objectAtIndex:0] name], @"The tag's name is wrong");
}

-(void) testQueryInexistentElementShouldReturnEmptyArray {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"/bla"];
	GHAssertEquals(0, (int)result.count, @"Zero elements were expected");
}	

-(void) testQueryShouldFindVeryInnerElementsOf_D {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"/d/d2/d22/d221"];
	GHAssertEquals(1, (int)result.count, @"One element was expected");
	GHAssertEqualStrings(@"d221", [[result objectAtIndex:0] name], @"The first tag's name is wrong");
}	

-(void) testQueryShouldFindInnerElementsOf_A {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"/a/a1"];
	GHAssertEquals(3, (int)result.count, @"Three elements were expected");
	GHAssertEqualStrings(@"a1", [[result objectAtIndex:0] name], @"The first tag's name is wrong");
	GHAssertEqualStrings(@"a1", [[result objectAtIndex:1] name], @"The second tag's name is wrong");
	GHAssertEqualStrings(@"a1", [[result objectAtIndex:2] name], @"The third tag's name is wrong");
}

-(void) testQueryShouldFindTwo_B {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self queryXML]];
	NSArray *result = [parser.rootElement query:@"/b"];
	GHAssertEquals(2, (int)result.count, @"Two elements were expected");
	
	TBXMLElementEx *el1 = [result objectAtIndex:0];
	GHAssertEqualStrings(@"b", el1.name, @"The first tag's name is wrong");
	
	TBXMLElementEx *el2 = [result objectAtIndex:1];
	GHAssertEqualStrings(@"b", el2.name, @"The second tag's name is wrong");
}

-(void) testExpect4FileElements {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"file"];
	int counter = 0;
	
	while ([fileNode next]) {
		counter++;
	}
	
	GHAssertEquals(4, counter, @"4 elements were expected");
}

-(void) testAttributesAsDictionaryShouldBePopulated {
	TBXMLEx *parser = [TBXMLEx parserWithXML:[self filesXML]];
	TBXMLElementEx *fileNode = [parser.rootElement child:@"file"];
	GHAssertEqualStrings(@"1234567890", [fileNode.attributes objectForKey:@"timestamp"], @"Timestamp not found");
	GHAssertEqualStrings(@"123", [fileNode.attributes objectForKey:@"size"], @"Size not found");
	GHAssertEqualStrings(@"01/01/20011", [fileNode.attributes objectForKey:@"createdAt"], @"createdAt not found");
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
