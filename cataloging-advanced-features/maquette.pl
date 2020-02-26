

open (FIL,@ARGV[0]);

open (OUT,">cataloging-text-fields-advanced-features.html");


$trans{"222"}="Key title";
$trans{"245"}="Title Proper";
&reftags;
&bgref;
&scripts;



#print OUT "<link rel=stylesheet href=https://cdn.materialdesignicons.com/2.5.94/css/materialdesignicons.min.css>\n";

my $message = <<END_MESSAGE;

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://unpkg.com/buefy/dist/buefy.min.css">
	<script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
</head>

<body>
    <div id="app">

END_MESSAGE

print OUT "$message\n";
print OUT "<h3>ASSISTED FORM FOR TEXT FIELDS</h3><br/>";

coucou:
$n=0;
$numo=0;
read(FIL,$longueur,5);

if ($longueur eq "") {
goto fini;
}
undef(%tago);
undef(%ori);
$numnot++;
read (FIL,$buf,$longueur-5);
$notice=$longueur.$buf;
$lengrec=length($notice);

$leader=substr($notice,0,24);


$lenglabdir=substr($notice,12,5);
$lengdata=$lengrec-$lenglabdir;
$data=substr($notice,$lenglabdir,$lengdata);
$lengdir=$lenglabdir-25;
$direct=substr($notice,24,$lengdir);

$numtags=$lengdir/12;
$entry1=substr($direct,0,12);

for ($t=0;$t<$numtags;$t++) {
$entry=substr($direct,$t*12,12);
$tag=substr($entry,0,3);
$lengdat=substr($entry,3,4);
$startcar=substr($entry,7,5);
$entrydata=substr($data,$startcar,$lengdat);
chop($entrydata);
#print "$entrydata\n";
push (@{$tago{tags}{$tag}},$entrydata);


if ($tag eq "880" && $entrydata=~/\x1f6/) {
$entrydata=~/\x1f6...\-(..)/;
$back880=$1;
$ori{$back880}=$entrydata;
print "BACK880 $back880\n";
}
}

print OUT "\n<hr><H2><b>RECORD $numnot</b></h2>\n";

print OUT "\n\n<table width=80\%>\n";
&makeform_onerecord;
print OUT "</table>\n";

goto coucou;
fini:
close(FIL);

&end_form;

######################################################################################

