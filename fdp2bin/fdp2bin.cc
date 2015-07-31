#include <string.h>
#include <stdio.h>
#include <unistd.h> // for unlink
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>

#include "bigendian_io.h"
#include "kosinski.h"

using namespace std;

bool buildRom(istream &in, ostream &out, unsigned int &compressedLength);
void editShareFile(const char* shareFileName, unsigned int compressedLength);

void printUsage(char const *program) {
	cerr << "Usage: " << program << " inputcodefile.p outputromfile.bin sharefile.h"
	     << endl << endl;
}

int main(int argc, char *argv[]) {
	const char* codeFileName = nullptr;
	const char* romFileName = nullptr;
	const char* shareFileName = nullptr;
	unsigned int compressedLength = 0;

	if (argc < 3) {
		printUsage(argv[0]);
	}

	for (int ii = 1; ii < argc; ii++) {
		char* arg = argv[ii];

		if(!strcasecmp(arg, "-h") || !strcasecmp(arg, "--help")) {
			printUsage(argv[0]);
			return 1;
		} else if(!codeFileName) {
			codeFileName = arg;
		} else if(!romFileName) {
			romFileName = arg;
		} else if(!shareFileName) {
			shareFileName = arg;
		}
	}

	if (codeFileName && romFileName) {
		cout << "\n" << argv[0] << ": generating " << romFileName
		     << " from " << codeFileName << "... ";
		
		ifstream fin(codeFileName, ios::in|ios::binary);
		if (fin.good()) {
			ofstream fout(romFileName, ios::out|ios::binary);
			if (fout.good()) {
				if (buildRom(fin, fout, compressedLength)) {
					editShareFile(shareFileName, compressedLength);
					cout << "done";
				} else {
					// Error; delete the rom because it's probably hosed
					unlink(romFileName);
				}
			}
			else {
				cout << endl;
				cerr << "ERROR: Failed to access file '" << romFileName << "'." << endl;
			}
		} else {
			cout << endl;
			cerr << "ERROR: Failed to load file '" << codeFileName << "'." << endl;
		}
	}
	
	cout << endl;
	return 0;
}

void editShareFile(const char* shareFileName, unsigned int compressedLength)
{
	if (shareFileName && compressedLength > 0) {
		ofstream fshare(shareFileName, ios::out|ios::ate|ios::app);
		if(fshare.good()) {
			fshare << "#define comp_z80_size 0x" << hex << uppercase << compressedLength
			       << endl;
		}
	}
}

bool buildRom(istream &in, ostream &out, unsigned int &compressedLength) {
	if (Read1(in) != 0x89) {
		cout << endl;
		cerr << "Warning: First byte of a .p file should be $89" << endl;
	}
	if (Read1(in) != 0x14) {
		cout << endl;
		cerr << "Warning: Second byte of a .p file should be $14" << endl;
	}

	int cpuType = 0, segmentType = 0, granularity = 0;
	signed long start = 0, lastStart = 0;
	unsigned short length = 0, lastLength = 0;
	static const int scratchSize = 4096;
	char scratch[scratchSize];
	bool lastSegmentCompressed = false;

	while (true) {
		unsigned char headerByte = Read1(in);
		if (!in.good()) {
			break;
		}

		switch(headerByte) {
			case 0x00: // "END" segment
				return true;
			case 0x80: // "entry point" segment
				in.ignore(3);
				continue;
			case 0x81:  // code or data segment
				cpuType = Read1(in);
				segmentType = Read1(in);
				granularity = Read1(in);
				if (granularity != 1) {
					cout << endl;
					cerr << "ERROR: Unsupported granularity " << granularity << endl;
					return false;
				}
				break;
			default:
				if (headerByte > 0x81) {
					cout << endl;
					cerr << "ERROR: Unsupported segment header $" << setw(2)
					     << setfill('0') << hex << uppercase << headerByte
					     << dec << nouppercase << endl;
					return false;
				}
				cpuType = headerByte;
				break;
		}

		// Integers in AS .p files are always little endian
		start  = LittleEndian::Read4(in);
		length = LittleEndian::Read2(in);

		if (length == 0) {
			// Error instead of warning because I had quite a bad freeze the one
			// time I saw this warning go off
			cout << endl;
			cerr << "ERROR: zero length segment ($" << setw(2)
			     << setfill('0') << hex << uppercase << length
			     << dec << nouppercase << ")." << endl;
			return false;
		}

		if (start < 0) {
			cout << endl;
			cerr << "ERROR: negative start address ($" << setw(2)
			     << setfill('0') << hex << uppercase << start
			     << dec << nouppercase << ")." << endl;
			start = 0;
			return false;
		}

		if (cpuType == 0x51 && start != 0 && lastSegmentCompressed) {
			cout << endl;
			cerr << "ERROR: The compressed Z80 code (Flamedriver.asm) must all "
			     << "be in one segment. That means the size must be < 65535 bytes."
			     << " The offending new segment starts at address $" << setw(2)
			     << setfill('0') << hex << uppercase << start
			     << dec << nouppercase << " relative to the start of the Z80 code."
			     << endl;
			start = 0;
			return false;
		}

		// 0x51 is the type for Z80 family (0x01 is for 68000)
		if (cpuType == 0x51 && start == 0) {
			// Kosinski compressed Z80 segment
			start = lastStart + lastLength;
			int srcStart = in.tellg();
			string buf;
			buf.resize(length);
			in.read(&buf[0], length);
			stringstream inbuff(ios::in | ios::out | ios::binary);
			inbuff.str(buf);
			stringstream outbuff(ios::in | ios::out | ios::binary);
			kosinski::encode(inbuff, outbuff);
			outbuff.seekg(0, ios::end);
			compressedLength = outbuff.tellg();
			outbuff.seekg(0);
			out << outbuff.rdbuf();
			in.seekg(srcStart + length, ios::beg);
			lastSegmentCompressed = true;
			continue;
		}

		if (!lastSegmentCompressed) {
			// 3 bytes of leeway for instruction patching
			if (start+3 < out.tellp()) {
				cout << endl;
				cerr << "Warning: overlapping allocation detected! $" << setw(2)
				     << setfill('0') << hex << uppercase << start << " < $" << setw(2)
				     << setfill('0') << hex << uppercase << out.tellp()
				     << dec << nouppercase << ")." << endl;
			}
		} else {
			if(start < out.tellp()) {
				cout << endl;
				cerr << "ERROR: Compressed sound driver might not fit.\n"
				     << "Please increase your value of Size_of_Snd_driver_guess "
				     << "to at least $" << setw(2)
				     << setfill('0') << hex << uppercase << compressedLength
				     << dec << nouppercase << " and try again." << endl;
				return false;
			} else {
				cout << endl << "Compressed driver size: 0x" << setw(2)
				     << setfill('0') << hex << uppercase << compressedLength
				     << dec << nouppercase << endl;
			}
		}

		lastStart = start;
		lastLength = length;
		lastSegmentCompressed = false;

		out.seekp(start, ios::beg);

		while (length) {
			int copy = length;
			if(copy > scratchSize) {
				copy = scratchSize;
			}
			in.read(scratch, copy);
			out.write(scratch, copy);
			length -= copy;
		}
		
	}

	return true;
}

