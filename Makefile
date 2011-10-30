
# all: clang_lookup_app
# clang_lookup_app: has_llvm has_clang

TARGETDIR = ./build

all: $(TARGETDIR)/clang_lookup

clean:
	@echo Cleaning target dir ...
	rm -rfd $(TARGETDIR)

$(TARGETDIR)/exists:
	mkdir -p $(TARGETDIR)
	touch $@

build/%.o: %.cpp $(TARGETDIR)/has_llvm $(TARGETDIR)/has_clang
	@echo Compiling $< ...
	$(CXX) -c $(CXXFLAGS) $< -o $@

build/clang_lookup: build/clang_lookup_app.o
	@echo Linking $@ ...
	$(CXX) $(LDFLAGS) $(LLVM_LIBS) $(CLANG_LIBS) $< -o $@

CXXFLAGS = -I$(LLVM_INCLUDE_DIR) -I$(CLANG_INCLUDE_DIR)
LDFLAGS = -L $(LLVM_LIB_DIR)

# TODO: check which of those libs are needed
LLVM_LIBS = -lLLVMSupport -lLLVMBitWriter -lLLVMBitWriter -lLLVMmc
CLANG_LIBS = -lclang -lclangLex -lclangAST -lclangParse -lclangAnalysis -lclangRewrite -lclangBasic -lclangSema -lclangCodeGen -lclangSerialization -lclangDriver -lclangStaticAnalyzerCheckers -lclangFrontend -lclangStaticAnalyzerCore -lclangFrontendTool -lclangStaticAnalyzerFrontend -lclangIndex

LLVM_BASE_DIR = ./llvm
LLVM_INCLUDE_DIR = $(LLVM_BASE_DIR)/include

CLANG_BASE_DIR = ./llvm/tools/clang
CLANG_INCLUDE_DIR = $(CLANG_BASE_DIR)/include

ifeq "$(DEBUG)" "1"
LLVM_BIN_DIR = $(LLVM_BASE_DIR)/Release/bin
LLVM_LIB_DIR = $(LLVM_BASE_DIR)/Release/lib
else
LLVM_BIN_DIR = $(LLVM_BASE_DIR)/Debug/bin
LLVM_LIB_DIR = $(LLVM_BASE_DIR)/Debug/lib
endif

PATH := $(LLVM_BIN_DIR):$(PATH)

$(TARGETDIR)/has_llvm: $(TARGETDIR)/exists
	@echo Checking if LLVM exists ...
	(which -s llvm-as) || (echo $(LLVM_INSTALL_HELP); exit 1)
	touch $@

$(TARGETDIR)/has_clang: $(TARGETDIR)/exists
	@echo Checking if Clang exists ...
	(which -s clang) || (echo $(LLVM_INSTALL_HELP); exit 1)
	touch $@



