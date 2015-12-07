#!/usr/local/bin/perl


print "\n#---------------------------------------------#\n|        Ferret        ||    Ferret_v1.pl     |\n#---------------------------------------------#\n| Contact (Sophie Limou): ferret\@nih.gov      |\n| URL: http://limousophie35.github.io/Ferret  |\n#---------------------------------------------#\n| This version queries the 1KG Phase 3 data   |\n| located in the ftp 20130502 folder that was |\n| last updated on May 27th, 2015.             |\n#---------------------------------------------#\n\n";


if ($ARGV[0] eq ""){die "!! ERROR !!\n\nUSAGE: perl Ferret_v1.pl \n  -chr [chromosome]\n  -ini [chromosome start position hg19/GRCh37]\n  -end [chromosome stop position hg19/GRCh37]\n  -pop [population code]\n  -o [output name]\n\n";}
elsif ($#ARGV ne "9"){die "!! ERROR !!\n\nUSAGE: perl Ferret_v1.pl \n  -chr [chromosome]\n  -ini [chromosome start position hg19/GRCh37]\n  -end [chromosome stop position hg19/GRCh37]\n  -pop [population code]\n  -o [output name]\n\n";}


### 1. GET ARGUMENTS DATA ###
$chr="";
$start="";
$stop="";
$pop="";
$out="";


for($i=0; $i<9; $i++)
{
	if($i%2 == 0)	# $ARGV[$i] is a description argument
	{
		if($ARGV[$i] eq "-chr")	# $ARGV[$i] describes the chromosome
		{
			if(($ARGV[$i+1] eq "1") or ($ARGV[$i+1] eq "2") or ($ARGV[$i+1] eq "3") or ($ARGV[$i+1] eq "4") or ($ARGV[$i+1] eq "5") or ($ARGV[$i+1] eq "6") or ($ARGV[$i+1] eq "7") or ($ARGV[$i+1] eq "8") or ($ARGV[$i+1] eq "9") or ($ARGV[$i+1] eq "10") or ($ARGV[$i+1] eq "11") or ($ARGV[$i+1] eq "12") or ($ARGV[$i+1] eq "13") or ($ARGV[$i+1] eq "14") or ($ARGV[$i+1] eq "15") or ($ARGV[$i+1] eq "16") or ($ARGV[$i+1] eq "17") or ($ARGV[$i+1] eq "18") or ($ARGV[$i+1] eq "19") or ($ARGV[$i+1] eq "20") or ($ARGV[$i+1] eq "21") or ($ARGV[$i+1] eq "22"))
			{
				$chr=$ARGV[$i+1];
			}
			else
			{	
				die "!! ERROR !!\n\nUSAGE: perl Ferret_v1.pl \n  -chr [chromosome]\n  -ini [chromosome start position hg19/GRCh37]\n  -end [chromosome stop position hg19/GRCh37]\n  -pop [population code]\n  -o [output name]\n\nChromosome should be equal to a number between 1-22 (not 01, 02, etc.)\n";
			}
		}
		
		if($ARGV[$i] eq "-ini")	# $ARGV[$i] describes the chromosome start position
		{
			$start=$ARGV[$i+1];
		}
		
		if($ARGV[$i] eq "-end")	# $ARGV[$i] describes the chromosome stop position
		{
			$stop=$ARGV[$i+1];
		}
		
		if($ARGV[$i] eq "-pop")	# $ARGV[$i] describes the 1KG population of interest
		{
			if(($ARGV[$i+1] eq "ACB") or ($ARGV[$i+1] eq "ASW") or ($ARGV[$i+1] eq "ESN") or ($ARGV[$i+1] eq "GWD") or ($ARGV[$i+1] eq "LWK") or ($ARGV[$i+1] eq "MSL") or ($ARGV[$i+1] eq "YRI") or ($ARGV[$i+1] eq "AFR") or ($ARGV[$i+1] eq "CLM") or ($ARGV[$i+1] eq "MXL") or ($ARGV[$i+1] eq "PEL") or ($ARGV[$i+1] eq "PUR") or ($ARGV[$i+1] eq "AMR") or ($ARGV[$i+1] eq "CDX") or ($ARGV[$i+1] eq "CHB") or ($ARGV[$i+1] eq "CHS") or ($ARGV[$i+1] eq "JPT") or ($ARGV[$i+1] eq "KHV") or ($ARGV[$i+1] eq "EAS") or ($ARGV[$i+1] eq "CEU") or ($ARGV[$i+1] eq "GBR") or ($ARGV[$i+1] eq "FIN") or ($ARGV[$i+1] eq "IBS") or ($ARGV[$i+1] eq "TSI") or ($ARGV[$i+1] eq "EUR") or ($ARGV[$i+1] eq "BEB") or ($ARGV[$i+1] eq "GIH") or ($ARGV[$i+1] eq "ITU") or ($ARGV[$i+1] eq "PJL") or ($ARGV[$i+1] eq "STU") or ($ARGV[$i+1] eq "SAS") or ($ARGV[$i+1] eq "ALL"))
			{
				$pop=$ARGV[$i+1];
				$p=$i+1;
			}
			else
			{	
				die "!! ERROR !!\n\nUSAGE: perl Ferret_v1.pl \n  -chr [chromosome]\n  -ini [chromosome start position hg19/GRCh37]\n  -end [chromosome stop position hg19/GRCh37]\n  -pop [population code]\n  -o [output name]\n\nPopulation code is case sensitive and should describe one of the 1KG population.\n  -> For more information, see the 1KG_populations_description.txt file.\n";
			}
		}
		if($ARGV[$i] eq "-o")	# $ARGV[$i] describes the output name
		{
			$out=$ARGV[$i+1];
			$o=$i+1;
		}
	}
}

print "Input parameters:\n  Chromosome = $chr\n  Chromosome start position = $start\n  Chromosome stop position = $stop\n  1KG reference population = $pop\n  Output name = $out\n\n";


### 2. GET A SUBSET FILE CONTAINING THE DATA OF THE REGION OF INTEREST ###
open(Fsubset,">./$ARGV[$o]_genotypes.vcf") || die "!! ERROR !!\n\nCannot create the data subset file:$!";

open(SUBSET, "tabix -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz $chr:$start-$stop|") || die "!! ERROR !!\n\nCannot extract data for this region:$!";
while($line=<SUBSET>)
{
	print Fsubset "$line";
}

close SUBSET;
close Fsubset;


### 3. REMOVE THE MULTI-ALLELIC SITES ###
system("vcftools --vcf $ARGV[$o]_genotypes.vcf --min-alleles 2 --max-alleles 2 --recode --out $ARGV[$o]_genotypes_no_multi");

system("rm $ARGV[$o]_genotypes.vcf");
system("mv $ARGV[$o]_genotypes_no_multi.recode.vcf $ARGV[$o]_genotypes.vcf");
system("rm $ARGV[$o]_genotypes_no_multi.log");


### 4. UPDATE THE ID OF THE VARIANTS TO INCLUDE INFORMATION OF POSITION AND INDELS ###
open(VCF, "$ARGV[$o]_genotypes.vcf") || die "!! ERROR !!\n\nCannot open the vcf subset file:$!";
open(Fvcf, ">./$ARGV[$o]_genotypes_ok.vcf") || die "!! ERROR !!\n\nCannot update the vcf file for indels:$!";
while($ligne=<VCF>)
{
	@list=split(' ', $ligne);
	if($list[6] eq "PASS")
	{
		if($list[2] eq "."){$list[2]="$list[0]_$list[1]";}    # variant with no ID
		$a1=length($list[3]);
		$a2=length($list[4]);
		if(($a1!=1) or ($a2!=1))
		{
			print Fvcf "$list[0]\t$list[1]\tindel_$list[2]_$list[3]/$list[4]\tA\tT";    # indel trick for HaploView
			for($l=5; $l<=$#list; $l++)
			{
				print Fvcf "\t$list[$l]";
			}
			print Fvcf "\n";
		}
		else
		{
			for($l=0; $l<$#list; $l++)
		{
			print Fvcf "$list[$l]\t";
			}
			print Fvcf "$list[$#list]\n";
		}
	}
	else
	{
		print Fvcf "$ligne";
	}
}
close VCF;
close Fvcf;
system("rm $ARGV[$o]_genotypes.vcf");
system("mv $ARGV[$o]_genotypes_ok.vcf $ARGV[$o]_genotypes.vcf");


### 5. EXTRACT INDIVIDUALS FROM POPULATION(S) OF INTEREST ###
if($pop ne "ALL")
{
	open(Find, ">>./$ARGV[$p]_subset.txt") || die "!! ERROR !!\n\nCannot create the population subset file:$!";
	open(IND, "grep -w $pop integrated_call_samples_v3.20130502.ALL.panel | awk '{print $1}'|") || die "!! ERROR !!\n\nCannot extract individuals of interest for $pop:$!";
	while($line=<IND>)
	{
		print Find "$line";
	}
	close IND;
	close Find;
}


### 6. CREATE PLINK ped/map FILES ###
if($pop ne "ALL")
{
	system("vcftools --vcf $ARGV[$o]_genotypes.vcf --keep $ARGV[$p]_subset.txt --plink-tped --out $ARGV[$o]_$ARGV[$p]");
}
elsif($pop eq "ALL")
{
	system("vcftools --vcf $ARGV[$o]_genotypes.vcf --plink-tped --out $ARGV[$o]_$ARGV[$p]");
}
system("plink --noweb --tped $ARGV[$o]_$ARGV[$p].tped --tfam $ARGV[$o]_$ARGV[$p].tfam --recode --out $ARGV[$o]_$ARGV[$p]");


# Parse the PLINK ped file by replacing the -9 phenotype status by 0, which is recognized by HaploView #
open(Fped, ">./$ARGV[$o]_$ARGV[$p].ped2") || die "!! ERROR !!\n\nCannot create the ped file:$!";
open(PED, "sed -e s/\-9/0/g $ARGV[$o]_$ARGV[$p].ped|") || die "!! ERROR !!\n\nCannot update the ped file:$!";
while($line=<PED>)
{
	print Fped "$line";
}
close PED;
close Fped;
system("rm $ARGV[$o]_$ARGV[$p].ped");
system("mv $ARGV[$o]_$ARGV[$p].ped2 $ARGV[$o]_$ARGV[$p].ped");

# Parse the PLINK ped file by including Family ID, Maternal ID, Paternal ID and Gender #
open(Fped2,">./$ARGV[$o]_$ARGV[$p].ped2") || die "!! ERROR !!\n\nCannot create the updated ped file:$!";
open(PEDpheno,"$ARGV[$o]_$ARGV[$p].ped") || die "!! ERROR !!\n\nCannot open the ped file with clean phenotype:$!";
while($line1=<PEDpheno>)                                
{
	@list1=split('\s',$line1);
	if ($line1 !~ /^$/)
	{
		open(PEDref,"integrated_call_samples.20130502.ALL.ped") || die "!! ERROR !!\n\nCannot open the reference ped file:$!";
		while($line2=<PEDref>)                                                                   
		{
			@list2=split('\t',$line2);
		    if ($list1[1] eq $list2[1])
	    	{
	    		print Fped2 "$list2[0]\t$list1[1]\t$list2[2]\t$list2[3]\t$list2[4]";
				for($c=5; $c<=$#list1; $c++)
				{
					print Fped2 "\t$list1[$c]";
				}
				print Fped2 "\n";
				close PEDref;
		    }
		}
	}
}
close PEDpheno;
close Fped2;
system("rm $ARGV[$o]_$ARGV[$p].ped");
system("mv $ARGV[$o]_$ARGV[$p].ped2 $ARGV[$o]_$ARGV[$p].ped");

### 7. COMPUTE ALLELE FREQUENCIES ###
if($pop ne "ALL")
{
	system("vcftools --vcf $ARGV[$o]_genotypes.vcf --keep $ARGV[$p]_subset.txt --freq2 --out $ARGV[$o]_$ARGV[$p]_AlleleFreq");
}
elsif($pop eq "ALL")
{
	system("vcftools --vcf $ARGV[$o]_genotypes.vcf --freq --out $ARGV[$o]_$ARGV[$p]_AlleleFreq");
}


### 8. CREATE THE HAPLOVIEW INFO FILE ###
open(Finfo, ">>./$ARGV[$o]_$ARGV[$p].info") || die "!! ERROR !!\n\nCannot create the HaploView file:$!";
open(INFO, "cut -f2,4 $ARGV[$o]_$ARGV[$p].map|") || die "!! ERROR!!\n\n\nCannot create the HaploView file:$!";
while($line=<INFO>)
{
	print Finfo "$line";
}
close INFO;
close Finfo;


### 9. REMOVE TEMPORARY FILES ###
system("rm ALL.chr$chr.phase3*.vcf.gz.tbi");
system("rm $ARGV[$o]_genotypes.vcf*");
if($pop ne "ALL"){system("rm $ARGV[$p]_subset.txt");}
system("rm $ARGV[$o]_$ARGV[$p]*.log");
system("rm $ARGV[$o]_$ARGV[$p]*.nosex");
system("rm $ARGV[$o]_$ARGV[$p].t*");