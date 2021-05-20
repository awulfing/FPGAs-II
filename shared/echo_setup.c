#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <string.h>

#define LEFT_ENABLE_OFFSET 0x0
#define LEFT_DELAY_OFFSET 0x4
// todo: Set left gain offset
#define LEFT_GAIN_OFFSET 0x8
#define RIGHT_ENABLE_OFFSET 0x10
#define RIGHT_DELAY_OFFSET 0x14
// todo: Set right gain offset
#define RIGHT_GAIN_OFFSET 0x18

int main () {
	FILE *file;
	size_t ret;	
	uint32_t val;

	file = fopen ("/dev/echo" , "rb+" );
	if (file == NULL) {
		printf("failed to open file\n");
		exit(1);
	}

	// Test reading the regsiters sequentially
	printf("\n***************\n* read initial register values\n***************\n\n");

	ret = fread(&val, 4, 1, file);
	printf("left_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("left_delay = 0x%x\n", val);
	
    // todo: print left gain
	ret = fread(&val,4,1,file);
	printf("left_gain = 0x%x\n",val);    	

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_delay = 0x%x\n", val);

    // todo: print right gain
	ret = fread(&val,4,1,file);
	printf("right_gain = 0x%x\n",val);   

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);


	// Reset file position to 0
	ret = fseek(file, 0, SEEK_SET);
	printf("fseek ret = %d\n", ret);
	printf("errno =%s\n", strerror(errno));

	// Write to all registers using fseek
	printf("\n***************\n* write all registers with desired setup values \n***************\n\n");

    // Example
	val = 0xada1;
   	ret = fseek(file, LEFT_GAIN_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Left_gain = 0x%x\n", val);
   // todo: printf() with message writing val to register left gain
	
	val = 0xada1;
   	ret = fseek(file, RIGHT_GAIN_OFFSET, SEEK_SET);
	ret = fwrite(&val, 4, 1, file);
	printf("Right_gain = 0x%x\n", val);

    
	// todo:  Write desired values to all registers
	
    
	

	printf("\n***************\n* register values after writing\n***************\n\n");
	
	ret = fseek(file, 0, SEEK_SET);
	// todo:  Read all the register back again and display the values and names of the associated control registers
	
	ret = fread(&val, 4, 1, file);
	printf("left_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("left_delay = 0x%x\n", val);
	
    // todo: print left gain
	ret = fread(&val,4,1,file);
	printf("left_gain = 0x%x\n",val);    	

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_enable = 0x%x\n", val);

	ret = fread(&val, 4, 1, file);
	printf("right_delay = 0x%x\n", val);

    // todo: print right gain
	ret = fread(&val,4,1,file);
	printf("right_gain = 0x%x\n",val);   

	ret = fread(&val, 4, 1, file);
	printf("empty register = 0x%x\n", val);


    

	fclose(file);
	return 0;
}