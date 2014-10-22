#!/usr/bin/perl -w
use lib "/home/christ/MyPerlLib";
use Lingua::DetectCyrillic qw ( &toLowerCyr &toUpperCyr &TranslateCyr %RusCharset );
use Benchmark;

# ����������� ���������� ���������. �� ����� �� ������� ������������ CGI.pm �� 240 ��!
for ( split("&",$ENV{QUERY_STRING} ) ) {
  my ($key,$value) = split("=",$_);  $QStringData{$key} = $value; }

$Text_area = $QStringData{Text_area};
$Text_area =~ s/%([A-Fa-f\d]{2})/chr hex $1/eg; # unescape the string
$Text_area =~ s/\+/ /g; # remove plus signs

$MaxTokens = $QStringData{MaxTokens};
$DetectAllLang = $QStringData{DetectAllLang};

$CyrDetector = Lingua::DetectCyrillic ->new( MaxTokens => $MaxTokens, DetectAllLang => $DetectAllLang );
$timestart=new Benchmark;
( $Coding,$Language,$CharsProcessed, $Algorithm )= $CyrDetector -> Detect($Text_area);
#$CyrDetector -> LogWrite("test_log.log");
$timedf=timestr(timediff(new Benchmark,$timestart));

$Charset = $Coding;

#��������� ���������� ������� � ���� ��������, �� �������� ������ ������
$ENV{HTTP_REFERER} =~ m|(.*$ENV{HTTP_HOST})(.*/)(.*)$| ;
$Inc .=$ENV{DOCUMENT_ROOT} .$2. "DetectCyrillic_test.inc";

if ( $Language eq "NoLang" ) {
  $DocTitle = "Detection of Language and Coding";
  # ������� ������� ���� �� en
  ($IncAlt=$Inc) =~ s#(/ru/|/uk/)#/en/#;

  if ( -e $IncAlt ) {
  # ���� ���������� ����� ����, ���������� ���, ����� - �������������
  # ������������� windows-1251
   $Inc = $IncAlt;
   print  "Content-Type: text/html; charset=iso-8859-1\n\n";
    } else {
   print  "Content-Type: text/html; charset=windows-1251\n\n";
  }


} else {
  $DocTitle = TranslateCyr(win,$Charset,"����������� ��������� � �����");
  $Text_area_win = TranslateCyr($Charset,"windows-1251",$Text_area);
  $Text_area_koi8r = TranslateCyr($Charset,"koi8-r",$Text_area);
  $Text_area_koi8u = TranslateCyr($Charset,"koi8-u",$Text_area);
  $Text_area_utf = TranslateCyr($Charset,"utf-8",$Text_area);
  $Text_area_cp866 = TranslateCyr($Charset,"cp866",$Text_area);
  $Text_area_iso = TranslateCyr($Charset,"iso-8859-5",$Text_area);
  $Text_area_mac = TranslateCyr($Charset,"x-mac-cyrillic",$Text_area);
  print  "Content-Type: text/html; charset=$Charset\n\n";

}

require $Inc;

