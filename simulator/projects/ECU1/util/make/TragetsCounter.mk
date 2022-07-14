# DISABLE BUILT-IN RULES
.SUFFIXES:

.PHONY: dummy
dummy:




	
.PHONY: build
build : $(BIN_DIR)/$(BIN_NAME).elf



$(SWOBJFILES_C) $(SWOBJFILES_ASM) $(BIN_DIR)/$(BIN_NAME).elf : $(UserBuildConfigFile)
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $($(cmp)OBJFILES_C) $($(cmp)OBJFILES_ASM) : $(UserBuildConfigFile)))   

$(BIN_DIR)/$(BIN_NAME).elf : $(LD_FILE) $(SWOBJFILES_ASM) $(SWOBJFILES_C)  $(SWLIBFILES) $(DEP_DIR)/LinkedFiles.mk

#$(BIN_DIR)/$(BIN_NAME).elf : ./src/9_CmpLibs/1_BM.a
$(foreach cmp,$(CMP_SOURCE_DIRS_LIST),$(eval $(BIN_DIR)/$(BIN_NAME).elf : $(CMP_LIB_DIR)/$(notdir $(cmp)).a))    



define AddRule_CMP
$(CMP_LIB_DIR)/$(1).a : $($(1)OBJFILES_C) $($(1)OBJFILES_ASM)
	
endef

$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call AddRule_CMP,$(cmp)))) 










#target definition for assembling
define AddRule_ASM
$(OBJ_DIR)/$(1).obj : $(2) $(if $(filter %.S,$1),$(DEP_DIR)/$(1).d, ) 
	  COUNTME 
endef

define Cmp_Loop_Asm
$$(foreach asm, $$($1ASMFILES), $$(eval $$(call AddRule_ASM ,$$(notdir $$(asm)),$$(asm),$$($1HDIRS))))
endef

	
$(foreach asm, $(SWASMFILES), $(eval $(call AddRule_ASM ,$(notdir $(asm)),$(asm),$(SWHDIRS))))

$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_Asm,$(cmp))))   



#target definition for compiling
define AddRule_C
$(OBJ_DIR)/$(1).o : $(2) $(DEP_DIR)/$(1).d 
	  COUNTME   
endef

define Cmp_Loop_C
$$(foreach src, $$($1CFILES), $$(eval $$(call AddRule_C,$$(patsubst %.c,%,$$(notdir $$(src))),$$(src),$$($1HDIRS))))

endef

$(foreach src, $(SWCFILES), $(eval $(call AddRule_C,$(patsubst %.c,%,$(notdir $(src))),$(src),$(SWHDIRS)))) 
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_C,$(cmp))))  




.PRECIOUS = $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(SWDEPFILES) $(SWDEPFILES_ASM)

define Cmp_Loop_dep
-include $($1DEPFILES) $($1DEPFILES_ASM)

endef
$(foreach cmp,$(notdir $(CMP_SOURCE_DIRS_LIST)),$(eval $(call Cmp_Loop_dep,$(cmp))))



