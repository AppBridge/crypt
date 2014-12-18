#!/usr/bin/perl

use warnings;
use strict;

use Crypt::CBC;
#use Crypt::Mode::CBC;
use DBI;

# key length has to be valid key size for this cipher
my $KEY =  '55a51621a6648525';
my  $IV = $KEY;
my $DBH;

###################################################################################

#sub crypt_mode {
#    print "Crypt::Mode::CBC\n";
#    my $cipher = Crypt::Mode::CBC->new('AES');
#    my $crypt = $cipher->encrypt($CADENA, $KEY ,$IV);
#    return bin2hex($crypt);
#}

sub get_text {
    my %vars = @ARGV;
    my $ret = '';
    for (sort keys %vars) {
        $ret .= '&' if $ret;
        $ret .= "$_=$vars{$_}";
    }
    die $ret;
    return $ret;
}

sub crypt_cbc {
    my $text = get_text();
    my $cipher = Crypt::CBC->new( 
          -key => $KEY
        , -iv  => $KEY
        , -cipher => 'OpenSSL::AES'
        , -literal_key => 1
        , -header => 'none'
        , -keysize => 16
    );
    my $encrypted = $cipher->encrypt($text);
#    my $base64 = encode_base64($encrypted);
    return bin2hex($encrypted);
}


sub bin2hex {
    my $bin = shift;
    my $out = '';
    for (split //,$bin) {
        $out .= uc(sprintf("%02lx", ord $_));
    }
    return $out;
}

sub init_dbh {
    my ($user,$pass) = get_user_pass();
}

sub get_user_pass {
    my @user = getpwuid($>);
    my $home = $user[7];

    my %result;
    open my $cnf,'<',"$home/.my.cnf" or return($user[0],'');
    my $client=0;
    while (<$cnf>) {
        s/^\s+//;
        chomp;
        last if $client && /^\[/;
        $client++ if /^\[client/;
        next if !$client;
        my ($name,$value) = /^(.*?)\s*=\s*(.*)/;
        $result{$name} = $value if $name && $value;
        last if $result{user} && $result{pass};
    }
    close $cnf;
    $result{user} = $user[0]    if !$result{user};
    $result{pass} = ''          if !$result{pass};
    return ($result{user}, $result{pass});
}

####################################################

my $ID = shift @ARGV or die "$0 id\n";
init_dbh();
crypt_cbc();
