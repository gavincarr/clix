#!/usr/bin/perl
#
# Colour routines for clix, the command-line XMPP client
#

package Clix;

use strict;

use Exporter::Lite;
use Term::ANSIColor;
use Term::Size;
use Time::Piece;
use Carp;

our @EXPORT = qw(colourise);
our @EXPORT_OK = qw(colourise);

sub _colourise_msg {
  my ($msg, $base_colour) = @_;
  print color $base_colour;
  print $msg;
}

# Colourise and print a given message
sub colourise {
  my ($msg, %opts) = @_;
  my $jid = delete $opts{jid};
  my $mapped_jid = delete $opts{mapped_jid};
  my $mb_username = delete $opts{mb_username};
  croak "Invalid options to colourise: " . join(',',keys %opts) if keys %opts;

  print color 'white';
  printf "(%s) ", localtime->strftime('%T');

  print color 'cyan';
  printf "[%s] ", $mapped_jid;

  # If this is a microblog account, we jump through special hoops
  if ($mb_username) {
    if ($msg =~ m/^(([-\w]+):\s*)(.*?)$/s) {
      print color 'yellow';
      print $1;
      my $username = $2;
      if ($username eq $mb_username) {
        _colourise_msg( $3, 'white' );
      }
      elsif ($msg =~ m/\@$mb_username\b/) {
        _colourise_msg( $3, 'red' );
      }
      else {
        _colourise_msg( $3, 'green' );
      }
    }
    else {
      _colourise_msg( $msg, 'green' );
    }
  }
  
  else {
    _colourise_msg( $msg, 'magenta' );
  }

  print color 'reset';
  print "\n";
}

1;

