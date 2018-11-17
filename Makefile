DPDK_DIR=./dpdk
DPDK_TARGET=x86_64-native-linuxapp-gcc

test:
	g++ -O2 -Wno-write-strings $(CFLAGS)  -I/usr/local/cuda/include -I$(DPDK_DIR)/$(DPDK_TARGET)/include  main.c -o dpdk_test -lcudart -Wl,--whole-archive -Wl,-ldpdk -Wl,--start-group -Wl,-lrt -Wl,-lm -Wl,-ldl -Wl,-end-group -Wl,--no-whole-archive -libverbs -lnuma -lmnl -lmlx5 -lcudart -pthread -L/usr/local/cuda/lib64 -L$(DPDK_DIR)/$(DPDK_TARGET)/lib

dpdk:
	git clone https://github.com/DPDK/dpdk.git --branch v18.11-rc3 --depth=1 
	make -C $(DPDK_DIR) config T=$(DPDK_TARGET) install DESTDIR=. || exit 1;
	sed -ri 's,(CONFIG_RTE_BUILD_SHARED_LIB=).*,\1n,' $(DPDK_DIR)/$(DPDK_TARGET)/.config
	sed -ri 's,(CONFIG_RTE_LIBRTE_MLX5_PMD=).*,\1y,' $(DPDK_DIR)/$(DPDK_TARGET)/.config
	make -j -C $(DPDK_DIR)/$(DPDK_TARGET) || exit 1;	
