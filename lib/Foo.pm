package Foo;

use XML::Rabbit::Root;

with 'MooseX::Templated';

add_xpath_namespace 'x' => 'http://www.myschema.com/schema/foo';

has_xpath_value 'id'    => '//x:title[1]/@id';
has_xpath_value 'title' => '//x:title[1]';
has_xpath_object_list '_bars' => '//x:bar' => 'Foo::Bar',
  handles => { bars => 'elements', get_bar => 'get', count_bars => 'count' };

finalize_class();

sub _template { <<'_TT2' }
<?xml version="1.0" encoding="UTF-8"?>
<foo xmlns="http://www.myschema.com/schema/foo"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.myschema.com/schema/foo foo.xsd">
  <title id="[% self.id %]">[% self.title %]</title>
  <bars>
[%- FOREACH bar IN self.bars %]
    <bar id="[% bar.id %]">[% bar.name %]</bar>
[%- END %]
  </bars>
</foo>
_TT2

1;