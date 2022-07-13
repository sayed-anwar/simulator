#===========================================================================================#
# ##### ##### ##### ##### #####   USER CONFIGURATION FILE     ##### ##### ##### ##### ##### #
#===========================================================================================#
# File name: BuildConfig_HighTec.mk															#
# Purpose: This file is used for user configurations inputs.								#
# Version: 02.00.00																			#
# Dependences: Works only with hightec compiler v4.6.3.1.									#
# Author: sAnwar.																			#
# Copyrights: Valeo.																		#
#===========================================================================================#


#===========================================================================================#
# NOTES:																					#
# - Project path and tools paths shall have no spaces or special characters e.g. brackets.	#
# - All paths in this file shall have no spaces or special characters e.g. brackets.     	#      							   					
# - Relative paths are relative to the project main directory(e.g. "~/01_Sw_Cmp/02_BL"		#
#   folder) and must start with "./" to work properly										#
# - Every assembly file (.s .S) in the project shall have a unique name.	 	        	#
# - .s files will be assembled directly while .S files will be preprocessed by c            # 
#   preprocessor first.                                                                     #
# - WARNING: Assembly handling still unfinished. 											#
# - Every source code file (.c) in the project shall have a unique name.					#
# - Every header file (.h) in the project shall have a unique name.							#
# - Every library file (.a) in the project shall have a unique name.						#
# - For multiline options, use back slash "/".												#
# - Variables with lowercase letters (e.g. project_name) are used inside this file only  	#
#   and will not be validated.																#
# - Variables with uppercase letters (e.g. BIN_NAME) are used all over the environment and 	#
#   might be validated.																		#
# - Variables ending with "..._DIRS_LIST" can hold only a single directory or a space 		#
#   separated list of directories.															#
# - Variables ending with "..._FILES_LIST" can hold only a single file or a space 			#
#   separated list of files.																# 
# - Variables ending with "..._LIST" can hold only a single value or a space separated 		#
#   list of values.																			#
# - All other variables can hold only one non space separated value. 						#
#===========================================================================================#


#===========================================================================================#
#                       		      PROJECT INFORMATION                         			#
#===========================================================================================#
# BIN_NAME:  Name of the generated elf/hex(without extension). It can has the form 			#
#            "Project_OEM_Type_Version" or any other form. No spaces allowed.      			#		   	   				   
#===========================================================================================#

#BIN_NAME					:= DCDC_GEELY_BootLoader_01_00_00
BIN_NAME					:= DCDC_GEELY_BootLoader_01_00_00


#===========================================================================================#
#                    		               SOURCE FILES                               		#
#===========================================================================================#
# PROJECT_SOURCE_DIR_LIST: A single directory or space separated list of directories to be  #     	
#    	scanned recursively(except the directories excluded by "SW_EXCLUDE_DIRS_LIST") for  #
#       *.s, *.S, *.c, *.h and *.a files(extensions are case sensitive).                    #
#       All *.c or *.s,S files in these directories will be compiled and all *.a            #
#       will be linked (except the files excluded by "SW_EXCLUDE_FILES_LIST"). Move out     #
#       any file not needed.                                                                #
#		In GCC, .S (upper case) is for assembler files that need to be pre-processed (so    #
#       you can use #include, #if, #define, and C-style comments.) and .s (lower case)      #
#       for files that do not.                                                              #
#                                                                                           #
# SW_EXCLUDE_DIRS_LIST: A single directory or space separated list of directories to be     #
#       excluded recursively from compilation/linking.       		                        #
# SW_EXCLUDE_FILES_LIST: A single file or space separated list of files to be 		        #
#       excluded from compilation/linking. WARNING Header files will not be excluded    	#
#       unless all other header files in the same directory are also excluded. 				#
#																							#
# LD_FILE		 			: Path of the linker file.                                      #
#   Example of Creating library for component
#	CMP_SOURCE_DIRS_LIST		:= ./src/8_CmpSrc/NetIf ./src/8_CmpSrc/CRC 
#   CMP_LIB_DIR					:= ./src/9_CmpLibs				
#
#
#
#					
# NAME OF THE COMPONENT FOLDER IS THE NAME OF THE COMPONENT
# SW_EXCLUDE_DIRS_LIST and SW_EXCLUDE_FILES_LIST are applicable on sw and components
# if component dir is a child of sw dir then it will be excluded from sw
# sw dir cannot be child of compnent dir
# com dir cannot be child of another cmp
# compiling component will include HDIRs inside this componnent first then SW then the rest of the componnents
# compiling SW will include SW HDIRS first then other components
# TODO: /dir ------> ./dir or error
#===========================================================================================#
SW_SOURCE_DIRS_LIST			:= ./src/src


