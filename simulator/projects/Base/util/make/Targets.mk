# DISABLE BUILT-IN RULES
.SUFFIXES :	


#==============================================================================#
# 										TARGETS					               #
#==============================================================================#

 
CMPLIBS:= $(addsuffix .a,$(notdir $(CMP_SOURCE_DIRS_LIST)))
CMPLIBSPATH:= $(addprefix $(CMP_LIB_DIR)/,$(CMPLIBS)) 


$(info )
$(info ==================================================)
$(info =====       START OF TARGETS EVALUATION      =====)
$(info ==================================================)
$(info )

 
# build target is the first target so that if make was called without target it will execute
 
ifeq ($(FLASHABLE_FILES_NAMES_LIST),)
.PHONY: build
 build : $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION)
else
 .PHONY: build
 build : $(FLASHABLE_FILES_NAMES_LIST)
endif


$(FLASHABLE_FILES_NAMES_LIST) : $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION)
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----      CREATING OEM FLASHABLE FILE       -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo Creating $(FLASHABLE_FILES_NAMES_LIST) file/s.....
	$(DBG)$(BIN2F) "$(BIN2FLASHABLE_SCRIPT_PATH)" $(BIN2FLASHABLE_OPTIONS_LIST) 
	@$(CMD)echo "Done."
	@$(CMD)echo --------------------------------------------------

$(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION) : $(BIN_DIR)/$(BIN_NAME).elf
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----          CREATING BINARY FILE          -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo Creating binary file $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION).....
	$(DBG)$(ELF2BIN) $(BIN_OPTIONS_LIST) $(BIN_DIR)/$(BIN_NAME).elf $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION)
	@$(CMD)echo "Done."
	@$(CMD)echo --------------------------------------------------
	

$(SWOBJFILES_C) $(SWOBJFILES_ASM) $(BIN_DIR)/$(BIN_NAME).elf : $(UserBuildConfigFile) 
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $($(cmp)OBJFILES_C) $($(cmp)OBJFILES_ASM) : $(UserBuildConfigFile)))      


#ELF is the "master" output	
# -T<linker-file>: passes linker script, the default linker script will be ignored. 
# -Wl,--start-group <list> -Wl,--end-group: resolve cyclic references so that the order of libraries becomes irrelevant. 
# $(DEP_DIR)/LinkedFiles.mk: list of files that has been linked last time 
$(BIN_DIR)/$(BIN_NAME).elf : $(LD_FILE) $(SWOBJFILES_ASM) $(SWOBJFILES_C)  $(SWLIBFILES) $(DEP_DIR)/LinkedFiles.mk
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----                LINKING                 -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo Generating elf file $(BIN_DIR)/$(BIN_NAME).elf.....
	@$(CMD)echo "LinkedFiles:=$(CurrentLinkedFiles) FileReadMarker" > $(DEP_DIR)/LinkedFiles.mk
	$(DBG)$(LD) -T $(LD_FILE) $(LD_OPTIONS_LIST) -Wl,-Map=$(BIN_DIR)/$(BIN_NAME).map \
                -o $(BIN_DIR)/$(BIN_NAME).elf $(SWOBJFILES_ASM) $(SWOBJFILES_C) -Wl,--start-group $(SWLIBFILES) $(CMPLIBSPATH) -Wl,--end-group    
	@$(CMD)echo Generation done.
	
	
#$(BIN_DIR)/$(BIN_NAME).elf : ./src/9_CmpLibs/1_BM.a
$(foreach cmp,$(CMP_SOURCE_DIRS_LIST),$(eval $(BIN_DIR)/$(BIN_NAME).elf : $(CMP_LIB_DIR)/$(notdir $(cmp)).a))      





define AddRule_CMP
$(CMP_LIB_DIR)/$(1).a : $($(1)OBJFILES_C) $($(1)OBJFILES_ASM)
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----           CREATING COMPONENT           -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "Creating $(CMP_LIB_DIR)/$(1).a"
	$(DBG)$(AR_PATH) r $(CMP_LIB_DIR)/$(1).a $($(1)OBJFILES_C) $($(1)OBJFILES_ASM)
	@$(CMD)echo Creation done.
	
