#TODO: target validation(check case...)
#TODO: check for abs/relative path behavior
#TODO: check and remove special characters  $(subst char1,,$(subst $char2,,$(BIN_NAME)) 
#  : ; # ( ) $ ^ \ { } ! @ —  % / [ ] " ' ,

BIN_NAME						:= $(strip $(BIN_NAME))

#remove tralling slash and replace back slash with slash and remove extra white spaces and duplications 
SW_SOURCE_DIRS_LIST				:= $(patsubst %/,%,$(sort $(subst \,/,$(strip $(SW_SOURCE_DIRS_LIST)))))


CMP_SOURCE_DIRS_LIST			:= $(patsubst %/,%,$(sort $(subst \,/,$(strip $(CMP_SOURCE_DIRS_LIST)))))
CMP_LIB_DIR 					:= $(patsubst %/,%,$(sort $(subst \,/,$(strip $(CMP_LIB_DIR)))))


SW_EXCLUDE_DIRS_LIST			:= $(patsubst %/,%,$(sort $(subst \,/,$(strip $(SW_EXCLUDE_DIRS_LIST)))))
SW_EXCLUDE_FILES_LIST			:= $(sort $(subst \,/,$(strip $(SW_EXCLUDE_FILES_LIST))))        

LD_FILE							:= $(subst \,/,$(strip $(LD_FILE)))



LIB_EXTENSION					:= $(strip $(LIB_EXTENSION))
BIN_EXTENSION					:= $(strip $(BIN_EXTENSION))


DEP_DIR							:= $(patsubst %/,%,$(subst \,/,$(strip $(DEP_DIR))))
OBJ_DIR							:= $(patsubst %/,%,$(subst \,/,$(strip $(OBJ_DIR))))
BIN_DIR							:= $(patsubst %/,%,$(subst \,/,$(strip $(BIN_DIR))))
FLASHABLE_DIR					:= $(patsubst %/,%,$(subst \,/,$(strip $(FLASHABLE_DIR))))


CC								:= $(subst \,/,$(strip $(CC_PATH)))
LD								:= $(subst \,/,$(strip $(LD_PATH)))



FLASHABLE_FILES_NAMES_LIST		:= $(sort $(strip $(FLASHABLE_FILES_NAMES_LIST)))
BIN2F							:= $(subst \,/,$(strip $(BIN2FLASHABLE_LOADER_PATH)))

