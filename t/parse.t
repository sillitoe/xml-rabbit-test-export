use Test::More;

use strict;
use warnings;
use FindBin;
use Path::Tiny;

use_ok('Foo');
use_ok('Foo::Bar');

my $xml_file = "$FindBin::Bin/foo.xml";

my $expected_xml = path($xml_file)->slurp;

subtest 'new obj from file' => sub {
    my $foo = Foo->new(file => $xml_file);
    test_object($foo);
    is($foo->render, $expected_xml);
};

subtest 'new obj from manual' => sub {
    my $foo = Foo->new(
        id => 'All the best bars',
        title => '1',
        bars => [
            Foo::Bar->new(id => 'bar1', name => "Moe's"),
            Foo::Bar->new(id => 'bar2', name => "Cheers"),
        ],
    );
    test_object($foo);
    is($foo->render, $expected_xml);
};

sub test_object {
    my $foo = shift;
    is($foo->id, '1');
    is($foo->title, 'All the best bars');
    is($foo->count_bars, 2);

    is($foo->get_bar(0)->id, 'bar1');
    is($foo->get_bar(0)->name, "Moe's");
    is($foo->get_bar(1)->id, 'bar2');
    is($foo->get_bar(1)->name, "Cheers");
}

done_testing;