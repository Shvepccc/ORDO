SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include
OBJ_DIR = $(BUILD_DIR)/obj
CONFIG_FILE = "install.conf"
CERT_FILE = certificate.txt

CC = gcc

COMPILE_FLAGS = -std=c99 -O2 -g 

OBJECTS = build/obj/main.o build/obj/lib.o

TARGET = ordo
TARGET_NAME = ORDO
TARGET_PATH = $(BUILD_DIR)/$(TARGET)

COLOR_RESET=\033[0m
COLOR_GREEN=\033[32m
COLOR_RED=\033[31m
COLOR_YELLOW=\033[33m


#Compilation
compile: hello_message check_configuration_files message_start_compilation check_compiler $(TARGET_PATH)

hello_message:
ifeq ($(shell id -u), 0)
	@echo -e "$(COLOR_YELLOW)Running as root. Potentially unsafe.$(COLOR_RESET)"
endif
	@echo "Hello, $(shell whoami). Welcome to $(TARGET_NAME) build system."

message_start_compilation:
	@echo "Compilation is started..."


makeobj: $(OBJECTS)

build/obj/main.o: src/main.c
	@mkdir -p build/obj
	$(CC) $(COMPILE_FLAGS) -c src/main.c -o build/obj/main.o

build/obj/lib.o: src/lib.c
	@mkdir -p build/obj
	$(CC) $(COMPILE_FLAGS) -c src/lib.c -o build/obj/lib.o

$(TARGET_PATH): makeobj
	$(CC) $(COMPILE_FLAGS) -o $(TARGET_PATH) $(OBJECTS)


#Create docs
user_man: $(BUILD_DIR)/docs/user_man.pdf
in_instruct: $(BUILD_DIR)/docs/in_instruct.pdf
an_instruct: $(BUILD_DIR)/docs/an_instruct.pdf
license: $(BUILD_DIR)/docs/LICENSE.pdf

$(BUILD_DIR)/docs/user_man.pdf: docs/user_man.tex $(BUILD_DIR)/docs check_pdflatex
	@echo "[1/4] Compiling user_man.tex"
	@pdflatex -output-directory=$(BUILD_DIR)/docs docs/user_man.tex >> /dev/null
	@rm -f $(BUILD_DIR)/docs/user_man.aux $(BUILD_DIR)/docs/user_man.log

$(BUILD_DIR)/docs/in_instruct.pdf: docs/in_instruct.tex $(BUILD_DIR)/docs check_pdflatex
	@echo "[2/4] Compiling in_instruct.tex"
	@pdflatex -output-directory=$(BUILD_DIR)/docs docs/in_instruct.tex >> /dev/null
	@rm -f $(BUILD_DIR)/docs/in_instruct.aux $(BUILD_DIR)/docs/in_instruct.log

$(BUILD_DIR)/docs/an_instruct.pdf: docs/an_instruct.tex $(BUILD_DIR)/docs check_pdflatex
	@echo "[3/4] Compiling an_instruct.tex"
	@pdflatex -output-directory=$(BUILD_DIR)/docs docs/an_instruct.tex >> /dev/null
	@rm -f $(BUILD_DIR)/docs/an_instruct.aux $(BUILD_DIR)/docs/an_instruct.log

$(BUILD_DIR)/docs/LICENSE.pdf: docs/LICENSE.tex $(BUILD_DIR)/docs check_pdflatex
	@echo "[4/4] Compiling LICENSE.tex"
	@pdflatex -output-directory=$(BUILD_DIR)/docs docs/LICENSE.tex >> /dev/null
	@rm -f $(BUILD_DIR)/docs/LICENSE.aux $(BUILD_DIR)/docs/LICENSE.log

$(BUILD_DIR)/docs:
	@mkdir -p $(BUILD_DIR)/docs

docs: user_man in_instruct an_instruct license


#Getting data and validation
configure: 
	./get_data.sh

check_configuration_files:
	@if [ ! -f $(CONFIG_FILE) ] || [ ! -f certificate.txt ]; then \
		echo "\n$(COLOR_YELLOW)Seems like you haven't configure project yet.$(COLOR_RESET)"; \
		./get_data.sh; \
	fi

check_compiler:
	@if command -v cc >/dev/null 2>&1; then \
		COMPILER=$$(cc --version | head -n 1);\
		echo "$(COLOR_GREEN)C compiler found: $$COMPILER$(COLOR_RESET)"; \
	else \
		echo "$(COLOR_RED)C compiler not found. Please install it.$(COLOR_RESET)"; \
		exit 1; \
	fi

check_pdflatex:
	@if command -v pdflatex >/dev/null 2>&1; then \
		COMPILER=$$(pdflatex --version | head -n 1); \
		echo -e "$(COLOR_GREEN)pdfLaTeX compiler found: $$COMPILER$(COLOR_RESET)"; \
	else \
		echo -e "$(COLOR_RED)pdfLaTeX compiler not found. Please install it.$(COLOR_RESET)"; \
		exit 1; \
	fi

#install



#Clearing functions
clear_tmp:
	@echo "* Clearing temporary files"
	@rm -rf $(OBJ_DIR)

clear_config:
	@echo "* Clearing config file"
	@rm -rf $(CONFIG_FILE)

clear_compile: clear_tmp clear_docs
	@echo "* Clearing fuse binary"
	@rm -rf $(BUILD_DIR)/$(TARGET)

clear_certificate:
	@echo "* Clearing temporary certificate file"
	@rm -rf $(CERT_FILE)

clear_docs:
	@echo "* Clearing compiled docs"
	@rm -rf $(BUILD_DIR)/docs

clear: clear_tmp clear_certificate clear_config clear_docs

clear_all: clear clear_compile

#unistall

#remove

#remove_all