
BIN_NAME					:= baseSW

SW_SOURCE_DIRS_LIST			:= ./srcBase

CMP_SOURCE_DIRS_LIST		:= 
CMP_LIB_DIR					:= 	

SW_EXCLUDE_DIRS_LIST		:=
SW_EXCLUDE_FILES_LIST		:=
   
FLASHABLE_FILES_NAMES_LIST :=
BIN2FLASHABLE_LOADER_PATH			:=       
BIN2FLASHABLE_SCRIPT_PATH			:=                 
BIN2FLASHABLE_OPTIONS_LIST		:=      

cc_mcal_mandatory_opt_lst 	=  
cc_c_opt_lst				= 
cc_Preprocessor_opt_lst		=
cc_directory_opt_lst		= 
cc_optimization_opt_lst		=
cc_trgt_dpndnt_opt_lst		= 
cc_warning_opt_lst			= 
cc_debugging_opt_lst		= 
cc_output_opt_lst			= 
cc_misc_opt_lst				= 
cc_macros_lst				=         

CC_OPTIONS_LIST				= $(cc_mcal_mandatory_opt_lst) $(cc_c_opt_lst) $(cc_Preprocessor_opt_lst) $(cc_directory_opt_lst) \
							  $(cc_optimization_opt_lst) $(cc_trgt_dpndnt_opt_lst) $(cc_warning_opt_lst) \
							  $(cc_debugging_opt_lst) $(cc_output_opt_lst) $(cc_misc_opt_lst)  $(cc_macros_lst)      

ld_mandatory_opt_lst = 		    
ld_mcal_mandatory_opt_lst	= 

ld_input_opt_lst			=  
								
ld_generic_opt_lst			= 
ld_debugging_opt_lst		= 
ld_output_opt_lst			= 

LD_OPTIONS_LIST				= $(ld_mandatory_opt_lst)$(ld_mcal_mandatory_opt_lst) $(ld_input_opt_lst) $(ld_generic_opt_lst) $(ld_debugging_opt_lst) \
                              $(ld_output_opt_lst)  
#end of file