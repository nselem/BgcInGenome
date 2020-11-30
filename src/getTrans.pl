

#my $contigi=$ARGV[0];
#my $contigf=$ARGV[1];
my $numi=$ARGV[0];
my $numf=$ARGV[1];
my $file=$ARGV[2];
my $BGC=$ARGV[3];
my $window=$ARGV[4];  #window size
my $numWindow=$ARGV[5]; #Number of windows
my $function=$ARGV[6]; #Function to search 
#print "$numi $numf $file $BGC \n";
#exit;
#$window=10;
#$numWindow=4;
#---------------------------------------
#print " contig $contigi $contigf\n";
#print " numero $numi $numf\n";

my $totalTransporter= get_transporter($numi,$numf,$file,$BGC);
print "$totalTransporter\n";

sub get_transporter(){
my $numi=shift;
my $numf=shift;
my $file=shift;
my $BGC=shift;

my $result="$BGC";
my $transporters="0";
my $line0i=`grep "\.peg.$numi\t" GENOMES/$file\.txt`;
my $line0f=`grep "\.peg.$numf\t" GENOMES/$file\.txt`;
my @sp0i=split('\t',$line0i);
my @sp0f=split('\t',$line0f);
my $contigi=$sp0i[0];
my $contigf=$sp0f[0];

#print "$contigi";


if ( "$contigi" eq "$contigf" ){

	for  (my $i=0; $i <= $numWindow; $i++){
		if ($i==0){
			for (my $id=$numi; $id<=$numf; $id++){
				#print "id $id i = $i \n"
				my $line=`grep "\.peg.$id\t" GENOMES/$file\.txt`;
				my @sp=split('\t',$line);
				if($sp[0] eq $contigi and $sp[7]=~m/$function/ ){
					$transporters++;
					#print"$sp[7]\n";
					}
				}
			}
		else { 
			for  (my $j=0; $j <= $window; $j++){
				$atras=$numi-($i-1)*10-$j;
				$adelante=$numf+($i-1)*10+$j;
				#print "$atras, $adelante\n";
				my $linei=`grep "\.peg.$atras\t" GENOMES/$file\.txt`;
				my $linef=`grep "\.peg.$atras\t" GENOMES/$file\.txt`;

				#Obtener contig
				#Obtener funcion

				my @spi=split('\t',$linei);
				my @spt=split('\t',$linet);

				if($spi[0] eq $contigi and $spi[7]=~m/$function/ ){
						$transporters++;
						#print"$spi[7]\n";
						} 
				if($spt[0] eq $contigf and $spf[7]=~m/$function/ ){
					$transporters++;
						#print"$spt[7]\n";
						}
				#print "$spt[0] \t $spt[7]\n";
				}
			}
	$result	= $result."\t".$transporters;
	#print "window $i result $result\n";	
		}
}
else{
	print "Best Hits are not in the same contig\n";
	exit;
	}
	#	print "$result\n";
	return $result;
}
#0	n0
#10	n1
#20	n2
#30	n3
# si estan en el mismo contig y a menos de 50 genes
# buscar anotaciones, if tranporter inside 0
# if +-5 5 until +-50 and same contig
