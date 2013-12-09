.SUFFIXES : .gb .gun .ogun 
SHELL   :=/bin/bash
VPATH   :=.
SH_RM   :=/bin/rm -f
COMPILER:=perl parser.pl
DST_DIR :=../runtime/players
OBJ_COMMON := \
	generated/init.ogun \
	generated/moveMaxHexPref.ogun \
	generated/hexPrefDef.ogun \
	generated/otherPos.ogun \
	generated/ownedMap.ogun \
	generated/gateDef.ogun \
	generated/checkWarp.ogun \
	generated/debugPrint.ogun \
	generated/posMutual.ogun \
	generated/oppsDistance.ogun \
	generated/spiralMove_searchInner.ogun \
	generated/spiralMove_rotate_impl.ogun \
	generated/spiralMove_rotate_impl2.ogun \
	generated/spiralMove_rotate_impl3.ogun \
	generated/spiralMove_global.ogun \
	generated/checkMateMove.ogun \
	generated/inuUtility.ogun \
	generated/inuMain.ogun \
	generated/inuStorage.ogun \
	generated/inuHexPref.ogun \
	generated/inuNearMove.ogun \
	generated/safeField.ogun \
	generated/checkContinental.ogun  \
	generated/checkContinental_init.ogun  \
	generated/checkContinental_impl2.ogun  \
	generated/comboMove.ogun \
	generated/comboMove_checkNeighborShape.ogun \
	generated/comboMove_neighbor.ogun \
	generated/comboMove_storage.ogun \
	generated/comboMove_init.ogun \
	generated/comboMove_search.ogun \
	generated/comboMove_move.ogun \
	generated/comboMove_test.ogun \
	generated/verticalMove.ogun \
	generated/escapeMove.ogun \
	generated/baseMove.ogun \
	generated/baseMove_checkNeighborShape.ogun 

	#generated/stateMove.ogun 
	#generated/verticalMove_createTask.ogun 
	#generated/spiralMove_changeState.ogun 
	#generated/spiralMove_changeState2.ogun 
	#generated/dogCalculateDistance.ogun 
	#generated/dogDefenseLine.ogun 
all   : GENERATED_DIR $(OBJ_COMMON)\
	parser_test.ogun \
	$(DST_DIR)/r.gb


#$(DST_DIR)/dogOnly.gb \
#	$(DST_DIR)/crack.gb
CRLF  :
	dos2unix *
parser_test.ogun : parser_test.gun parser_test_expected.gb parser.pl parser_test2.gun
	@echo $@ from $<
	@$(COMPILER) -v $< > tmp_$@
	@diff --strip-trailing-cr parser_test_expected.gb tmp_$@
	@mv tmp_$@ $@
	#@diff parser_test_expected.gb tmp_$@
GENERATED_DIR :
	@if [ ! -d generated ]; then mkdir -p generated; fi
$(DST_DIR)/%.gb : $(OBJ_COMMON) generated/%.ogun 
	@cat $^ > $@.tmp
	perl syntaxCheck.pl $@.tmp
	##### warning: if use compress.pl remove -j option from make
	perl removeComments.pl $@.tmp | perl compress.pl > $@
	#perl removeComments.pl $@.tmp > $@
	#####
	@rm -f $@.tmp
%.gun : %_impl.gun
	touch $@
generated/%.ogun : %.pl
	perl $< > $@
generated/%.ogun : %.gun
	$(COMPILER) $< > $@.preCheck
	perl syntaxCheck.pl $@.preCheck
	mv $@.preCheck $@
%.gun : %_gen.pl
	perl $<
init.gun : pos.gun
	touch $@
pos.gun : checkWarp.gun
	touch $@
hexPrefDef.gun : hexPrefDef_impl2.gun 
	touch $@
moveMaxHexPref.gun : moveMaxHexPref_impl6.gun \
	moveMaxHexPref_impl5.gun \
	moveMaxHexPref_impl4.gun \
	moveMaxHexPref_impl3.gun \
	moveMaxHexPref_impl2.gun \
	moveMaxHexPref_impl1.gun 
	touch $@
spiralMove.gun : \
	spiralMove_init_evaluate_impl.gun \
	spiralMove_stack_push.gun \
	spiralMove_call_searchInner.gun \
	spiralMove_call_searchInner2.gun
	touch $@
checkContinental_impl2.gun : checkContinental_stack_push.gun 
	touch $@
checkContinental_init.gun : checkContinental_stack_push.gun 
	touch $@
comboMove.gun : comboMove_push.gun \
	comboMove_pushFromArray.gun \
	comboMove_pushFromFunc.gun
	touch $@
