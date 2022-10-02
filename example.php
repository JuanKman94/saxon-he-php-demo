<?php

print "Validating article using DTD with libxml2 …\n";
putenv('XML_CATALOG_FILES=' . __DIR__ . '/catalog.xml'); // comment this out to disable the catalog
putenv('XML_DEBUG_CATALOG=');
libxml_use_internal_errors(true);
$doc = new \DOMDocument;
$doc->load(__DIR__ . '/example.xml', LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_NONET);
print_r(libxml_get_errors());

print "Validating article using Schematron with Saxon …\n";
$saxonProcessor = new Saxon\SaxonProcessor();
$saxonProcessor->setCatalog(__DIR__ . '/catalog.xml', true); // true = tracing
$processor = $saxonProcessor->newXslt30Processor();
$executable = $processor->compileFromFile(__DIR__ . '/example.xsl');
$result = $executable->transformFileToString(__DIR__ . '/example.xml');
print $result;
