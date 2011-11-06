
# all: clang_lookup_app
# clang_lookup_app: has_llvm has_clang

DEBUG=0

ifeq "$(DEBUG)" "1"
VARIANT=Debug
else
ifeq "$(DEBUG)" "0"
VARIANT=Release
else
$(error "DEBUG must be either 0 or 1")
endif
endif

TARGETDIR=$(VARIANT)

BUILD_PLATFORM = $(shell 'uname')
ifeq "$(BUILD_PLATFORM)" "Linux"
DLL_EXT = so
else
DLL_EXT = dylib
endif

all: $(TARGETDIR)/clang_lookup $(TARGETDIR)/clang_lookup.sh $(TARGETDIR)/libclang.$(DLL_EXT)

test: all
	cd tests && ./test.sh

clean:
	@echo Cleaning target dirs ...
	rm -rfd Debug Release

CXXFLAGS = -I$(LLVM_BASE_DIR)/include -I$(CLANG_BASE_DIR)/include
LDFLAGS = -L $(LLVM_BASE_DIR)/$(VARIANT)/lib

# TODO: check which of those libs are needed
LLVM_LIBS = -lLLVMSupport -lLLVMBitWriter -lLLVMBitWriter -lLLVMmc
CLANG_LIBS = -lclang -lclangLex -lclangAST -lclangParse -lclangAnalysis -lclangRewrite -lclangBasic -lclangSema -lclangCodeGen -lclangSerialization -lclangDriver -lclangStaticAnalyzerCheckers -lclangFrontend -lclangStaticAnalyzerCore -lclangFrontendTool -lclangStaticAnalyzerFrontend -lclangIndex

LLVM_BASE_DIR = ./llvm
CLANG_BASE_DIR = ./llvm/tools/clang

PATH := $(LLVM_BASE_DIR)/$(VARIANT)/bin:$(PATH)

$(TARGETDIR)/exists:
	mkdir -p $(TARGETDIR)
	touch $@

$(TARGETDIR)/%.o: %.cpp $(TARGETDIR)/has_llvm $(TARGETDIR)/has_clang
	@echo Compiling $< ...
	$(CXX) -c $(CXXFLAGS) $< -o $@

$(TARGETDIR)/clang_lookup: $(TARGETDIR)/clang_lookup_app.o
	@echo Linking $@ ...
	$(CXX) $(LDFLAGS) $(LLVM_LIBS) $(CLANG_LIBS) $< -o $@

$(TARGETDIR)/clang_lookup.sh: $(TARGETDIR)/exists
	@echo Creating $@ ...
	echo '#!/usr/bin/env sh' > $@
	echo 'CLANG_LOOKUP_DIR=`dirname $$0`' >> $@
	echo 'CLANG_LOOKUP_DIR=`cd $${CLANG_LOOKUP_DIR}; pwd`' >> $@
	echo 'LD_LIBRARY_PATH=$${CLANG_LOOKUP_DIR} $${CLANG_LOOKUP_DIR}/clang_lookup $$@' >> $@
	echo 'exit $${EXITSTATUS}' >> $@
	chmod a+x $@

$(TARGETDIR)/libclang.dylib: $(LLVM_BASE_DIR)/$(VARIANT)/lib/libclang.dylib
	cp $< $@

$(TARGETDIR)/has_llvm: $(TARGETDIR)/exists
	@echo Checking if LLVM exists ...
	(which -s llvm-as) || (echo $(LLVM_INSTALL_HELP); exit 1)
	touch $@

$(TARGETDIR)/has_clang: $(TARGETDIR)/exists
	@echo Checking if Clang exists ...
	(which -s clang) || (echo $(LLVM_INSTALL_HELP); exit 1)
	touch $@



