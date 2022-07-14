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
 
.PHONY: build
 build : $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION)



$(SWOBJFILES_C) $(SWOBJFILES_CPP) $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION)  : $(UserBuildConfigFile) 
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $($(cmp)OBJFILES_C) $($(cmp)OBJFILES_CPP) : $(UserBuildConfigFile)))      


#ELF is the "master" output	
# -T<linker-file>: passes linker script, the default linker script will be ignored. 
# -Wl,--start-group <list> -Wl,--end-group: resolve cyclic references so that the order of libraries becomes irrelevant. 
# $(DEP_DIR)/LinkedFiles.mk: list of files that has been linked last time 
$(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION) : $(SWOBJFILES_CPP) $(SWOBJFILES_C)  $(SWLIBFILES) $(DEP_DIR)/LinkedFiles.mk $(LIB_INCLUDE_FILE)
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo "-----                LINKING                 -----"
	@$(CMD)echo "--------------------------------------------------"
	@$(CMD)echo Generating $(BIN_EXTENSION) file $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION).....
	@$(CMD)echo "LinkedFiles:=$(CurrentLinkedFiles) FileReadMarker" > $(DEP_DIR)/LinkedFiles.mk
	$(DBG)$(LD) -shared -o $(BIN_DIR)/$(BIN_NAME).$(BIN_EXTENSION) $(SWOBJFILES_CPP) $(SWOBJFILES_C) -Wl,--out-implib,$(BIN_NAME).a   
	$(DBG)$(CMD)mv $(BIN_NAME).a $(BIN_DIR)
	$(DBG)$(CMD)cp $(LIB_INCLUDE_FILE) $(BIN_DIR)
	@$(CMD)echo Generation done.
	
	
#$(BIN_DIR)/$(BIN_NAME).elf : ./src/9_CmpLibs/1_BM.a
$(foreach cmp,$(CMP_SOURCE_DIRS_LIST),$(eval $(BIN_DIR)/$(BIN_NAME).exe : $(CMP_LIB_DIR)/$(notdir $(cmp)).a))      





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
	$(DBG)$(CMD)rm -r -f $(OBJ_DIR)/*  $(BIN_DIR)/*  $(DEP_DIR)/*  $(CMPLIBSPATH)   
	@$(CMD)echo "Done deleting files."
	@$(CMD)echo --------------------------------------------------


#target definition for compiling
# -c: The input fle is compiled to a object fle. The toolchain is stopped after the assembler. 
# -MMD: Generates make dependencies but ignores system header files
# -MP: Generate phony targets for all headers included in the input file so that if a header is removed, will not break
define AddRule_CPP
$(OBJ_DIR)/$(1).o : $(2) $(DEP_DIR)/$(1).d 
	@$(CMD)echo --------------------------------------------------
	$$(eval C = $$(words $$N))
	$$(eval N := x $$N)
	@$(CMD)echo Compiling file[$$(C)/$(TCOUNT)]: $(2) 
	$(DBG)$(CC) -c -MP -MMD -MF $(DEP_DIR)/$(1).d $(CC_OPTIONS_LIST) $(3) $(2) -o $(OBJ_DIR)/$(1).o
	@$(CMD)echo File compilation done.

endef

define Cmp_Loop_CPP
$$(foreach src, $$($1CPPFILES), $$(eval $$(call AddRule_CPP,$$(patsubst %.cpp,%,$$(notdir $$(src))),$$(src),$$($1HDIRS))))

endef

$(foreach src, $(SWCPPFILES), $(eval $(call AddRule_CPP,$(patsubst %.cpp,%,$(notdir $(src))),$(src),$(SWHDIRS))))








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
