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
		"legend_matrix", "l", 1, "character",
		"output_file", "o", 2, "character"
);

opt=getopt(spec=matrix(params, ncol=4, byrow=TRUE), debug=FALSE);

script_name=unlist(strsplit(commandArgs(FALSE)[4],"=")[1])[2];

usage <- paste (
		"\nUsage:\n", script_name, "\n",
		"	-l <legend matrix>\n",
		"	[-o <output file name>]\n",
		"\n",
		"This script will read in a legend matrix and outputs a pdf with color legend.\n",
		"\n");

## Parameters Parsing and Variable Assignment
if(!length(opt$legend_matrix)){
	cat(usage);
	quit(status=0);	
}

LegendMatrix=opt$legend_matrix;

OutputFileName=gsub("\\.r_distmat", "", LegendMatrix);
if(length(opt$output_file)){
	OutputFileName=opt$output_file;
}

## MAIN

# Load data
legend_matrix=as.matrix(read.table(LegendMatrix, header=FALSE, check.names=FALSE, comment.char=''));

legend_pdf=paste(OutputFileName, ".legend.pdf", sep="")
pdf(legend_pdf, height=8.5, width=11);
plot.new();
legend("center",legend=legend_matrix[,1],col=legend_matrix[,2],pch=15);
dev.off()
cat("Done.\n");