#TODO: fails if a folder called y and file called y [space] xxxxx
#TODO: assembly include dirs are .s or .S  not in .h
#-x language: Specify explicitly the language for the following input files (rather than letting the compiler choose a default based on the file name suffix). This option applies to all following input files until the next -x option.
#TODO: do assembly files have dependicy files?

   #rwildcard				= $(shell  find ./src -type f \( -iname \*.$(ASM_EXTENSION) -o -iname \*.c -o -iname \*.$(LIB_EXTENSION) \))
   rwildcard				= $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

   
   define NEW_LINE 
   
    
   endef
   
   define check_duplication 
     seen :=
     dup  :=
     $(foreach _,$1,$(if $(filter $(notdir $_), $(seen)),$(eval dup += $(notdir $_)),$(eval seen += $(notdir $_))))
     dup := $(sort $(dup))
     ifneq ($(dup),)
      dummy := $$(NEW_LINE) $$(foreach _,$$(dup),$$(filter %/$$_,$(1))$$(NEW_LINE))
      $$($2  $2: The follwoing files are duplicated: $$(dummy))
     endif
   endef
   
   
   define print_list
     ifeq ($(DBG),)
	  ifneq ($(2),)
       $$(info *debug* - $(1) $$(NEW_LINE) $(2) $$(NEW_LINE))
	  endif
     endif
   endef

       
   
    
      
   
   # ASMFILES   OBJFILES_ASM  DEPFILES_ASM  
   # CFILES     OBJFILES_C    DEPFILES     HDIRS HFILES
    
   define get_lists

       #CmpFiles 	:=  $$(call rwildcard,$$(strip $2),$$(addprefix *.,$$(ASM_EXTENSION_LIST)) *.h *.c *.$$(LIB_EXTENSION))  
       #CmpFiles 	:= $$(filter $2/%,$$(AllFiles))           
       
       $1ASMFILES 	:= $$(filter $$(addprefix %.,$(ASM_EXTENSION_LIST)),$2)
       $1CFILES		:= $$(filter %.c,$2)
       $1HFILES		:= $$(filter %.h,$2)
       $1LIBFILES	:= $$(filter %.$(LIB_EXTENSION),$2)
                  
      
      
       $$(eval $$(call print_list,$1 Component- List of assembly files:, $$($1ASMFILES)))
            
       $1OBJFILES_ASM  := $$(addprefix $(OBJ_DIR)/, $$(addsuffix .obj,$$(notdir $$($1ASMFILES))))
       $$(eval $$(call print_list,$1 Component- List of assembly object files:, $$($1OBJFILES_ASM)))
          
       #dependency for S files only not s                       
       $1DEPFILES_ASM	:= $$(addprefix $(DEP_DIR)/, $$(addsuffix .d,$$(notdir $$(filter %.S,$$($1ASMFILES)))))
       $$(eval $$(call print_list,$1 Component- List of assembly dependecy files:, $$($1DEPFILES_ASM)))         
   
     
      
       $$(eval $$(call print_list,$1 Component- List of c files:, $$($1CFILES)))
                 
       $1OBJFILES_C 		:= $$(patsubst %.c,$(OBJ_DIR)/%.o,$$(notdir $$($1CFILES)))  
       $$(eval $$(call print_list,$1 Component- List of object files:, $$($1OBJFILES_C)))
          
      
      
       $1DEPFILES 		:= $$(patsubst %.c,$(DEP_DIR)/%.d,$$(notdir $$($1CFILES)))  
       $$(eval $$(call print_list,$1 Component- List of dependecy files:, $$($1DEPFILES)))
       
       
       
       $$(eval $$(call print_list,$1 Component- List of header files:, $$($1HFILES)))
      
      
      
       $1HDIRS			:= $$(sort $$(patsubst %,-I%,$$(dir $$($1HFILES)))) $$(SWHDIRS)
       $$(eval $$(call print_list,$1 Component- List of include directories:, $$($1HDIRS)))
       
       
       
       $$(eval $$(call print_list,$1 Component- List of library files:, $$($1LIBFILES)))
     
   endef



   #find all assembly, c, h and library files in SW,and all components 
   #cannot leave any space in the iput to rwildcard
   AllFiles 		:= $(call rwildcard,$(strip $(SW_SOURCE_DIRS_LIST)),$(addprefix *.,$(ASM_EXTENSION_LIST)) *.h *.c *.$(LIB_EXTENSION))  
   AllFiles 		:= $(sort $(AllFiles))
  
   #excluding directories
   ignor := $(foreach d,$(SW_EXCLUDE_DIRS_LIST),$(eval AllFiles:=$(filter-out $(d)/%,$(AllFiles))))
  
   #excluding files
   ignor 	:= $(filter %.h,$(SW_EXCLUDE_FILES_LIST))
   ifneq ("$(ignor)","")        
     $(warning Warning: The following header file/s: $(ignor) will be excluded only if the directory containing them contains no other header files. If not, then the file/s will not be excluded.)
   endif
   
   ignor := $(foreach f,$(SW_EXCLUDE_FILES_LIST),$(eval AllFiles:=$(filter-out $(f),$(AllFiles))))
 
   #check duplication
   $(eval $(call check_duplication, $(AllFiles),error))
     
   tmpASMFILES 	:= $(filter $(addprefix %.,$(ASM_EXTENSION_LIST)),$(AllFiles))    
   #in case of assembly s and S extention, duplication will not be detected as make is case sensetive.
   #we have to remove extintion first
   ignore:= $(addsuffix .s,$(basename $(tmpASMFILES)))
   $(eval $(call check_duplication, $(ignore),error))     
         



   
   SWAllFiles := $(filter-out $(addsuffix /%,$(CMP_SOURCE_DIRS_LIST) $(CMP_LIB_DIR)),$(AllFiles))
   SWAllFiles := $(SWAllFiles) $(filter $(CMP_LIB_DIR)/%.$(LIB_EXTENSION) $(CMP_LIB_DIR)/%.h,$(AllFiles))
   
   $(eval $(call get_lists,SW,$(SWAllFiles)))



   $(foreach cmp,$(CMP_SOURCE_DIRS_LIST),$(eval $(call get_lists,$(notdir $(cmp)),$(filter $(cmp)/%,$(AllFiles)))))




   ifneq ($(FLASHABLE_FILES_NAMES_LIST),)
      ifeq ($(patsubst %.bat,.bat,$(BIN2FLASHABLE_SCRIPT_PATH)),.bat)
          BIN2F := c:/windows/system32/cmd.exe /C 
      endif 
   endif 
   
   
   




