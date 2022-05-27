<?php

$saxonProcessor = new Saxon\SaxonProcessor();
//$saxonProcessor->setConfigurationProperty('http://saxon.sf.net/feature/sourceParserClass', 'org.apache.xml.resolver.tools.ResolvingXMLReader');
$saxonProcessor->setCatalog(__DIR__ . '/catalog.xml', true); // this fails
$processor = $saxonProcessor->newXslt30Processor();
$executable = $processor->compileFromFile(__DIR__ . '/example.xsl');
//$result = $executable->transformFileToFile('example.xml', 'output.xml');
$result = $executable->transformFileToString('example.xml');
echo $result;

