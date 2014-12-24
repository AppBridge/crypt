#!/usr/bin/perl

use warnings;
use strict;

use eBD::Process;

use Crypt::CBC;
#use Crypt::Mode::CBC;
use DBI;

# key length has to be valid key size for this cipher
my $TABLE = 'compra';
my $FIELD_SRC = 'cadena';
my $FIELD_DST = 'encrypt';

my $KEY =  '55a51621a6648525';

my  $IV = $KEY;
my $LOG;

my $FILE_LOG = $0;
$FILE_LOG =~ s{.*/}{};
$FILE_LOG = "/var/tmp/$FILE_LOG.log";

########################################################################

sub crypt_mode {
    my $cadena = shift;
    print "Crypt::Mode::CBC\n";
    my $cipher = Crypt::Mode::CBC->new('AES');
    my $crypt = $cipher->encrypt($cadena, $KEY ,$IV);
    check_output( bin2hex($crypt));
}

sub crypt_cbc {
    my $cadena = shift;
    print "Crypt::CBC\n";
    my $cipher = Crypt::CBC->new( -key    => $KEY
        , -iv => $KEY
        , -cipher => 'OpenSSL::AES'
        , -literal_key => 1
        , -header => 'none'
        , -keysize => 16
    );
    my $encrypted = $cipher->encrypt($cadena);
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

sub select_cadena {
    my ($dbh, $id) = @_;
    my $sth = $dbh->prepare(
        "SELECT _idRegistro,$FIELD_SRC FROM $TABLE "
        ." WHERE _idRegistro=?"
    );
    $sth->execute($id);
    my ($id_registro, $cadena) = $sth->fetchrow;
    $sth->finish;
    if (!$id_registro) {
        my $msg = "ERROR: No existe registro $id en tabla $TABLE";
        print_log($msg);
        die $msg;
    }

    if ( !$cadena ) {
        my $msg = "WARNING: Cadena vacia id=$id en tabla $TABLE";
        print_log($msg);
        warn($msg);
    }
}

sub encrypt_cadena {
    my $dbh = open_dbh();
    my $id = $ARGV[0];
    my $cadena = select_cadena($dbh,$id);
    my $encrypt = crypt_cbc($cadena);
    my $sth = $dbh->prepare(
        "UPDATE $TABLE "
        ." SET $FIELD_DST=? "
        ." WHERE _idRegistro=? "
    );
    $sth->execute($encrypt, $id);
    $sth->finish;
}
####################################################

#log_env();
print_log(" argv = ".join(" , ",@ARGV));
encrypt_cadena();