#here we use \ not / 
BIN2FLASHABLE_SCRIPT_PATH		:= $(subst /,\,$(strip $(BIN2FLASHABLE_SCRIPT_PATH)))
BIN2FLASHABLE_OPTIONS_LIST		:= $(strip $(BIN2FLASHABLE_OPTIONS_LIST))


 
   
   
define DIR_EXIST	
  $(if  $(filter "$(wildcard $(1)/.)",""),$(error - Error in variable $(2): Directory $(1) doesn't exist or not a directory or contains white spaces))
endef

#(mandatory-not list-file)
define FILE_EXIST	
  $(if  $(filter "$(wildcard $(1))",""),$(error - Error in variable $(2): File $(1) doesn't exist or not a file or contains white spaces))
  $(if  $(filter-out "$(wildcard $(1)/.)",""),$(error - Error in variable $(2): $(1) is not a file))
endef  

#(mandatory-not list)
define NOT_LIST_CHECK	
  ifneq (1,$(words [$(1)]))
    $$(error - Error: Variable $(2) contains spaces or more than one value)
  endif
endef

#(mandatory-not list)
define NOT_EMPTY_CHECK	
  ifeq ($(1),)
    $$(error - Error: Variable $(2) can't be empety)
  endif
endef

#(optional-not list-directory) 
define OPTIONAL_DIR_CHECK	
  ifneq ($(1),)
   ifneq (1,$(words [$(1)]))
      $$(error - Error: Variable $(2) contains spaces or more than one value)
   endif

ignor := $$(call DIR_EXIST,$(1),$(2))
  endif   
endef



#BIN_NAME: Checking variable BIN_NAME(mandatory-not list)
$(eval $(call NOT_EMPTY_CHECK,$(BIN_NAME),BIN_NAME)) 
$(eval $(call NOT_LIST_CHECK,$(BIN_NAME),BIN_NAME)) 


#SW_SOURCE_DIRS_LIST: Checking variable SW_SOURCE_DIRS_LIST(mandatory- list-dir)
$(eval $(call NOT_EMPTY_CHECK,$(SW_SOURCE_DIRS_LIST),SW_SOURCE_DIRS_LIST)) 
ignor := $(foreach dir,$(SW_SOURCE_DIRS_LIST),$(call DIR_EXIST,$(dir),SW_SOURCE_DIRS_LIST))
#make sure no dir in SW_SOURCE_DIRS_LIST are repeated or parent/child of another
#work around is    AllFiles 		:= $(sort $(AllFiles)) but still performence issue
SW_SOURCE_DIRS_LIST := $(sort $(filter-out $(addsuffix /%,$(SW_SOURCE_DIRS_LIST)),$(SW_SOURCE_DIRS_LIST)))



#CMP_SOURCE_DIRS_LIST: Checking variable CMP_SOURCE_DIRS_LIST(optional- list-dir)
ignor := $(foreach dir,$(CMP_SOURCE_DIRS_LIST),$(call DIR_EXIST,$(dir),CMP_SOURCE_DIRS_LIST))
#make sure no dir in CMP_SOURCE_DIRS_LIST are parent/child of another
ignor := $(filter-out $(addsuffix /%,$(CMP_SOURCE_DIRS_LIST)),$(CMP_SOURCE_DIRS_LIST))
ifneq ($(ignor),$(CMP_SOURCE_DIRS_LIST))
  $(error The following directory/directories are children of another directory/directories in the same variable "CMP_SOURCE_DIRS_LIST": $(filter-out $(ignor),$(CMP_SOURCE_DIRS_LIST)) )
endif
#make sure no dir in CMP_SOURCE_DIRS_LIST are parent of one in SW_SOURCE_DIRS_LIST
ignor := $(filter $(addsuffix /%,$(CMP_SOURCE_DIRS_LIST)),$(SW_SOURCE_DIRS_LIST))
ifneq ($(ignor),)
  $(error Some directory/directories in "SW_SOURCE_DIRS_LIST" are children of directory/directories in "CMP_SOURCE_DIRS_LIST")
endif



#SW_EXCLUDE_DIRS_LIST, SW_EXCLUDE_FILES_LIST: no need to check
ignor := $(foreach dir,$(SW_EXCLUDE_DIRS_LIST),$(call DIR_EXIST,$(dir),SW_EXCLUDE_DIRS_LIST))
ignor := $(foreach f,$(SW_EXCLUDE_FILES_LIST),$(call FILE_EXIST,$(f),SW_EXCLUDE_FILES_LIST))


#Checking variable LD_FILE(mandatory-not list-file)- FILE_EXIST is enough
$(eval $(call NOT_EMPTY_CHECK,$(LD_FILE),LD_FILE))
$(eval $(call NOT_LIST_CHECK,$(LD_FILE),LD_FILE))    
ignor := $(call FILE_EXIST, $(LD_FILE),LD_FILE)


#LIB_EXTENSION: Checking variable LIB_EXTENSION(mandatory-not list)
$(eval $(call NOT_EMPTY_CHECK,$(LIB_EXTENSION),LIB_EXTENSION))
$(eval $(call NOT_LIST_CHECK,$(LIB_EXTENSION),LIB_EXTENSION)) 


#BIN_EXTENSION: Checking variable BIN_EXTENSION(mandatory-not list)
$(eval $(call NOT_EMPTY_CHECK,$(BIN_EXTENSION),BIN_EXTENSION))
$(eval $(call NOT_LIST_CHECK,$(BIN_EXTENSION),BIN_EXTENSION)) 


#Checking output directories(mandatory-not list-directory-don't have to be existing now)
$(eval $(call NOT_EMPTY_CHECK,$(DEP_DIR),DEP_DIR)) 
$(eval $(call NOT_LIST_CHECK,$(DEP_DIR),DEP_DIR)) 

$(eval $(call NOT_EMPTY_CHECK,$(OBJ_DIR),OBJ_DIR))  
$(eval $(call NOT_LIST_CHECK,$(OBJ_DIR),OBJ_DIR)) 

$(eval $(call NOT_EMPTY_CHECK,$(BIN_DIR),BIN_DIR))
$(eval $(call NOT_LIST_CHECK,$(BIN_DIR),BIN_DIR)) 

$(eval $(call NOT_EMPTY_CHECK,$(FLASHABLE_DIR),FLASHABLE_DIR))
$(eval $(call NOT_LIST_CHECK,$(FLASHABLE_DIR),FLASHABLE_DIR))

$(eval $(call NOT_LIST_CHECK,$(CMP_LIB_DIR),CMP_LIB_DIR))
ignor := $(call DIR_EXIST,$(CMP_LIB_DIR),CMP_LIB_DIR)

#TOOLCHAIN_BIN_DIR:
$(eval $(call NOT_LIST_CHECK,$(TOOLCHAIN_BIN_DIR),BIN_NAME)) 
ignor := $(call DIR_EXIST,$(TOOLCHAIN_BIN_DIR),TOOLCHAIN_BIN_DIR)
 

#Checking toolchain(mandatory-not list-file)
ignor := $(call FILE_EXIST, $(CC),CC_PATH)
ignor := $(call FILE_EXIST, $(LD),LD_PATH)

      

	
                           

#FLASHABLE_FILES_NAMES_LIST: no checks


BIN2F: check(file- optional)
ifneq ($(BIN2F),)
   ignor := $(call FILE_EXIST, $(BIN2F),BIN2FLASHABLE_LOADER_PATH)
endif 


#BIN2FLASHABLE_SCRIPT_PATH: check(file- optional)
ifneq ($(BIN2FLASHABLE_SCRIPT_PATH),)
   ignor := $(call FILE_EXIST, $(BIN2FLASHABLE_SCRIPT_PATH),BIN2FLASHABLE_SCRIPT_PATH)
   #if script exist, a loader must be present unless it's a batch file
   ifneq ($(patsubst %.bat,.bat,$(BIN2FLASHABLE_SCRIPT_PATH)),.bat)
       ignor := $(call FILE_EXIST, $(BIN2F),BIN2FLASHABLE_LOADER_PATH)
   endif 
endif 


#BIN2FLASHABLE_OPTIONS_LIST: no checks


#ASM, CC, and LD options will be checked by compiler driver


$(info - Checking working directories......)
#Check first to save shell call
ignor := $(strip $(filter "$(wildcard $(OBJ_DIR)/.)","") \
                 $(filter "$(wildcard $(DEP_DIR)/.)","") \
                 $(filter "$(wildcard $(BIN_DIR)/.)","") \
                 $(filter "$(wildcard $(FLASHABLE_DIR)/.)","")) 
                
ifneq ("$(ignor)"," ")
    $(info - Creating working directories......)
    $(shell   $(CMD)mkdir -p $(OBJ_DIR) $(DEP_DIR) $(BIN_DIR) $(FLASHABLE_DIR))
endif



