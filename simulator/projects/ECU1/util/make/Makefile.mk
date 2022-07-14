#===========================================================================================#
# ##### ##### ##### ##### #####       GLOBAL MAKE FILE       ##### ##### ##### ##### ##### 	#
#===========================================================================================#
# File name: Makefile_HighTec.mk														   	#
# Purpose: This file is the mian file from which all others will be included			   	#
# Version: 02.00.00																		   	#
# Dependences: Works only with hightec compiler											   	#
# Author: sAnwar																		   	#
# Edited by:																				#
# Copyrights: VAleo																		   	#
#===========================================================================================#

#===========================================================================================#
# Debug aid
#===========================================================================================#
# Used for printing the output of list construction and the building commands
# To use it, edit the target name and add "debug=all" in eclipse. 
# For example : build debug=all or clean debug=all
DBG		:=@
ifeq ("$(debug)","all")
    DBG	:=
endif


#===========================================================================================#
# Tools check: Check the correct invocation of make.exe from "make_02_00_00" and 			#
#              correct version																#
#===========================================================================================#
$(info --------------------------------------------------)

thisMakeVersion := "V02_00_00"
$(info - Tools check. Current version: $(thisMakeVersion).)

ifneq ("$(MAKE_VERSION)","4.2.1")
   $(error This make file is tested under make version "4.2.1". Current version of make.exe is: $(thisMakeVersion). Please make \
     sure to call make.exe correctly from "c:\cygwin_v2\bin" folder. )
endif
#remove traling slash and replace back slash with slash and remove extra white spaces
TOOLSDIR	:= $(patsubst %/,%,$(subst \,/,$(strip $(BLSLMAKETOOLS))))

#CMD used to supply the path to the executables explicitly instead of changing "PATH" variable
CMD			:= $(TOOLSDIR)/

#Include MakeTools_version file which contain avariable called "BLSL_BLSL_GlobalMakeFile_ver"
-include $(TOOLSDIR)/MakeTools_version

ifneq ($(BLSL_BLSL_GlobalMakeFile_ver),$(thisMakeVersion))  
$(error Error: Wrong tools version or wrong make.exe is running, Pleas make sure to use \
tools $(thisMakeVersion) and to correctly set "BLSLMAKETOOLS" path in enveroment variables of the \
eclipse workspace. Current bath of "BLSLMAKETOOLS" is: $(BLSLMAKETOOLS))
endif


#===========================================================================================
# Configuration: Include user configuration file
#===========================================================================================
$(info - Including user configuration file.....)

#included in the batch file
#UserBuildConfigFile:= ./src/0_Common/BuildConfig.mk

