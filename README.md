About
=====

This project, TBXMLEx ("TBXML with Extensions") is based on http://www.tbxml.co.uk.

TBXML is a light-weight XML document parser written in Objective-C designed for use on Apple iPad, iPhone & iPod Touch devices. TBXML aims to provide the fastest possible XML parsing whilst utilising the fewest resources. This requirement for absolute efficiency is achieved at the expense of XML validation and modification. It is not possible to modify and generate valid XML from a TBXML object and no validation is performed whatsoever whilst importing and parsing an XML document.


The design goals for TBXML are:
-------------------------------
* XML files conforming to the W3C XML spec 1.0 should be passable
* XML parsing should incur the fewest possible resources
* XML parsing should be achieved in the shortest possible time
* It shall be easy to write programs that utilise TBXML

Building GHUnit
===============
GHUnit is included as a submodule, however the compiled Framework is also available so you won't need to compile it by hand. If - for any reason - you wish to do so, run *git submodule init* and follow the instructions at http://longweekendmobile.com/2011/02/23/tdd-best-practices-testing-in-ios4-with-ghunit-part-1.

Using TBXMLEx
=============
TBXMLEx is built on top of TBXML, so if you are already using it in your projects, you will get 100% compatibiliy - even the import headers are the same. The extensions this library provides, on the other hand, are available via the header file *TBXMLEx.h*. 

``` Objective-C
NSString *xml = @"<files> \
	<file timestamp='1234567890' size='123' createdAt='01/01/20011'>/Users/rafaelsteil/Desktop/file1.jpg</file> \
	<file timestamp='1234567890' size='8934' createdAt='02/01/20011'>/Users/rafaelsteil/Desktop/file2.jpg</file> \
	<file timestamp='1234567890' size='2344' createdAt='03/01/20011'>/Users/rafaelsteil/Desktop/file3.jpg</file> \
	<file timestamp='1234567890' size='2309842' createdAt='04/01/20011'>/Users/rafaelsteil/Desktop/file4.jpg</file> \
</files>";

TBXMLEx *xml = [TBXMLEx createParserWithXML:xml];

if (xml.rootElement) {
	TBXMLElementEx *fileNode = [xml.rootElement child@"file"];

	while ([fileNode next]) {
		NSDictionary *allAttributes = fileNode.attributes;
		NSLog(@"Timestamp: %@", [allAttributes objectWithKey:@"timestamp"]);
	
		NSLog(@"Size: %d", [fileNode intAttribute:@"size"]);
		NSLog(@"createdAt: %@", [fileNode attribute:@"createdAt"]);
		NSLog(@"Filename: %@", fileNode.value); // or fileNode.text
	}
}
```