CMP_SOURCE_DIRS_LIST		:= 
CMP_LIB_DIR					:= 	

SW_EXCLUDE_DIRS_LIST		:=
SW_EXCLUDE_FILES_LIST		:=

LD_FILE 				  	:= ./src/0_Common/LinkerScript_HighTec_TC233.ld
  


   

#===========================================================================================#
#                     		OEM/PROJECT SPECIFIC FLASHABLE FORMAT                     		#    
#===========================================================================================#
# Purpose: To exeute additional scripts on the hex file after generation. A typical use		#
#          is to pad the hex after generation and adding markers, generating files that 	#
#          are flashable by OEM tool(e.g. .ulp file or .bsw file), separating flash 		#
#          driver.....																		#
#          It can execute batch file, python script, transfor script, hexview script.....	#
#  																							#
# FLASHABLE_FILES_LIST: The output files after executing the script.						#
#																							#
# BIN2FLASHABLE_LOADER_PATH: for batch files--> leave empty.								#
#                            for python     --> path of python.exe.							#
#                            for hexview    --> path of hexview.exe.						#
#																							#
# BIN2FLASHABLE_SCRIPT_PATH: path of the script, "current directory" variable will be the	#
#          project main directory(e.g. "~/01_Sw_Cmp/02_BL". You should change the current	#
#          directory if needed or adjust all relative paths accordingly.					#
#																							#
# BIN2FLASHABLE_OPTIONS_LIST: empty, single parameter or space separated list of parameters.#
#   																						#
# batch file example:																		#
#   FLASHABLE_FILES_NAMES_LIST := ./build/flashable/$(BIN_NAME)_padded.hex /                #
#                                 ./build/flashable/APP_padded_validmarker.ulp              #
#   BIN2FLASHABLE_LOADER_PATH			:= 													#
#   BIN2FLASHABLE_SCRIPT_PATH			:= ./util/scripts/CopyExample.bat                   #
#   BIN2FLASHABLE_OPTIONS_LIST		:= ./build/bin/$(BIN_NAME).hex /                        #
#                                  ./build/flashable/$(BIN_NAME)_padded.hex /               #
#                                  ./build/flashable/APP_padded_validmarker.ulp             #
#																							#
# python script example:																	#
#   FLASHABLE_FILES_NAMES_LIST := ./build/flashable/$(BIN_NAME)_padded.hex /                #
#                                 ./build/flashable/APP_padded_validmarker.ulp              #
#   BIN2FLASHABLE_LOADER_PATH			:= C:/BLSLTools/python/Python34/python34.exe        #
#   BIN2FLASHABLE_SCRIPT_PATH			:= ./util/scripts/CopyExample.py                    #
#   BIN2FLASHABLE_OPTIONS_LIST		:= ./build/bin/$(BIN_NAME).hex /                        #
#                                  ./build/flashable/$(BIN_NAME)_padded.hex /               #
#                                  ./build/flashable/APP_padded_validmarker.ulp             #
#																							#
# 																							#
#===========================================================================================#
																
  FLASHABLE_FILES_NAMES_LIST :=
  BIN2FLASHABLE_LOADER_PATH			:=       
  BIN2FLASHABLE_SCRIPT_PATH			:=                 
  BIN2FLASHABLE_OPTIONS_LIST		:=      
