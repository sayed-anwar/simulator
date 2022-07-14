#==========================================================================================#
# EXTENSIONS                    		                                   
#==========================================================================================#
#						   
#==========================================================================================#
LIB_EXTENSION				:= dll
BIN_EXTENSION				:= dll

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

#===========================================================================================#
#                     		                TOOLCHAIN                   					#
#===========================================================================================#
# TOOLCHAIN_BIN_DIR: The directory where compiler executable "tricore-gcc.exe" is located.	#
# ASM              			:  Path to assembler exe							   			#
# CC               			:  Path to compiler exe								   			#
# LD               			:  Path to linker exe								   			#
# ELF2BIN	      			:  Path to elf to binary converter					   			#
#===========================================================================================#
TOOLCHAIN_BIN_DIR     		:= C:\msys64\ucrt64\bin\

TOOLCHAIN_BIN_DIR			:= $(subst \,/,$(strip $(TOOLCHAIN_BIN_DIR)))

CC_PATH    					:= $(TOOLCHAIN_BIN_DIR)/g++.exe
LD_PATH    					:= $(TOOLCHAIN_BIN_DIR)/g++.exe

