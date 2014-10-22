#!/usr/bin/perl -w

require "Languages.inc"; # �������� @AvailableLangs
my $AcceptLang=$ENV{HTTP_ACCEPT_LANGUAGE};

#print "content-type: text/html\n\n";

if ( $AcceptLang ) { # ���� ���������� HTTP-ACCEPT-LANGUAGE �� �������� ��������
# ���������� ������ @AvailableLangs � �������, ��� ������ ��������� �� ������ ����
  for  ( @{$AvailableLangs} ) {
   if ($AcceptLang=~/$_/ ) { $DefaultLang=$_; last;}
  }
}

( $ScriptPath )=( $ENV{SCRIPT_NAME} =~ m|(/.*/)(.*)$| );
#print "Refresh: 0; url=$ScriptPath$DefaultLang\n\n";
print "Location: $ScriptPath$DefaultLang\n\n";



