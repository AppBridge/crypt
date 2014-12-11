#!/usr/bin/perl

use warnings;
use strict;

use Crypt::Mode::CBC;
use MIME::Base64;

# key length has to be valid key size for this cipher
my $KEY =  '55a51621a6648525';

# això m'ho invento, necessitem el iv
my  $IV = '1234567890123456';  # 16 bytes

my $CADENA ='VendorTxCode=TxCode-1310917599-223087284&Amount=36.95&Currency=GBP&Description=description&CustomerName=Fname Surname&CustomerEMail=customer@example.com&BillingSurname=Surname&BillingFirstnames=Fname&BillingAddress1=BillAddress Line 1&BillingCity=BillCity&BillingPostCode=W1A1BL&BillingCountry=GB&BillingPhone=447933000000&DeliveryFirstnames=Fname&DeliverySurname=Surname&DeliveryAddress1=BillAddress Line 1&DeliveryCity=BillCity&DeliveryPostCode=W1A1BL&DeliveryCountry=GB&DeliveryPhone=447933000000&SuccessURL=https://example.com/success&FailureURL=https://example.co/failure';

my $FILE_EXPECTED = 'expected.txt';
my ($EXPECTED,$EXPECTED_START);

###################################################################################

sub crypt_mode {
    my $cipher = Crypt::Mode::CBC->new('AES');
    my $crypt = $cipher->encrypt($CADENA, $KEY ,$IV);
    my $hex = bin2hex($crypt);
    check_output($hex);
}

sub bin2hex {
    my $bin = shift;
    my $out = '';
    for (split //,$bin)
    {
        $out .= uc(sprintf("%02lx", ord $_));
    }
    return $out;
}

sub init_expected_text {
    open my $in,'<',$FILE_EXPECTED or die "$! $FILE_EXPECTED";

    $EXPECTED ='';
    while (<$in>) {
        chomp;
        $EXPECTED .= $_;
    }
    ($EXPECTED_START) = $EXPECTED =~ m{(^.{10})};
}

sub check_output {
    my $text = shift;
    if ($text =~ /^$EXPECTED_START/) {
        print "Té bona pinta, comença igual\n";
        if ($text eq $EXPECTED) {
            print "OK tot.\n" 
        } else {
            print "ERROR. No coincideix\ntext:\n$text\nesperat:\n$EXPECTED\n";
        }
    } else {
        print "ERROR. Hauria de començar per $EXPECTED_START\n$text\n";
    }
}

####################################################

init_expected_text();
crypt_mode();
