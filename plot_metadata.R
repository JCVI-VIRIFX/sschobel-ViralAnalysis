#!/usr/bin/env Rscript

###############################################################################
#                                                                             # 
#       Copyright (c) 2014 J. Craig Venter Institute.                         #     
#       All rights reserved.                                                  #
#                                                                             #
###############################################################################
#                                                                             #
#    This program is free software: you can redistribute it and/or modify     #
#    it under the terms of the GNU General Public License as published by     #
#    the Free Software Foundation, either version 3 of the License, or        #
#    (at your option) any later version.                                      #
#                                                                             #
#    This program is distributed in the hope that it will be useful,          #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#    GNU General Public License for more details.                             #
#                                                                             #
#    You should have received a copy of the GNU General Public License        #
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.    #
#                                                                             #
###############################################################################

###############################################################################

library('getopt');

require(reshape2)
require(ggplot2)

PAPERDIM="8.5x11";

params=c(
		"metadata_matrix", "l", 1, "character",
		"output_file", "o", 2, "character"
);

opt=getopt(spec=matrix(params, ncol=4, byrow=TRUE), debug=FALSE);

script_name=unlist(strsplit(commandArgs(FALSE)[4],"=")[1])[2];

usage <- paste (
		"\nUsage:\n", script_name, "\n",
		"	-l <metadata matrix>\n",
		"	[-o <output file name>]\n",
		"\n",
		"This script will read in a metadata matrix and output a statistical significance.\n",
		"\n");

## Parameters Parsing and Variable Assignment
if(!length(opt$metadata_matrix)){
	cat(usage);
	quit(status=0);	
}

MetadataMatrix=opt$metadata_matrix;

OutputFileName=gsub("\\.r_distmat", "", MetadataMatrix);
if(length(opt$output_file)){
	OutputFileName=opt$output_file;
}

PaperDim=PAPERDIM;
if(length(opt$paper_dimension)){
	PaperDim=opt$paper_dimension;
}

hw=as.numeric(strsplit(PaperDim, "x")[[1]]);
cat("Paper Dimensions: ", hw[1], " by ", hw[2], "\n");

## Subs

## MAIN

# Load data
metadata_matrix=read.table(MetadataMatrix, header=TRUE, row.names=1, col.names=c("V1", "V2"));
#metadata_matrix;

pdf_name = paste(OutputFileName, ".box_violin_plot.pdf", sep="")

pdf(pdf_name, height=hw[1], width=hw[2]);

dup <- subset(metadata_matrix, V2 == 1)
no_dup <- subset(metadata_matrix, V2 == 0)
bucket<-list(duplication=dup$V1, no_duplication=no_dup$V1)
mm <- melt(bucket)
ggplot(mm, aes(as.factor(value), fill = L1)) + geom_histogram(position = "stack", binwidth=1)

cat("Hello\n");

p <- ggplot(data = metadata_matrix, aes(x = as.factor(V2), y = V1, fill=as.factor(V2)))
p + geom_boxplot(outlier.size = 1, show_guide=F, fatten=0.5, lwd=0.4)
p + geom_violin()

dev.off();