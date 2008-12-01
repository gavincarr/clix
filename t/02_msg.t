# Test colourise_msg

use strict;
use warnings;
use Test::More tests => 9;
use Clix qw(_colourise_msg);

# Simple
is(_colourise_msg("foo", base => "im_base", report_colours => 1), 
  "magenta: foo\n", 'report_colours ok');

# @person
is(_colourise_msg("\@gavin Totally!", 
  base => "mb_base", report_colours => 1), 
  "magenta: \@gavin \ngreen: Totally!\n", '@person initial ok');
is(_colourise_msg("\@gavin \@phil Totally agree of course!", 
  base => "mb_base", report_colours => 1), 
  "magenta: \@gavin \nmagenta: \@phil \ngreen: Totally \ngreen: agree \ngreen: of \ngreen: course!\n", 
  '@person initial multiple ok');
is(_colourise_msg("Speak to \@gavin, \@phil, and \@matt.", 
  base => "mb_base", report_colours => 1), 
  "green: Speak \ngreen: to \nmagenta: \@gavin\ngreen: , \nmagenta: \@phil\ngreen: , \ngreen: and \nmagenta: \@matt\ngreen: .\n",
  '@person embedded multiple ok');

# #hashtag
is(_colourise_msg("#clix rocks!", base => "mb_base", report_colours => 1), 
  "cyan: #clix \ngreen: rocks!\n", '#hashtag initial ok');
is(_colourise_msg("that would be #clix", base => "mb_base", report_colours => 1), 
  "green: that \ngreen: would \ngreen: be \ncyan: #clix\n", '#hashtag final ok');
is(_colourise_msg("that would be #clix - the command line #xmpp client", 
  base => "mb_base", report_colours => 1), 
  "green: that \ngreen: would \ngreen: be \ncyan: #clix \ngreen: - \ngreen: the \ngreen: command \ngreen: line \ncyan: #xmpp \ngreen: client\n", '#hashtag multiple ok');

# URLs
is(_colourise_msg("http://www.openfusion.net/ rocketh!",
  base => "mb_base", report_colours => 1),
  "red: http://www.openfusion.net/ \ngreen: rocketh!\n",
  'URL initial ok');
is(_colourise_msg("clix was announced here: http://www.openfusion.net/net/clix", 
  base => "mb_base", report_colours => 1),
  "green: clix \ngreen: was \ngreen: announced \ngreen: here: \nred: http://www.openfusion.net/net/clix\n",
  'URL final ok');

