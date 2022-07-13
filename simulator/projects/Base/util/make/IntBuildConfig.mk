#==========================================================================================#
# EXTENSIONS                    		                                   
#==========================================================================================#
#						   
#==========================================================================================#


ASM_EXTENSION_LIST	 		:= s S
LIB_EXTENSION				:= a
BIN_EXTENSION				:= hex

#==================================================================================#
# GENERATED FILES DIR                   	                                       #
#==================================================================================#
# DEP_DIR              		:  Dirctory for dependency files to be generated	   #
# OBJ_DIR              	 	:  Dirctory for object files to be generated		   #
# BIN_DIR            	   	:  Dirctory for elf, map and hex files to be generated #
#==================================================================================#
out_dir  					:= ./build
DEP_DIR						:= $(out_dir)/dep
OBJ_DIR						:= $(out_dir)/obj
BIN_DIR						:= $(out_dir)/bin
FLASHABLE_DIR				:= $(out_dir)/flashable


#===========================================================================================#
#                     		                TOOLCHAIN                   					#
#===========================================================================================#
# TOOLCHAIN_BIN_DIR: The directory where compiler executable "tricore-gcc.exe" is located.	#
# ASM              			:  Path to assembler exe							   			#
# CC               			:  Path to compiler exe								   			#
# LD               			:  Path to linker exe								   			#
# ELF2BIN	      			:  Path to elf to binary converter					   			#
#===========================================================================================#
TOOLCHAIN_BIN_DIR     		:= C:\BLSLTools\compilers\hightec\v4.6.3.1\bin\

TOOLCHAIN_BIN_DIR			:= $(subst \,/,$(strip $(TOOLCHAIN_BIN_DIR)))

ASM_PATH           			:= $(TOOLCHAIN_BIN_DIR)/tricore-gcc.exe
CC_PATH    					:= $(TOOLCHAIN_BIN_DIR)/tricore-gcc.exe
AR_PATH    					:= $(TOOLCHAIN_BIN_DIR)/tricore-ar.exe
LD_PATH    					:= $(TOOLCHAIN_BIN_DIR)/tricore-gcc.exe
ELF2BIN_PATH				:= $(TOOLCHAIN_BIN_DIR)/tricore-objcopy.exe


