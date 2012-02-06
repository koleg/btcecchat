use strict;
use warnings;
use lib "lib";
use URI;
use LWP::UserAgent;
use Crypt::SSLeay;
use Web::Scraper;
use YAML;


use IO::Socket::SSL  "inet4";


my $user = scraper {
    process 'a',"user[]" => { name =>'TEXT', date => '@title' };
    result "user";
};



my $chat = scraper {
    process 'p',"messages[]" => { text =>'TEXT', user => $user };
    result "messages";
};


my $url='https://btc-e.com/ajax/chat.php';
my $request = HTTP::Request->new( GET => $url);
my $ua = LWP::UserAgent->new;
$ua->default_header('Accept-Language' => "no, ru");
my $response = $ua->request($request);
my $res = $chat->scrape($response);

use YAML;
warn Dump $res;
