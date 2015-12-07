~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                ######   ######   ####    ####    ######   #######                     
                #        #        #   #   #   #   #           #
                ###      ###      # #     # #     ###         #
                #        #        # #     # #     #           #
                #        #####    #   #   #   #   #####       #

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       Contact Dr Sophie Limou, sophie.limou@nih.gov ~ December 4th, 2015
       URL: http://limousophie35.github.io/Ferret
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                           ?? HOW TO RUN THIS PROGRAM ??
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 Ferret_v1.pl description
 ------------------------
 . This Ferret perl script quickly extract human genetic variation data from the
 1000 Genomes (1KG) project. It runs with command line options from the Terminal
 console and queries the 1KG Phase 3 data located in the ftp 20130502 folder that
 was last updated on May 27th, 2015.
 . Compared to our user-friendly Java application, the perl script only queries
 1KG data from locus coordinates (no gene or variant input). However, it runs
 faster and empowers the user to query larger loci (REF?).
 
 To install the program and necessary dependencies, please see the
 Install_infos.txt file.


==================================================================================


=> To launch the script, type the following command line in a Terminal console:
----------------------------------------------------------------------------------
> perl Ferret_v1.pl 
  -chr [chromosome]
  -ini [chromosome start position hg19/GRCh37]
  -end [chromosome stop position hg19/GRCh37]
  -pop [population code]
  -o [output name]
----------------------------------------------------------------------------------
where [chromosome] = number between 1-22 (not 01, 02, etc.).

      [chromosome start position hg19/GRCh37] = chromosome start position on the
                                                Human genome hg19/GRCh37.
                                                !! If you don't know the positions
                                                on hg19/GRCh37, you can use one of
                                                the genome coordinates conversion
                                                tools (@).

      [chromosome stop position hg19/GRCh37] = chromosome stop position on the
                                               Human genome hg19/GRCh37.
                                               !! If you don't know the positions
                                               on hg19/GRCh37, you can use one of
                                               the genome coordinates conversion
                                               tools (@).

      [population code] = one of the 1KG population code (case sensitive). For
                          more information, see the 1KG_populations_description.txt
                          file.

      [output name] = name to characterize your output (without space !).

----------------------------------------------------------------------------------

Example of a command line:
> perl Ferret_v1.pl -chr 2 -ini 16871212 -end 16876211 -pop CEU -o test

----------------------------------------------------------------------------------

!! IMPORTANT !! The order for the different options is not important. The two
commands below will therefore give identical results:
> perl Ferret_v1.pl -chr 2 -ini 16871212 -end 16876211 -pop CEU -o test
> perl Ferret_v1.pl -pop CEU -o test -ini 16871212 -end 16876211 -chr 2

----------------------------------------------------------------------------------

(@)- UCSC LiftOver (http://genome.ucsc.edu/cgi-bin/hgLiftOver)
   - NCBI remapping service (http://www.ncbi.nlm.nih.gov/genome/tools/remap#tab=
     asm&src_org=Homo%20sapiens&min_ratio=0.5&max_ratio=2.0&allow_locations=true&
     merge_fragments=true&in_fmt=Best%20Guess&out_fmt=Same%20as%20input)
   - ENSEMBL converter (http://www.ensembl.org/Homo_sapiens/Tools/AssemblyConverter
     ?db=core)


==================================================================================


=> Four output files are generated:
 (1) output_pop_AlleleFreq.frq
 File containing the allelic frequency of each variant from the selected region in 
 the 1KG reference panel. Can be read with a text editor or Excel. 

 (2) output_pop.ped
 Plink/HaploView ped file containing the individual information and genotype data.

 (3) output_pop.map
 Plink map file containing the variant information.

 (4) output_pop.info
 HaploView info file containing the variant information.

(2)/(3) ped/map files can be loaded with the Plink package.
http://pngu.mgh.harvard.edu/~purcell/plink/

(2)/(4) ped/info files can be open with HaploView (Linkage format input option).
http://www.broadinstitute.org/scientific-community/science/programs/medical-and-
population-genetics/haploview/haploview


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
