#!/usr/bin/perl

use warnings;
use strict;

use Crypt::Mode::CBC;
use MIME::Base64;


# key length has to be valid key size for this cipher
my $key =  '55a51621a6648525';
my $iv = '1234567890123456';  # 16 bytes

my $cadena ='VendorTxCode=TxCode-1310917599-223087284&Amount=36.95&Currency=GBP&Description=description&CustomerName=Fname Surname&CustomerEMail=customer@example.com&BillingSurname=Surname&BillingFirstnames=Fname&BillingAddress1=BillAddress Line 1&BillingCity=BillCity&BillingPostCode=W1A1BL&BillingCountry=GB&BillingPhone=447933000000&DeliveryFirstnames=Fname&DeliverySurname=Surname&DeliveryAddress1=BillAddress Line 1&DeliveryCity=BillCity&DeliveryPostCode=W1A1BL&DeliveryCountry=GB&DeliveryPhone=447933000000&SuccessURL=https://example.com/success&FailureURL=https://example.co/failure';

my $expected_start = '2DCD27338114D4C39';

sub crypt_mode {
    my $cipher = Crypt::Mode::CBC->new('AES');
    my $crypt = $cipher->encrypt($cadena , $key ,$iv) , '');
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


sub check_output {
    my $text = shift;
    print "$text\n";
    if ($text =~ /^$expected_start/) {
        print "Té bona pinta, comença igual\n";
    } else {
        print "ERROR. Hauria de començar per $expected_start\n";
    }
}

####################################################

crypt_mode();
