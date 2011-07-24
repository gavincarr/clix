# Test colourise_msg

use strict;
use warnings;
use Test::More tests => 9;
use Clix::Colours;

# Simple
is(Clix::Colours::_colourise_msg("foo",
    msg => "im_msg", report_colours => 1), 
  "green: foo\n", 'report_colours ok');

# @person
is(Clix::Colours::_colourise_msg("\@gavin Totally!", 
    msg => "mb_msg", report_colours => 1), 
  "cyan: \@gavin \ngreen: Totally!\n", '@person initial ok');
is(Clix::Colours::_colourise_msg("\@gavin \@phil Totally agree of course!", 
    msg => "mb_msg", report_colours => 1), 
  "cyan: \@gavin \ncyan: \@phil \ngreen: Totally \ngreen: agree \ngreen: of \ngreen: course!\n", 
  '@person initial multiple ok');
is(Clix::Colours::_colourise_msg("Speak to \@gavin, \@phil, and \@matt.", 
    msg => "mb_msg", report_colours => 1), 
  "green: Speak \ngreen: to \ncyan: \@gavin\ngreen: , \ncyan: \@phil\ngreen: , \ngreen: and \ncyan: \@matt\ngreen: .\n",
  '@person embedded multiple ok');

# #hashtag
is(Clix::Colours::_colourise_msg("#clix rocks!",
    msg => "mb_msg", report_colours => 1), 
  "magenta: #clix \ngreen: rocks!\n", '#hashtag initial ok');
is(Clix::Colours::_colourise_msg("that would be #clix",
    msg => "mb_msg", report_colours => 1), 
  "green: that \ngreen: would \ngreen: be \nmagenta: #clix\n", '#hashtag final ok');
is(Clix::Colours::_colourise_msg("that would be #clix - the command line #xmpp client", 
    msg => "mb_msg", report_colours => 1), 
  "green: that \ngreen: would \ngreen: be \nmagenta: #clix \ngreen: - \ngreen: the \ngreen: command \ngreen: line \nmagenta: #xmpp \ngreen: client\n", '#hashtag multiple ok');

# URLs
is(Clix::Colours::_colourise_msg("http://www.openfusion.net/ rocketh!",
    msg => "mb_msg", report_colours => 1),
  "red: http://www.openfusion.net/ \ngreen: rocketh!\n",
  'URL initial ok');
is(Clix::Colours::_colourise_msg("clix was announced here: http://www.openfusion.net/net/clix", 
    msg => "mb_msg", report_colours => 1),
  "green: clix \ngreen: was \ngreen: announced \ngreen: here: \nred: http://www.openfusion.net/net/clix\n",
  'URL final ok');

