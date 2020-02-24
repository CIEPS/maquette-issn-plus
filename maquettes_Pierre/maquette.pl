

open (FIL,@ARGV[0]);

open (OUT,">form.html");


$trans{"222"}="Key title";
$trans{"245"}="Title Proper";
&reftags;
&bgref;



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

print OUT "\n<H2><b>RECORD $numnot</b></h2>\n";

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

$field=~s/\x1f6[^\x1f]*//;
$orifield=~s/\x1f6[^\x1f]*//;

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

$i1=~s/ /\#/;
$i2=~s/ /\#/;

print OUT "<b-input type=\"text\" maxlength=\"2\" value=\"$i1$i2\"  id=\"key-title\" name=\"keyTitle\"></b-input>\n";


print OUT "</td>\n";
print OUT "<td width=92\%  style=\"height:10px\;\" style=\"vertical-align:top\">\n";

print OUT "<div  class=\"field is-floating-label\"  ><label class=\"label\" style=\"color:blue\">$ref{$tax}</label>\n";
print OUT "<b-input type=\"text\"  style=\"min-height: 10px\" rows=\"1\" value=\"$field\" expanded id=\"key-title\" name=\"keyTitle\" placeholder=\"\$a \$b\"></b-input></div>\n";
if ($orifield ne "") {
print OUT "<b-input type=\"text\" style=\"min-height: 10px\"  rows=\"1\" value=\"$orifield\" expanded id=\"key-title\" name=\"keyTitle\" placeholder=\"\$a \$b\"></b-input>\n";
}

print OUT "</td><td><i class=\"fas fa-plus\"></i></td>\n";
print OUT "</tr>\n";




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
$ref{"260"}="PUBLICATION, DISTRIBUTION, ETC. (IMPRINT)";
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
$ref{"785"}="SUCCEEDING ENTRY";
$ref{"786"}="DATA SOURCE ENTRY";
$ref{"787"}="OTHER RELATIONSHIP ENTRY";
$ref{"856"}="ELECTRONIC LOCATION AND ACCESS";



}