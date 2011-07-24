# Test colourise_snippet

use strict;
use warnings;
use Test::More tests => 1;
use Clix::Colours;

is(Clix::Colours::_colourise_snippet("foo", "red", report_colours => 1), 
  "red: foo\n", 'report_colours ok');

