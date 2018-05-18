//
// Forked by Yoti from https://github.com/devnoname120/vitanpupdatelinks
//

#include "sha256.h"

#include <stdio.h>
#include <string.h>

int main(int argc, char*argv[])
{
	unsigned char key[32] =
	{
		0xE5, 0xE2, 0x78, 0xAA, 0x1E, 0xE3, 0x40, 0x82, 0xA0, 0x88, 0x27, 0x9C, 0x83, 0xF9, 0xBB, 0xC8,
		0x06, 0x82, 0x1C, 0x52, 0xF2, 0xAB, 0x5D, 0x2B, 0x4A, 0xBD, 0x99, 0x54, 0x50, 0x35, 0x51, 0x14,
	};

	int i;
	char name[255];
	char title[0x10];
	char uniqdata[0x20];
	unsigned char result[0x20];

	memset(name, 0, 255);
	memset(title, 0, 0x10);
	memset(result, 0, 0x20);
	memset(uniqdata, 0, 0x20);

	if (argc == 2)
	{
		sprintf(title, "%s", argv[1]);
		sprintf(uniqdata, "np_%s", title);
		hmac_sha256(key, 0x20, uniqdata, strlen(uniqdata), result);

		sprintf(name, "%s.XFL", argv[1]);
		FILE*f = fopen(name, "w");
			fprintf(f, "https://gs-sec.ww.np.dl.playstation.net/pl/np/%s/", title);
			for(i=0; i<0x20; i++)
				fprintf(f, "%02x", result[i]);
			fprintf(f, "/%s-ver.xml", title);
		fclose(f);
	}
	return 0;
}
