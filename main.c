#include "rte_ethdev.h"
#include "rte_eal.h"
#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime_api.h>

int main(int argc, char **argv)
{
        char *buf[] = {"dpdk","-l","1","-n","4","proc-type=primary"};
	int count = 0;

#ifdef CUDA_GET_DEVICE	
	cudaGetDeviceCount(&count);
#endif	
	printf("%d GPU devices found\n", count);
        rte_eal_init( sizeof(buf)/sizeof(buf[0]), buf);
        printf("%u NIC devices found\n", rte_eth_dev_count_avail());

	return 0;
}

