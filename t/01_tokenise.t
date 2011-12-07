# Test colourise_msg

use strict;
use warnings;
use Test::More;
use Test::Deep;
use FindBin qw($Bin);
use YAML qw(LoadFile Dump);

use Clix::Utils qw(tokenise_msg);

my @data = (
  [ text1 => 'May we present Adam Lisagor (\@lonelysandwich) in conversation with Merlin Mann (\@hotdogsladies) - http://t.co/Cwse3c5m #webstock' ],
);

my ($expected);

for my $rec (@data) {
  my ($name, $msg) = @$rec;
  my @output = tokenise_msg($msg);
  if (-f "$Bin/t01/$name.yml") {
    $expected = LoadFile("$Bin/t01/$name.yml");
    cmp_deeply(\@output, $expected, "$name ok");
  }
  else {
    print Dump \@output;
  }
}

done_testing;

