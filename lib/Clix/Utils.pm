#!/usr/bin/perl
#
# clix utility routines
#

package Clix::Utils;

use strict;
use Exporter::Lite;
use Regexp::Common qw(URI microsyntax);
use Time::Piece;
use Carp;

use Clix::Colours qw(colour_print);

our @EXPORT = ();
our @EXPORT_OK = qw(
  tokenise_msg
  prep_msg
  print_msg
);

# Return an array of tokens (hashrefs) for $msg
sub tokenise_msg {
  my ($msg, $msg_type) = @_;
  $msg_type ||= 'im_msg';

  my @token;
  TOKEN: {
    push(@token, { text => $1, type => 'person' }),     redo TOKEN
      if $msg =~ m/\G( $RE{microsyntax}{user} \s* )/gcx;
    push(@token, { text => $1, type => 'hashtag' }),    redo TOKEN
      if $msg =~ m/\G( $RE{microsyntax}{hashtag} \s* )/gcx;
    push(@token, { text => $1, type => 'group' }),      redo TOKEN
      if $msg =~ m/\G( $RE{microsyntax}{grouptag} \s* )/gcx;
    push(@token, { text => $1, type => 'uri' }),        redo TOKEN
      if $msg =~ m/\G( $RE{URI} \s* )/gcx;
    push(@token, { text => $1, type => $msg_type }),    redo TOKEN
      if $msg =~ m/\G( (?: \w+|\S ) \s* )/gcx;
  }

  # Coalese tokens of the same type
  my @coalesced;
  for (@token) {
    # Push first
    if (! @coalesced) {
      push @coalesced, $_;
    }
    # Append if same type as last, otherwise push
    else {
      if ($coalesced[$#coalesced]->{type} eq $_->{type}) {
        $coalesced[$#coalesced]->{text} .= $_->{text};
      }
      else {
        push @coalesced, $_;
      }
    }
  }
 
  return @coalesced;
}

# Return an array of elements (hashrefs) representing $msg
sub prep_msg {
  my ($msg, %opts) = @_;
  my $mapped_jid  = $opts{mapped_jid};
  my $mb_username = $opts{mb_username};
  my $msg_type;

  my @output;
  push @output, { text => localtime->strftime('%T '), type => 'timestamp' };
  push @output, { text => "[$mapped_jid] ", type => 'from_jid' } if $mapped_jid;

  # Parse out leading username on microblog messages
  if ($mb_username) {
    my $username = '';
    if ($msg =~ m/^\s*(\S+)\s+(.*?)$/s) {
      my $first_chunk = $1;
      my $rest = $2;
      $username = '';

      if ($first_chunk =~ m/^ ([-\w]+):$/x ||
          $first_chunk =~ m/^<([-\w]+)>$/x) {
        $username = $1;
        $msg = $rest;
        push @output, { text => "\@$username ", type => 'mb_sender' };
      }
    }

    # Set mb msg_type
    if ($username && $username eq $mb_username) {
      $msg_type = 'mb_mine';
    }
    elsif ($msg =~ m/\@$mb_username\b/) {
      $msg_type = 'mb_reply';
    }
    else {
      $msg_type = 'mb_msg';
    }
  }
  else {
    $msg_type = 'im_msg';
  }

  push @output, tokenise_msg($msg, $msg_type);

  return @output;
}

# Prep and output colourised $msg
sub print_msg {
  my ($msg, %opts) = @_;
  my @output = prep_msg($msg, %opts);
  colour_print(@output);
}

1;