$(if  $(filter "$(wildcard $(UserBuildConfigFile))",""), \
$(error - Error: The user build configuration file "$(UserBuildConfigFile)" doesn't exist or \
current build directory is different from the project main directory.))

-include $(UserBuildConfigFile)


#===========================================================================================
# Configuration: Include internal configuration file
#===========================================================================================
$(info - Including internal configuration file.....)

IntBuildConfigFile:= ./util/make/IntBuildConfig.mk

$(if  $(filter "$(wildcard $(IntBuildConfigFile))",""), \
$(error - Error: The internal build configuration file "$(IntBuildConfigFile)" doesn't exist or \
current build directory is different from the project main directory.))

-include $(IntBuildConfigFile)

$(info - Done.)
$(info )


#===========================================================================================
# Configuration: Include inputs validation file
#===========================================================================================

$(info --------------------------------------------------)
$(info - Start of input configurations validation.)
$(info - Including inputs validation file.....)
     
InputsValidationFile:= ./util/make/InputsValidation.mk

$(if  $(filter "$(wildcard $(InputsValidationFile))",""), \
$(error - Error: The internal build configuration file "$(InputsValidationFile)" doesn't exist or \
current build directory is different from the project main directory.))
 
$(info - Validating configuration.....)
   
-include $(InputsValidationFile)
   
$(info - Done.)
$(info )
 
# List construction is needed for build only and not for clean
ifneq ($(MAKECMDGOALS),clean)
   #===========================================================================================
   # CONSTRUCTING LISTS
   #===========================================================================================
   $(info --------------------------------------------------)
   $(info - Start of lists construction.)
   
   ListsConstructionFile:= ./util/make/ListsConstructor.mk

   $(if  $(filter "$(wildcard $(ListsConstructionFile))",""), \
   $(error - Error: The internal build configuration file "$(ListsConstructionFile)" doesn't exist or \
   current build directory is different from the project main directory.))
   
   $(info - Constructing files lists.....)
   
   -include $(ListsConstructionFile)
   
   $(info - Done.)
   $(info )


   #===========================================================================================
   # 
   #===========================================================================================
   
   $(info --------------------------------------------------)
   $(info - Handling assembly, source or library files that are deleted/renamed.)
   #Handling deleted/renamed assembly, source or library files
   CurrentLinkedFiles = $(sort $(ASMFILES) $(CFILES) $(LIBFILES))
   -include $(DEP_DIR)/LinkedFiles.mk
   
#TODO: if SW_SOURCE_DIRS_LIS changed, how will that affect the build, old files are still in the environment?
#   #check deleted files
#   dummyDel:=$(LinkedFiles)
#   ignor := $(foreach f,$(CurrentLinkedFiles),$(eval dummyDel:=$(filter-out $(f),$(dummyDel))))
# 
#   #check added files
#   dummyadd:=$(CurrentLinkedFiles)
#   ignor := $(foreach f,$(LinkedFiles),$(eval dummyadd:=$(filter-out $(f),$(dummyadd))))

   ignor := $(foreach f,$(CurrentLinkedFiles),$(eval LinkedFiles:=$(filter-out $(f),$(LinkedFiles))))

   ifneq ("$(strip $(LinkedFiles))" , "FileReadMarker")
      
      LinkedFiles:= $(filter-out FileReadMarker,$(LinkedFiles))
      
      tmpc:= $(notdir $(filter %.c,$(LinkedFiles)))
      tmpass:= $(notdir $(filter $(addprefix %.,$(ASM_EXTENSION_LIST)),$(LinkedFiles)))
      
      tmpcobj:= $(patsubst %.c,$(OBJ_DIR)/%.o,$(tmpc))
      tmpcdeb:= $(patsubst %.c,$(DEP_DIR)/%.d,$(tmpc))
      
      tmpassobj:=  $(addprefix $(OBJ_DIR)/, $(addsuffix .obj,$(notdir $(tmpass))))                  
      tmpassdeb:= $(addprefix $(DEP_DIR)/, $(addsuffix .d,$(notdir $(tmpass))))
      
      ignor :=  $(shell $(CMD)rm.exe -r -f $(tmpcobj) $(tmpcdeb) $(tmpassobj) $(tmpassdeb) )
      
      $(file > $(DEP_DIR)/LinkedFiles.mk,LinkedFiles:=$(CurrentLinkedFiles) FileReadMarker)
      
   endif
   $(info - Done.)
   $(info )



   #===========================================================================================
   # TARGETS COUNTER                                                               
   #===========================================================================================  
   $(info --------------------------------------------------)
   $(info - Start of targets counter.)
   $(info - Including targets counter file.....)
   TaegetsCounter:= ./util/make/TragetsCounter.mk

   $(if  $(filter "$(wildcard $(TaegetsCounter))",""), \
   $(error - Error: The internal build configuration file "$(TaegetsCounter)" doesn't exist or \
   current build directory is different from the project main directory.))
 
   $(info - Counting number of files to assemble/compile.....)
			 			
   #  -n = dry run, just print the recipes
   #  -r = no builtin rules, disables implicit rules
   #  -R = no builtin variables, disables implicit variables
   #  -f = specify the name of the Makefile			
   #  2>/dev/null = suppress errors(so that errors not showed twice)
   
   
   define AddRule_CMPddd
      $(1)OBJFILES_C="$($(1)OBJFILES_C)" $(1)OBJFILES_ASM="$($(1)OBJFILES_ASM)" $(1)ASMFILES="$($(1)ASMFILES)"  $(1)CFILES="$($(1)CFILES)" $(1)HFILES="$($(1)HFILES)"
   endef

   CmpFilesForCount= $(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)), $(call AddRule_CMPddd,$(cmp)))     
   
   
   TCOUNT :=  $(shell $(CMD)make.exe  --file=$(TaegetsCounter) $(MAKECMDGOALS)\
                --no-print-directory -nrR   \
                SWDEPFILES="$(SWDEPFILES)" OBJ_DIR="$(OBJ_DIR)"  DEP_DIR="$(DEP_DIR)"  \
                ASM_EXTENSION_LIST="$(ASM_EXTENSION_LIST)" SWASMFILES="$(SWASMFILES)" SWOBJFILES_C="$(SWOBJFILES_C)" \
                SWCFILES="$(SWCFILES)" SWHDIRS="$(SWHDIRS)" BIN_DIR="$(BIN_DIR)" SWOBJFILES_ASM="$(SWOBJFILES_ASM)" \
                BIN_NAME="$(BIN_NAME)" UserBuildConfigFile="$(UserBuildConfigFile)" BIN_EXTENSION="$(BIN_EXTENSION)" \
                CMP_SOURCE_DIRS_LIST="$(CMP_SOURCE_DIRS_LIST)" CMP_LIB_DIR="$(CMP_LIB_DIR)" $(CmpFilesForCount) 2>/dev/null \
                | $ $(CMD)tr " " "\n" | $(CMD)grep  -c  "COUNTME") 
   TCOUNT :=$(strip $(TCOUNT))
  
   
   
   
   #TODO:  TCOUNT := $(shell echo "$(TCOUNT)" | $ $(TOOLSDIR)/tr.exe " " "\n" | $(TOOLSDIR)/grep.exe  -c  "COUNTME")
   #echo for piping, tr to replace every space with a new line , grep to count lines with occurance of "COUNTME"
   #TCOUNT := $(shell echo "$(TCOUNT)" | $ $(CMD)tr " " "\n" | $(CMD)grep  -c  "COUNTME")
   #TCOUNT := $(words $(foreach var,$(TCOUNT),COUNTME))
  
   #variable N used as a counter
   N := x
   
  
   $(info  - Number of files to assemble-compile: $(TCOUNT) file/s. )

   $(info - Done.)
   $(info )

endif


#===========================================================================================
# TARGETS
#===========================================================================================

$(info --------------------------------------------------)
$(info - Including targets file.....)
     
TargetsFile:= ./util/make/Targets.mk

$(if  $(filter "$(wildcard $(TargetsFile))",""), \
$(error - Error: The internal build configuration file "$(TargetsFile)" doesn't exist or \
current build directory is different from the project main directory.))
 
$(info - Done.)
$(info )
   
-include $(TargetsFile)