endef

$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call AddRule_CMP,$(cmp)))) 









.PHONY: clean
clean:
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----          DELETING OLD BUILDS           -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo Deleting files.....
	$(DBG)$(CMD)rm -r -f $(OBJ_DIR)/*  $(BIN_DIR)/*  $(DEP_DIR)/* $(FLASHABLE_DIR)/* $(CMPLIBSPATH)   
	@$(CMD)echo "Done deleting files."
	@$(CMD)echo --------------------------------------------------


#target definition for assembling
# -c: The input fle is compiled to a object fle. The toolchain is stopped after the assembler. 
# -MMD: Generates make dependencies but ignores system header files
# -MP: Generate phony targets for all headers included in the input file so that if a header is removed, will not break
define AddRule_ASM
$(OBJ_DIR)/$(1).obj : $(2) $(if $(filter %.S,$1),$(DEP_DIR)/$(1).d, ) 
	@$(CMD)echo --------------------------------------------------
	$$(eval C = $$(words $$N))
	$$(eval N := x $$N)
	@$(CMD)echo Assembling file[$$(C)/$(TCOUNT)]: $(2)
	$(DBG)$(ASM) -c -MP -MMD -MF $(DEP_DIR)/$(1).d $(ASM_OPTIONS_LIST) $(3) $(2) -o $(OBJ_DIR)/$(1).obj
	@$(CMD)echo File assembling done.
	
endef

define Cmp_Loop_Asm
$$(foreach asm, $$($1ASMFILES), $$(eval $$(call AddRule_ASM ,$$(notdir $$(asm)),$$(asm),$$($1HDIRS))))
	
endef

$(foreach asm, $(SWASMFILES), $(eval $(call AddRule_ASM ,$(notdir $(asm)),$(asm),$(SWHDIRS))))
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_Asm,$(cmp))))   

#target definition for compiling
# -c: The input fle is compiled to a object fle. The toolchain is stopped after the assembler. 
# -MMD: Generates make dependencies but ignores system header files
# -MP: Generate phony targets for all headers included in the input file so that if a header is removed, will not break
define AddRule_C
$(OBJ_DIR)/$(1).o : $(2) $(DEP_DIR)/$(1).d 
	@$(CMD)echo --------------------------------------------------
	$$(eval C = $$(words $$N))
	$$(eval N := x $$N)
	@$(CMD)echo Compiling file[$$(C)/$(TCOUNT)]: $(2) 
	$(DBG)$(CC) -c -MP -MMD -MF $(DEP_DIR)/$(1).d $(CC_OPTIONS_LIST) $(3) $(2) -o $(OBJ_DIR)/$(1).o
	@$(CMD)echo File compilation done.

endef

define Cmp_Loop_C
$$(foreach src, $$($1CFILES), $$(eval $$(call AddRule_C,$$(patsubst %.c,%,$$(notdir $$(src))),$$(src),$$($1HDIRS))))

endef

$(foreach src, $(SWCFILES), $(eval $(call AddRule_C,$(patsubst %.c,%,$(notdir $(src))),$(src),$(SWHDIRS))))
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_C,$(cmp))))   


#if make is killed or interrupted during the execution , the .PRECIOUS target is not deleted. 
#Also, if the target is an intermediate file, it will not be deleted after it is no longer 
#needed, as is normally done. Then Create a pattern rule with an empty recipe, so that 
#make will not fail if the dependency file does not exist.
.PRECIOUS = $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;


#TODO: check if one file in the middile does not exist will it include the rest?	
-include $(SWDEPFILES) $(SWDEPFILES_ASM)

define Cmp_Loop_dep
-include $($1DEPFILES) $($1DEPFILES_ASM)

endef
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_dep,$(cmp)))) 
