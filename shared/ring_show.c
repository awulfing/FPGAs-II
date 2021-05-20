#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>

#define LEFT_ENABLE_OFFSET 0x0
#define LEFT_ALPHA_OFFSET 0x4
// todo: Set left Volume offset
#define LEFT_VOLUME_OFFSET 0x8
#define RIGHT_ENABLE_OFFSET 0x10
#define RIGHT_ALPHA_OFFSET 0x14
// todo: Set right Volume offset
#define RIGHT_VOLUME_OFFSET 0x18

int main () {
	FILE *file;
	size_t ret;	
	uint32_t val;

	file = fopen ("/dev/ring" , "rb+" );
	if (file == NULL) {
		printf("failed to open file\n");
		exit(1);
	}

	// Test reading the regsiters sequentially
	printf("\n***************\n* read initial register values\n***************\n\n");

	ret = fread(&val, 4, 1, file);
	printf("left_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("left_Alpha = 0x%x\n", val);
	
    // todo: print left Volume
	ret = fread(&val,4,1,file);
	printf("left_Volume = 0x%x\n",val);    	

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_Alpha = 0x%x\n", val);

    // todo: print right Volume
	ret = fread(&val,4,1,file);
	printf("right_Volume = 0x%x\n",val);   

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);


	// Reset file position to 0
	ret = fseek(file, 0, SEEK_SET);
	printf("fseek ret = %d\n", ret);
	printf("errno =%s\n", strerror(errno));

	// Write to all registers using fseek
	printf("\n***************\n* write all registers with desired setup values \n***************\n\n");
	sleep(10);

    // Example
	val = 0x40;
   	ret = fseek(file, LEFT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Left_ALPHA = 0x%x\n", val);
   // todo: printf() with message writing val to register left Volume
	
	val = 0x40;
   	ret = fseek(file, RIGHT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Right_ALPHA = 0x%x\n", val);

	sleep(10);

    // Example
	val = 0x10;
   	ret = fseek(file, LEFT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Left_ALPHA = 0x%x\n", val);
   // todo: printf() with message writing val to register left Volume
	
	val = 0x10;
   	ret = fseek(file, RIGHT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Right_ALPHA = 0x%x\n", val);
    
	
	sleep(10);

    // Example
	val = 0x80;
   	ret = fseek(file, LEFT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Left_ALPHA = 0x%x\n", val);
   // todo: printf() with message writing val to register left Volume
	
	val = 0x80;
   	ret = fseek(file, RIGHT_ALPHA_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Right_ALPHA = 0x%x\n", val);
	// todo:  Write desired values to all registers
	
    
	

	printf("\n***************\n* register values after writing\n***************\n\n");
	
	ret = fseek(file, 0, SEEK_SET);
	// todo:  Read all the register back aVolume and display the values and names of the associated control registers
	
	ret = fread(&val, 4, 1, file);
	printf("left_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("left_Alpha = 0x%x\n", val);
	
    // todo: print left Volume
	ret = fread(&val,4,1,file);
	printf("left_Volume = 0x%x\n",val);    	

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_Alpha = 0x%x\n", val);

    // todo: print right Volume
	ret = fread(&val,4,1,file);
	printf("right_Volume = 0x%x\n",val);   

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);


    

	fclose(file);
	return 0;
}