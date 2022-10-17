#///////////////////////////////////////////////////////////////////////////
#// Texas A&M University
#// CSCE 616 Hardware Design Verification
#// Created by  : Prof. Quinn and Saumil Gogri
#///////////////////////////////////////////////////////////////////////////

import re


csv = open("seq_db.csv", "w")
columnTitleRow = "Sequence, dest port, vc, length, delay\n"
csv.write(columnTitleRow)


file = "./xrun.log"
with open (file,"r") as fin:
	for line in fin:
		match = re.match(r'(  delay|  dest_port|  vc|  length|  parent sequence \(name\)).*', line, re.M|re.I)
		if match:
			line=line.strip()
			li=line.split()
			if (li[0]=="delay"):
				delay=li[3]
			if (li[0]=="dest_port"):
				dest_port=li[3]
			if (li[0]=="vc"):
				vc=li[3]
			if (li[0]=="length"):
				length=li[3]
			if (li[0]=="parent"):
				sequence=li[5]
				row=sequence + ", " + dest_port + ", " + vc + ", " + length + ", " + delay + "\n"
				csv.write(row)
csv.close
