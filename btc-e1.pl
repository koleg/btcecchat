use strict;
use warnings;
use lib "lib";
use URI;
use Net::SSLeay qw(get_https make_headers);
use Crypt::SSLeay;
use Web::Scraper;
use YAML;

my $user = scraper {
    process 'a',"user[]" => { name =>'TEXT', date => '@title' };
    result "user";
};



my $chat = scraper {
    process 'p',"messages[]" => { text =>'TEXT', user => $user };
    result "messages";
};


my $url='https://btc-e.com/ajax/chat.php';

Net::SSLeay::set_proxy('10.0.24.154','3158');
my ($page, $response, %reply_headers)
         = get_https('btc-e.com', 443, '/ajax/chat.php',
                make_headers('User-Agent' => 'Cryptozilla/5.0b1',
                             'Accept-Language' => 'no, ru'
                ));

my $res = $chat->scrape($page);

foreach my $mess (@{$res}) {
print $mess->{text}."\n";
print $mess->{user}->[0]->{date}."\n";
};

use YAML;
warn Dump $res;
