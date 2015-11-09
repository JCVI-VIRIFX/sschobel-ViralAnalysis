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

## Subs

test_matrix <- function(M) {
	clades = unique(M[,2]);
	rc = length(clades);
	cc = length(clades);

	pvalues <- c(OutputFileName);	
	
	for (i in 1:rc) {
		if (i != rc) {
			for (k in (i+1):rc) {
				sub1 <- subset(metadata_matrix, V2==clades[i], select = c("V1"));
				sub2 <- subset(metadata_matrix, V2==clades[k], select = c("V1"));
				x <- c(sub1[,1])
				y <- c(sub2[,1])
				cat(paste(c(i,"versus", k,"\n",x,"\n",y,"\n")));
				wt <- wilcox.test(x, y, alternative = c("greater"))
				cat(c("p value: ",wt$p.value,"\n"));
				
				cat(paste(c(k,"versus", i,"\n",x,"\n",y,"\n")));
				tw <- wilcox.test(y, x, alternative = c("greater"))
				cat(c("p value: ",tw$p.value,"\n"));

				cat(paste(c(i,"versus", k,"\n",x,"\n",y,"\n")));
				eq <- wilcox.test(x, y)
				cat(c("p value: ",eq$p.value,"\n"));
				
				pvalues <- c(pvalues, wt$p.value, tw$p.value, eq$p.value)
			}
		}
	}
	wilcox_filename = paste(OutputFileName,".wilcox_results.tsv",sep="");
	wilcox_fh=file(wilcox_filename, "w");
	cat(file=wilcox_fh, pvalues, "\n");
}

test_chi <- function(M) {
	categories = unique(M[,1]);
	clades = unique(M[,2]);
	rc = length(clades);
	cc = length(clades);
	
	pvalues <- c(OutputFileName);
	
	for (i in 1:rc) {
		if (i != rc) {
			for (k in (i+1):rc) {
				sub1 <- subset(metadata_matrix, V2==clades[i], select = c("V1"));
				sub2 <- subset(metadata_matrix, V2==clades[k], select = c("V1"));
				x <- table(sub1[,1]);
				y <- table(sub2[,1]);
				x1 <- x[names(x)==categories[1]];
				x2 <- x[names(x)==categories[2]];
				y1 <- y[names(y)==categories[1]];
				y2 <- y[names(y)==categories[2]];
				
				if (length(x1)<1) {
					x1<-0
				}
				if (length(x2)<1) {
					x2<-0
				}
				if (length(y1)<1) {
					y1<-0
				}
				if (length(y2)<1) {
					y2<-0
				}
						
				chitable <- matrix(c(x1,x2,y1,y2),nrow=2, ncol=2, byrow=TRUE,dimnames=list(c("row1","row2"),c(categories)));
				cat(paste(c(i,"versus", k,"\n",x,"\n",y,"\n")));
				print(chitable);
				wt <- chisq.test(chitable,correct=FALSE)
				cat(c("p value: ",wt$p.value,"\n"));
				
				pvalues <- c(pvalues, wt$p.value)
			}
		}
	}
	chi_filename = paste(OutputFileName,".chisq_results.tsv",sep="");
	chi_fh=file(chi_filename, "w");
	cat(file=chi_fh, pvalues, "\n");
}

## MAIN

# Load data
metadata_matrix=read.table(MetadataMatrix, header=TRUE, row.names=1, col.names=c("V1", "V2"));
	
#metadata_matrix;

categories = unique(metadata_matrix[,1]);
clades = unique(metadata_matrix[,2]);

if (length(categories) > 2) {
#	cat(paste(c(categories,"\n")));
#	cat(paste(c(clades,"\n")));
	cat("I guess it is wicoxon.\n");
	test_matrix(metadata_matrix);
} else if (length(categories) == 2) {
#	cat(paste(c(categories,"\n")));
#	cat(paste(c(clades,"\n")));
	cat("Time for chi squared.\n");
	test_chi(metadata_matrix);
} else {
	cat("No distinguishing characteristics detected.\n");
}



