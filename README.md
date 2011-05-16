About
=====

This project, TBXMLEx ("TBXML with Extensions") is based on [http://www.tbxml.co.uk](http://www.tbxml.co.uk/).

TBXML is a light-weight XML document parser written in Objective-C designed for use on Apple iPad, iPhone & iPod Touch devices. TBXML aims to provide the fastest possible XML parsing whilst utilising the fewest resources. This requirement for absolute efficiency is achieved at the expense of XML validation and modification. It is not possible to modify and generate valid XML from a TBXML object and no validation is performed whatsoever whilst importing and parsing an XML document.


The design goals for TBXML are:
-------------------------------
* XML files conforming to the W3C XML spec 1.0 should be passable
* XML parsing should incur the fewest possible resources
* XML parsing should be achieved in the shortest possible time
* It shall be easy to write programs that utilise TBXML

Building GHUnit
===============
GHUnit is included as a submodule, however the compiled Framework is also available so you won't need to compile it by hand. If - for any reason - you wish to do so, run *git submodule init* and follow the instructions at 
 [http://longweekendmobile.com/2011/02/23/tdd-best-practices-testing-in-ios4-with-ghunit-part-1/](http://longweekendmobile.com/2011/02/23/tdd-best-practices-testing-in-ios4-with-ghunit-part-1/).