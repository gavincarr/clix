#!/usr/bin/perl
#
# Colour routines for clix, the command-line XMPP client
#

package Clix::Colours;

use strict;

use Exporter;
use Term::ANSIColor;
use Time::Piece;
use Carp;
use Regexp::Common qw(URI);

our @EXPORT = ();
our @EXPORT_OK = qw(merge_colours colourise);

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
  group         => 'magenta',
);

sub merge_colours {
  my ($user_colours) = @_;
  @COLOUR{ keys %$user_colours } = values %$user_colours;
}

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
  my $msg_colour = delete $opts{msg} || 'im_msg';
  my $report_colours = delete $opts{report_colours};
  croak "Invalid msg colour: $msg_colour" unless exists $COLOUR{$msg_colour};
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
    $out .= _colourise_snippet($1, $COLOUR{group}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G(![-\w.]+\s*)/gc;
    $out .= _colourise_snippet($1, $COLOUR{uri}, report_colours => $report_colours),
      redo TOKEN
        if $msg =~ m/\G($RE{URI}\s*)/gc;
    $out .= _colourise_snippet($1, $COLOUR{$msg_colour}, report_colours => $report_colours),
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
      $msg = $3;
      if ($username eq $mb_username) {
        _colourise_msg( $msg, msg => 'mb_mine');
      }
      elsif ($msg =~ m/\@$mb_username\b/) {
        _colourise_msg( $msg, msg => 'mb_reply' );
      }
      else {
        _colourise_msg( $msg, msg => 'mb_msg' );
      }
    }
    else {
      _colourise_msg( $msg, msg => 'mb_msg' );
    }
  }
  
  else {
    _colourise_msg( $msg, msg => 'im_msg' );
  }

  print color 'reset';
  print "\n";
}

1;

