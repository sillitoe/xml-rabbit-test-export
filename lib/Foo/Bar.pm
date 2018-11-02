package Foo::Bar;

use XML::Rabbit;

has_xpath_value 'id' => '@id';
has_xpath_value 'name' => '.';

finalize_class();

1;