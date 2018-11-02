# Creating XML::Rabbit objects from non-XML sources

I can use `MooseX::Templated` to export objects as XML, eg

```perl
package Foo::Bar;
use XML::Rabbit;

has_xpath_value 'id' => '@id';
has_xpath_value 'name' => '.';

finalize_class();
1;

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
```

Then I can parse a file and rerender it with:

```perl
$foo = Foo->new( file => $xml_file );
$foo->render()
```

which gives...

```xml
<?xml version="1.0" encoding="UTF-8"?>
<foo xmlns="http://www.myschema.com/schema/foo"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.myschema.com/schema/foo foo.xsd">
  <title id="1">All the best bars</title>
  <bars>
    <bar id="bar1">Moe's</bar>
    <bar id="bar2">Cheers</bar>
  </bars>
</foo>
```

Great.

I now want to create the same objects from a different source (database) and use them to export the file as XML.

I was hoping to be able to create these objects manually.

```perl
my $foo = Foo->new(
  id => 'All the best bars',
  title => '1',
  bars => [
    Foo::Bar->new(id => 'bar1', name => "Moe's"),
    Foo::Bar->new(id => 'bar2', name => "Cheers"),
  ],
);
```

However, this currently dies with the error:

```sh
Attribute (_node), passed as (node), is required at constructor Foo::Bar::new (defined at /[...]/.plenv/versions/5.12.5/lib/perl5/site_perl/5.12.5/XML/Rabbit/Sugar.pm line 136) line 30
```

which makes sense since `_node`, `_xpc` and `_namespace_map` are required fields.