sub makeform_onerecord {

foreach $tax (sort keys %{$tago{tags}}) {
if ($tax> 010 && $tax<900  && $tax !~/039|022|044|510|699|035|880/) {
foreach $entry (@{$tago{tags}{$tax}}) {
print "$tax $entry\n";
$field=$entry;

if ($tax ne "880" && $entry=~/\x1f6/) {
$entry=~/880\-(..)/;
$num880=$1;
$orifield=$ori{$num880};
print "ORIFIELD $num880 $orifield\n";
} else {
$orifield="";
}

$i1=substr($field,0,1);
$i2=substr($field,1,1);
$field=substr($field,2,);
$orifield=substr($orifield,2,);



$orifield=~/\x1f6[^\x1f]{7}(..)/;
$oriscript=$1;

$field=~s/\x1f6[^\x1f]*//;
$orifield=~s/\x1f6([^\x1f]*)//;


$field=~s/(\x1f.)/ $1 /g;
$field=~s/\x1f/\$/g;

$orifield=~s/(\x1f.)/ $1 /g;
$orifield=~s/\x1f/\$/g;


&second;

}

}
}

}
#############################################################################
sub end_form {

my $message2 = <<END_MESSAGE2;

</div>
</div>

    <script src="https://unpkg.com/vue"></script>
    <!-- Full bundle -->
    <script src="https://unpkg.com/buefy/dist/buefy.min.js"></script>

    <!-- Individual components -->
    <script src="https://unpkg.com/buefy/dist/components/table"></script>
    <script src="https://unpkg.com/buefy/dist/components/input"></script>

    <script>
        new Vue({
            el: '#app'
        })
    </script>
</body>
</html>

END_MESSAGE2

print OUT "$message2\n";

}
#############################################################################
sub premier {
#print OUT "<div class=\"columns\">\n";
#print OUT "<div class=\"column is-full\">\n";
print OUT "<div class=\"field is-expanded\">\n";
print OUT "<div class=\"field is-horizontal\">\n";

#print OUT "<div class=\"field is-floating-label\">";
#print OUT "<label class=\"label\">I1</label>";
#print OUT "<select label=\"I1\">";
#print OUT "<option>0</option>";
#print OUT "<option>1</option>";
#print OUT "<option>2</option>";
#print OUT "</select>";
#print OUT "</div>";

print OUT "<div  class=\"field is-floating-label\">";
print OUT "<label class=\"label\">$tax $trans{$tax}</label>";
print OUT "<b-input type=\"text\" value=\"$field\" expanded id=\"key-title\" name=\"keyTitle\"  label=\"$tax $trans{$tax}\" placeholder=\"\$a \$b\"></b-input>";
print OUT "</div>";


print OUT "<b-field label=\"Name\" :label-position=\"on-border\">            <b-input value=\"Kevin Garvey\"></b-input>   </b-field>\n";

print OUT "</div>";
print OUT "</div>";
#print OUT "</div>";

#print OUT "<b-field label=\"$tax\">\n";
#print OUT "<b-select >";
#print OUT "<option value=\"1\">1</option>";
#print OUT "<option value=\"2\">2</option>";
#print OUT "</b-select>";
#print OUT "<b-input value=\"$field\" label=\"$trans{$tax}\" :label-position=\"on-border\" expanded></b-input>\n";
#print OUT "</b-field>\n";
}
####################################################################################################################
sub second {
&bgref;
#print OUT "<tr style=\"background-color:$bg\;\">\n";
print OUT "<tr>\n";

print OUT "<td valign=top width=2\%>\n";

print OUT "<b-checkbox v-model=\"checkboxGroup\" native-value=\"Silver\"></b-checkbox>";
print OUT "</td>\n";

print OUT "<td width=3\%><font color=\"blue\"><b><b-tooltip position=\"is-right\" label=\"$tip{$tax}\" dashed>$tax</b-tooltip></b></font>\n";

print OUT "</td>\n";

print OUT "<td width=4\%>\n";
$refer="";
if ($ref{$tax."_".$i2} ne "") {$refer=$ref{$tax."_".$i2}}
if ($ref{$tax.$i1} ne "") {$refer=$ref{$tax.$i1}}
if ($refer eq "") {$refer=$ref{$tax}}

$i1=~s/ /\#/;
$i2=~s/ /\#/;

print OUT "<b-input type=\"text\" maxlength=\"2\" value=\"$i1$i2\"  id=\"key-title\" name=\"keyTitle\"></b-input>\n";


print OUT "</td>\n";
print OUT "<td width=90\%  style=\"height:10px\;\" style=\"vertical-align:top\">\n";



print OUT "<div  class=\"field is-floating-label\"  ><label class=\"label\" style=\"color:blue\">$refer</label>\n";
print OUT "<b-input type=\"text\"  style=\"min-height: 10px\" rows=\"1\" value=\"$field\" expanded id=\"key-title\" name=\"keyTitle\" placeholder=\"\$a \$b\"></b-input></div>\n";
if ($orifield ne "") {
$scriptos=$oriscript;


#print OUT "<div class=\"select is-fullwidth\">\n";
print OUT "<select>\n";

if ($oriscript eq "(3") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\(3\"  $selscript>Arabic</option>";
if ($oriscript eq "(B") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\(B\"  $selscript>Latin</option>";
if ($oriscript eq "\$1") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\$1\"  $selscript>CJK</option>";
if ($oriscript eq "(N") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\(N\"  $selscript>Cyrillic</option>";
if ($oriscript eq "(S") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\(S\"  $selscript>Greek</option>";
if ($oriscript eq "(2") {$selscript ="selected"} else {$selscript=""}
print OUT "<option value=\"\(2\"  $selscript>Hebrew</option>";
print OUT "</select>\n";
#print OUT "</div>\n";

print OUT "<b-input type=\"text\" style=\"min-height: 10px\"  rows=\"1\" value=\"$orifield\" expanded id=\"key-title\" name=\"keyTitle\" placeholder=\"\$a \$b\"></b-input>\n";
}
print OUT "</td><td  width=2\% >\n";
if ($tax!~/210|222|245|336|337|338/ ) {
print OUT "<i class=\"fas fa-plus\"></i>";
}
unless ($tax=~/041|082|33.|5..|210|856|76.|77.|78./ || $orifield ne "") {
print OUT "<font color=\"blue\"><b>&#937;</b></font>";
}

print OUT "</td></tr>\n";




}

##########################################################"
sub bgref {
$tip{"222"}="\$a : base of key title (NR) \$b: qualifier (NR)";
$tip{"245"}="\$a - Title (NR) \$n : Number of part/section of a work (R) \$p - Name of part/section of a work (R)"; 
}
#########################################################
sub reftags {
$ref{"030"}="CODEN DESIGNATION";
$ref{"041"}="LANGUAGE CODE";
$ref{"046"}="SPECIAL CODED DATES";
$ref{"080"}="UNIVERSAL DECIMAL CLASSIFICATION NUMBER";
$ref{"082"}="DEWEY DECIMAL CLASSIFICATION NUMBER";
$ref{"210"}="ABBREVIATED TITLE";
$ref{"222"}="KEY TITLE";
$ref{"245"}="TITLE STATEMENT";
$ref{"246"}="VARYING FORM OF TITLE";
$ref{"246_0"}="VARYING FORM OF TITLE - Portion of title";
$ref{"246_1"}="VARYING FORM OF TITLE - Parallel title";
$ref{"246_2"}="VARYING FORM OF TITLE - Distinctive title";
$ref{"246_3"}="VARYING FORM OF TITLE - Other title";
$ref{"246_4"}="VARYING FORM OF TITLE - Cover title";
$ref{"246_5"}="VARYING FORM OF TITLE - Added title page title";
$ref{"246_6"}="VARYING FORM OF TITLE - Caption title";
$ref{"246_7"}="VARYING FORM OF TITLE - Running title";
$ref{"246_8"}="VARYING FORM OF TITLE - Spine title";
$ref{"260"}="PUBLICATION, DISTRIBUTION, ETC. (IMPRINT)";
$ref{"260 "}="PUBLICATION, DISTRIBUTION, ETC. (IMPRINT) - Not applicable/No information provided/Earliest available publisher";
$ref{"2602"}="PUBLICATION, DISTRIBUTION, ETC. (IMPRINT) - Intervening publisher";
$ref{"2603"}="PUBLICATION, DISTRIBUTION, ETC. (IMPRINT) - Current/latest publisher";
$ref{"264"}="PRODUCTION, PUBLICATION, DISTRIBUTION, MANUFACTURE, AND COPYRIGHT NOTICE";
$ref{"321"}="FORMER PUBLICATION FREQUENCY";
$ref{"336"}="CONTENT TYPE";
$ref{"337"}="MEDIA TYPE";
$ref{"338"}="CARRIER TYPE";
$ref{"362"}="DATES OF PUBLICATION AND/OR SEQUENTIAL DESIGNATION";
$ref{"510"}="CITATION/REFERENCES NOTE";
$ref{"533"}="REPRODUCTION NOTE";
$ref{"538"}="SYSTEM DETAILS NOTE";
$ref{"588"}="SOURCE OF DESCRIPTION NOTE";
$ref{"710"}="ADDED ENTRY--CORPORATE NAME";
$ref{"711"}="ADDED ENTRY--MEETING NAME";
$ref{"720"}="ADDED ENTRY--UNCONTROLLED NAME";
$ref{"760"}="MAIN SERIES ENTRY";
$ref{"762"}="SUBSERIES ENTRY";
$ref{"765"}="ORIGINAL LANGUAGE ENTRY";
$ref{"767"}="TRANSLATION ENTRY";
$ref{"770"}="SUPPLEMENT/SPECIAL ISSUE ENTRY";
$ref{"772"}="SUPPLEMENT PARENT ENTRY";
$ref{"773"}="HOST ITEM ENTRY";
$ref{"774"}="CONSTITUENT UNIT ENTRY";
$ref{"775"}="OTHER EDITION ENTRY";
$ref{"776"}="ADDITIONAL PHYSICAL FORM ENTRY";
$ref{"777"}="ISSUED WITH ENTRY";
$ref{"780"}="PRECEDING ENTRY";
$ref{"780_0"}="PRECEDING ENTRY : Continues";
$ref{"780_1"}="PRECEDING ENTRY : Continues in part";
$ref{"780_2"}="PRECEDING ENTRY : Supersedes";
$ref{"780_3"}="PRECEDING ENTRY : Supersedes in part";
$ref{"780_4"}="PRECEDING ENTRY : Formed by the union of ... and ...";
$ref{"780_5"}="PRECEDING ENTRY : Absorbed";
$ref{"780_6"}="PRECEDING ENTRY : Absorbed in part";
$ref{"780_7"}="PRECEDING ENTRY : Separated from";
$ref{"785"}="SUCCEEDING ENTRY";
$ref{"785_0"}="SUCCEEDING ENTRY : Continued by";
$ref{"785_1"}="SUCCEEDING ENTRY : Continued in part by";
$ref{"785_2"}="SUCCEEDING ENTRY : Superseded by";
$ref{"785_3"}="SUCCEEDING ENTRY : Superseded in part by";
$ref{"785_4"}="SUCCEEDING ENTRY : Absorbed by";
$ref{"785_5"}="SUCCEEDING ENTRY : Absorbed in part by";
$ref{"785_6"}="SUCCEEDING ENTRY : Split into ... and ...";
$ref{"785_7"}="SUCCEEDING ENTRY : Merged with ... to form ...";
$ref{"785_8"}="SUCCEEDING ENTRY : Changed back to";
$ref{"786"}="DATA SOURCE ENTRY";
$ref{"787"}="OTHER RELATIONSHIP ENTRY";
$ref{"856"}="ELECTRONIC LOCATION AND ACCESS";
}

sub scripts {
$script{"(3"}="Arabic";
$script{"(B"}="Latin";
$script{"\$1"}="Chinese, Japanese, Korean";
$script{"(N"}="Cyrillic";
$script{"(S"}="Greek";
$script{"(2"}="Hebrew";

}