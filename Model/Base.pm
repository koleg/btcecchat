package Model::Base;
use strict;
use warnings;
use base qw/Mojo::Base/;

#### Class Methods ####

sub sql {
  my ( $class,$query, $returnstyle, $close ) = (@_);
  my ( @SQLletRow, @result, @description );

  my $dbh = Model->db;
  my $dbhs = $dbh->prepare( $query, { odbc_exec_direct => 1 } );
  $dbhs->execute();

  if ( $dbhs->{Active} ) {

    do {

      while ( @SQLletRow = $dbhs->fetchrow_array() ) {
        for my $str (@SQLletRow) {
          #$str =~ s/[\x00-\x08\x0b\x0e-\x1f]//g;
          #$str =~ s/&(?![#x]?[0-9A-Za-z]+;)/&amp;/mg;
          #$str =~ s/\</\&lt;/mg;
          #$str =~ s/\>/\&gt;/mg;

          #eval("\$str = ${cs}2koi(\$str);");
        }

        push @result, [@SQLletRow];

        #}
      }

    } while ( $dbhs->{odbc_more_results} );

  }

  if ($close) {
    $dbh->disconnect();
    undef $dbh;
  }
  if ( ($returnstyle) && ( $returnstyle eq 'link' ) ) {
    return ( \@result, \@description );
  } else {
    return @result;
  }

}

1;
__END__
