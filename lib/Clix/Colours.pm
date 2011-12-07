#!/usr/bin/perl
#
# Colour routines for clix, the command-line XMPP client
#

package Clix::Colours;

use strict;
use Exporter::Lite;
use Term::ANSIColor;

our @EXPORT = ();
our @EXPORT_OK = qw(
  merge_colours
  colour_print
);

my %COLOUR = (
  timestamp     => 'white',
  from_jid      => 'cyan',
  mb_sender     => 'yellow',
  im_msg        => 'green',
  mb_msg        => 'green',
  mb_reply      => 'red bold',
  mb_mine       => 'white bold',
  uri           => 'red',
  person        => 'cyan',
  hashtag       => 'magenta',
  group         => 'yellow',
);

sub merge_colours {
  my ($user_colours) = @_;
  @COLOUR{ keys %$user_colours } = values %$user_colours;
}

# Colourise and print the given set of hashref (text,type) elements
sub colour_print {
  my @elts = @_;

  for my $elt (@elts) {
    print color($COLOUR{ $elt->{type} } || 'white');
    print $elt->{text};
  }

  print color 'reset';
  print "\n";
}

1;