#===========================================================================================#
# 							            COMPILE/BUILD FLAGS                  	   			#
#===========================================================================================#
# - Don't use ":="															       			#
# - full list of gcc flags :                                                       			#
#            https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html                			#
#===========================================================================================#

ASM_OPTIONS_LIST			= -c -fno-common  -g -Wextra -Wall  -Warray-bounds -Wcast-align -mtc161 \
							  -Wignored-qualifiers -Wformat -Wformat-security -mcpu=tc26xx  -W	


# -ansi Disables features not compatible with ansi C  
# -ffreestanding Built in functions handled more efficiently
# -fno-short-enums Enums are integer type
# -fpeel-loops Code optimization for loop peeling
# -falign-functions=4 Starting address of functions are aligned to 4 byte boundary
# -funsigned-bitfields Bit fields to be used in the unsigned int data types.
# -ffunction-sections Functions normally placed in the “.text” are placed in their own sections.
# -fno-ivopts Perform induction variable optimizations (strength reduction, induction variable
# merging and induction variable elimination) on trees.
# -fno-peephole2 Disables RTL peephole optimization after registers have been allocated but before scheduling.
# -O3 Compiler Optimization level 3.
# -mtc161 Compile code for specific CPU variant
# -D_GNU_C_TRICORE_=1 Defines the macro for GNU compiler usage.
# -I "$(PRODDIR)/tricore/include/machine" Path to include libraries where PRODDIR, defines the compiler installation path


#sAnwar: -ansi cause an error every time a comment with "//" is used
cc_mcal_mandatory_opt_lst 	= -ffreestanding -fno-short-enums -falign-functions=4 -ffunction-sections \
                              -fno-ivopts -fno-peephole2 -O3 -mtc161 -D_GNU_C_TRICORE_=1 
 
cc_c_opt_lst				= -ggdb 
cc_Preprocessor_opt_lst		=
cc_directory_opt_lst		= 
cc_optimization_opt_lst		=
cc_trgt_dpndnt_opt_lst		= -mcpu=tc26xx 
cc_warning_opt_lst			= -Wextra   -Warray-bounds -Wcast-align -Wignored-qualifiers -Wformat -Wformat-security -Wno-comment
cc_debugging_opt_lst		= -g3 
cc_output_opt_lst			= -c -fno-common 
cc_misc_opt_lst				= 
cc_macros_lst				=         

CC_OPTIONS_LIST				= $(cc_mcal_mandatory_opt_lst) $(cc_c_opt_lst) $(cc_Preprocessor_opt_lst) $(cc_directory_opt_lst) \
							  $(cc_optimization_opt_lst) $(cc_trgt_dpndnt_opt_lst) $(cc_warning_opt_lst) \
							  $(cc_debugging_opt_lst) $(cc_output_opt_lst) $(cc_misc_opt_lst)  $(cc_macros_lst)      


#-Wl,--mcpu=tc161 Option to check linking of objects with different cores
ld_mandatory_opt_lst = -Wl,--gc-sections -Wl,--extmap=a			    
ld_mcal_mandatory_opt_lst	= -Wl,--mcpu=tc161 

ld_input_opt_lst			= -nostartfiles 
								
ld_generic_opt_lst			= -mcpu=tc26xx  -Wl,--cref 
ld_debugging_opt_lst		= 
ld_output_opt_lst			= 

LD_OPTIONS_LIST				= $(ld_mandatory_opt_lst)$(ld_mcal_mandatory_opt_lst) $(ld_input_opt_lst) $(ld_generic_opt_lst) $(ld_debugging_opt_lst) \
                              $(ld_output_opt_lst)  


#ELF to HEX converter (tricore-objcopy.exe) flags	
# -O ihex     -----> output intel hex format
# -O srec     -----> output S-record format		     
BIN_OPTIONS_LIST			= -O ihex

