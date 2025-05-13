# 编译器设置
CC := clang
CFLAGS := -fPIC -I./c  -mmacosx-version-min=12.0 # 添加头文件目录
LDFLAGS := -dynamiclib -mmacosx-version-min=12.0 # 指定最低版本12.0 避免版本不一致的warning

# Flex/Bison 设置
LEX := flex
YACC := bison
YFLAGS := -d                  # 生成头文件

# 文件路径设置
SRC_DIR := ./c
GEN_DIR := $(SRC_DIR)
LEX_SRC := ./flex/L25.l
YACC_SRC := ./bison/L25.y
LEX_GEN := $(GEN_DIR)/lex.yy.c
YACC_GEN_C := $(GEN_DIR)/parser.tab.c
YACC_GEN_H := $(GEN_DIR)/parser.tab.h

SRCS := $(wildcard $(SRC_DIR)/*.c) $(LEX_GEN) $(YACC_GEN_C)
OBJS := $(SRCS:.c=.o)
TARGET := libcstruct.dylib


# 构建目标
all: $(TARGET) cjpm_build



# 生成动态库
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^
	@echo "\033[32mSuccessfully built $@\033[0m"

# 编译普通C文件（排除生成的代码）
$(SRC_DIR)/%.o: $(SRC_DIR)/%.c $(YACC_GEN_C) $(LEX_GEN)
	$(CC) $(CFLAGS) -c $< -o $@


# 编译生成的语法分析器
$(YACC_GEN_C): $(YACC_SRC)
	$(YACC) $(YFLAGS) -o $@ $<

# 编译生成的词法分析器
$(LEX_GEN): $(LEX_SRC)
	$(LEX) -o $@ $<


# 执行仓颉构建命令
cjpm_build:
	@echo "\033[34mRunning cjpm build...\033[0m"
	cjpm build -V 
	cjpm run

# 清理生成文件
clean:
	rm -f $(TARGET)
	rm -f $(SRC_DIR)/*.o
	rm -f $(LEX_GEN) $(YACC_GEN_C) $(YACC_GEN_H)
	@echo "\033[33mCleaned: All build files removed\033[0m"

.PHONY: all cjpm_build clean