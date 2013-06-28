#!/usr/bin/perl;
use strict;
use Win32::Clipboard;

my $clip               = Win32::Clipboard();
my $text               = '';
my $handle_this_change = 1;
my $head               = ("-" x 31). "[ Clipboard Text ]". ("-" x 30);

print <<INFO;
===============================================================================
                          Clipboard Text Joiner
         Monitoring system clipboard change and joining multi-line text
               
                    by Wei Shen <shenwei356\@gmail.com>
                               2013-06-28
===============================================================================

INFO

while (1) {
    if (
        $clip->WaitForChange()     # clipboard changed
        and $handle_this_change    # handle this change
      )
    {
        next unless $clip->IsText();    # only text will be edited
        $text = $clip->GetText();       # get text from clipboard
        $text = &edit_text($text);      # edit text
        $handle_this_change = 0;        # to ignore this change
        $clip->Set($text);              # write back to clipboard
    }
    else {
        $text = $clip->GetText();       # show edited text
        print "\n$head\n$text\n";
        $handle_this_change = 1;        # handle next change
    }
}

sub edit_text {
    my ($text) = @_;
    $text =~ s/-\r?\n\s*/-/gs;
    $text =~ s/([^\-])\r?\n\s*/$1 /gs;
    $text =~ s/\s+/ /gs;
    return $text;
}
