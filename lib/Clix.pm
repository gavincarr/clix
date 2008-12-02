#!/usr/bin/perl
#
# Colour routines for clix, the command-line XMPP client
#

package Clix;

use strict;

use Exporter;
use Term::ANSIColor;
use Time::Piece;
use Carp;
use Regexp::Common qw(URI);

our @EXPORT = qw(colourise);
our @EXPORT_OK = qw(colourise _colourise_msg _colourise_snippet);

my %COLOUR = (
  mb_mine       => 'white',
  mb_reply      => 'green bold',
  mb_base       => 'green',
  im_base       => 'yellow',
  uri           => 'red',
  im_base_uri   => 'green',
  person        => 'magenta',
  hashtag       => 'cyan',
  timestamp     => 'white',
  from_jid      => 'cyan',
  mb_sender     => 'yellow',
);

sub _colourise_snippet {
  my ($snippet, $colour, %opts) = @_;
  my $report_colours = delete $opts{report_colours};
  croak "Invalid options to _colourise_snippet: " . join(',',keys %opts) if keys %opts;

  if ($report_colours) {         # Testing
    return "$colour: $snippet\n";
  }
  else {
    return color($colour) . $snippet;
  }
}

sub _colourise_msg {
  my ($msg, %opts) = @_;
  my $base_colour = delete $opts{base} || 'im_base';
  my $report_colours = delete $opts{report_colours};
  croak "Invalid base colour: $base_colour" unless exists $COLOUR{$base_colour};
  croak "Invalid options to _colourise_msg: " . join(',',keys %opts) if keys %opts;

  # Tokenise $msg into snippets
  my $out = '';
  TOKEN: {
    $out .= _colourise_snippet($1, $COLOUR{person}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G(\@#?[-\w]+\s*)/gc;
    $out .= _colourise_snippet($1, $COLOUR{hashtag}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G(\#[-\w.]+\s*)/gc;
    $out .= _colourise_snippet($1, $COLOUR{uri}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G($RE{URI}\s*)/gc;
    $out .= _colourise_snippet($1, $COLOUR{$base_colour}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G(\S+\s*)/gc;
  }
 
  return $out if $report_colours;
  print $out;
}

# Colourise and print a given message
sub colourise {
  my ($msg, %opts) = @_;
  my $jid = delete $opts{jid};
  my $mapped_jid = delete $opts{mapped_jid};
  my $mb_username = delete $opts{mb_username};
  croak "Invalid options to colourise: " . join(',',keys %opts) if keys %opts;

  print color $COLOUR{timestamp};
  printf "%s ", localtime->strftime('%T');

  print color $COLOUR{from_jid};
  printf "[%s] ", $mapped_jid;

  # If this is a microblog account, we jump through special hoops
  if ($mb_username) {
    if ($msg =~ m/^(([-\w]+):\s*)(.*?)$/s) {
      print color $COLOUR{mb_sender};
      print $1;
      my $username = $2;
      if ($username eq $mb_username) {
        _colourise_msg( $3, base => 'mb_mine');
      }
      elsif ($msg =~ m/\@$mb_username\b/) {
        _colourise_msg( $3, base => 'mb_reply' );
      }
      else {
        _colourise_msg( $3, base => 'mb_base' );
      }
    }
    else {
      _colourise_msg( $msg, base => 'mb_base' );
    }
  }
  
  else {
    _colourise_msg( $msg, base => 'im_base' );
  }

  print color 'reset';
  print "\n";
}

1;

