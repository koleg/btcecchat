#!/usr/bin/env perl
  use lib "lib";
  use Net::SSLeay qw(get_https make_headers);
  use AnyEvent;
  use Web::Scraper;
  use Mojo::IOLoop;
  use Mojolicious::Lite;

#--------------------------------------- begin init
  # Timer example
  my $t = 0;
  my %chatlog;
  open(FHLw,">","btcechat.log");

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
#-------------------------------------- end init


#--------------------------------------- begin web

  get '/' => sub { shift->render_text("btc-e chat log") };

#--------------------------------------- end web


#--------------------------begin parser

  # Connect Mojo::IOLoop with AnyEvent
  my $w;
  Mojo::IOLoop->recurring(0 => sub {
    $w = AnyEvent->timer(
      after    => 0,
      interval => '30.11',
      cb       => sub { 

		my ($page, $response, %reply_headers)
		         = get_https('btc-e.com', 443, '/ajax/chat.php',
                		make_headers('User-Agent' => 'Cryptozilla/5.0b1',
		                             'Accept-Language' => 'no, ru'
                	));

		my $res = $chat->scrape($page);
		foreach my $mess (@{$res}) {
			if(not defined $chatlog{$mess->{'user'}->[0]->{'date'}}) {
				$chatlog{$mess->{'user'}->[0]->{'date'}}=$mess->{'user'}->[0]->{name};
				#print FHLw $mess->{'user'}->[0]->{'date'}."|".$mess->{user}->[0]->{name}."|".$mess->{text}."\n";
				syswrite FHLw, $mess->{'user'}->[0]->{'date'}."|".$mess->{user}->[0]->{name}."|".$mess->{text}."\n";
			}
		};

	}
    ) unless $w;
    AnyEvent->one_event;
  });
#------------------------------end parser


  app->start;