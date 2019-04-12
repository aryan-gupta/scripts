#
#    Copyright (c) 2018 The Gupta Empire - All Rights Reserved
#    Please refer to LICENCE.md in the project root directory for
#    licence information. If no Licence file is provided, please
#    contact Aryan Gupta <me@theguptaempire.net> for more info
#
#===============================================================================
#    @author          Aryan Gupta <me@theguptaempire.net>
#    @title           Makefile
#    @brief           This is a generic Makefile I use for my C++ projects
#===============================================================================
.DEFAULT_GOAL := debug
#==========================  CONFIG MACROS  ====================================
CC = g++
GDB = gdb
EXT = out
PRGM = main

# Directories
BIN = bin
SRC = src
DEP = dep

# Boost libs
# BOOST_INC = -I/usr/local/boost/include
# BOOST_LNK = -L/usr/local/boost/lib -lboost_atomic -lboost_graph -lboost_math_tr1l -lboost_stacktrace_noop -lboost_chrono -lboost_iostreams -lboost_prg_exec_monitor -lboost_system -lboost_container -lboost_locale -lboost_program_options -lboost_test_exec_monitor -lboost_context -lboost_log -lboost_random -lboost_thread -lboost_contract -lboost_log_setup -lboost_regex -lboost_timer -lboost_coroutine -lboost_math_c99 -lboost_serialization -lboost_type_erasure -lboost_date_time -lboost_math_c99f -lboost_signals -lboost_unit_test_framework -lboost_exception -lboost_math_c99l -lboost_stacktrace_addr2line -lboost_wave -lboost_fiber -lboost_math_tr1 -lboost_stacktrace_backtrace -lboost_wserialization -lboost_filesystem -lboost_math_tr1f -lboost_stacktrace_basic
BOOST_LNK = -lboost_system

#==============================  MACROS  ======================================

GCC_MAJOR = $(shell $(CC) -v 2>&1 | grep " version " | cut -d' ' -f3  | cut -d'.' -f1)
GCC_MINOR = $(shell $(CC) -v 2>&1 | grep " version " | cut -d' ' -f3  | cut -d'.' -f2)

GCC_MIN = 5

# Final executable
EXE = $(BIN)/$(PRGM).$(EXT)

# Source files and dependencies
SRCS = $(wildcard $(SRC)/*.cpp)
OBJS = $(patsubst %, $(BIN)/%.o, $(basename $(notdir $(SRCS))))
DEPS = $(patsubst %, $(DEP)/%.d, $(basename $(notdir $(SRCS))))

# External libs
ILIBS = $(BOOST_INC)
LLIBS = $(BOOST_LNK)

CPP_VER = -std=c++17

# Compile/Link flags
CFLAGS = $(DEBUG) $(ILIBS) -Wall $(CPP_VER) -c
LFLAGS = $(DEBUG) $(LLIBS) -Wall -lstdc++fs -lpthread

# Dependency flags
DEPFLAGS = -MT $@ -MD -MP -MF $(patsubst %,$(DEP)/%.Td, $(basename $(notdir $<)))

#============================= PHONY RECEPIES =================================

# Build for debugging
.PHONY: debug
debug: DEBUG = -O0 -ggdb -g3
debug: $(EXE)

# Build for production
.PHONY: build
build: DEBUG = -O3 -DNDEBUG -s
build: $(EXE)

# Run program
.PHONY: run
run:
	@$(EXE)

# Clean and recompile for production
.PHONY: all
all: clean build
	@echo Rebuilt from scratch at $(EXE)

# Clean directories
.PHONY: clean
clean:
	@echo Cleaning temp files
	-@rm -f $(BIN)/*
	-@rm -f $(DEP)/*

#============================ RECEPIES ========================================

# Object files
$(BIN)/%.o: $(SRC)/%.cpp
	@echo Building $@
	@$(CC) $(DEPFLAGS) $< $(CFLAGS) -o $@
	@mv -f $(DEP)/$*.Td $(DEP)/$*.d

# Link
$(EXE): $(OBJS)
	@echo Linking $@
	@$(CC) $^ -o $@ $(LFLAGS)

# Dependencies
.PRECIOUS = $(DEP)/%.d
$(DEP)/%.d: ;

ifeq ($(shell expr $(GCC_MAJOR) \< $(GCC_MIN)), 1)
	$(error GCC is version $(GCC_MAJOR), code in this repo needs version $(GCC_MIN). \
	        Please check `$(CC) --version` for version information. \
	        If you think this is a mistake, please use `make all GCC_MIN=$(GCC_MAJOR)` to rebuild the targets \
	        but be warned, there may be compile errors. There are prebuilt binaries for linux in the bin/ \
	        directory)
endif

# Include Dependencies
-include $(DEPS)
