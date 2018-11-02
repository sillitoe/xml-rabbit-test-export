#!/usr/bin/env perl
use inc::Module::Install 1.02;

name 'Foo';
author 'Ian Sillitoe <isillitoe@cpan.org>';
abstract 'Exporting XML::Rabbit nodes as XML documents';
version '0.01';

requires 'Path::Tiny';
requires 'XML::Rabbit';
requires 'MooseX::Templated';

test_requires 'Test::More' => '0.88';

WriteAll;