#/usr/bin/perl -w
package Model;

use strict;
use warnings;
use lib "lib";
use Mojo::Loader;
use Carp qw/croak/;
use File::ReadBackwards;
use Net::SSLeay qw(get_https make_headers);
binmode STDOUT,':encoding(utf8)';

# Reloadable Model
#my $modules = Mojo::Loader->search('Model');
#for my $module (@$modules) {
#  Mojo::Loader->load($module);
#}

my $chatlog;
my $filechat="btcechat.log";
my $urlchat='https://btc-e.com/ajax/chat.php';

#Net::SSLeay::set_proxy('10.0.24.154','3158');


sub init {
  my ( $class ) = @_;
  Net::SSLeay::set_proxy('10.0.24.154','3158');
  if (-e $filechat) {
  	my $bw = File::ReadBackwards->new( $filechat ) or
                        die "can't read $filechat $!" ;
	my $FH=$bw->get_handle;
	binmode $FH,':encoding(utf-8)';
        my $lnc=1;
	until ( $bw->eof || $lnc++>5) {
            print $bw->readline ;
    }
  } else {
  };

  return $chatlog;
}

1;
