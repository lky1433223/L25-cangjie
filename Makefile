# 编译器设置
CC := clang
CFLAGS := -fPIC -I./c  # 添加头文件目录需要的话
LDFLAGS := -dynamiclib

# 文件路径设置
SRC_DIR := ./c
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:.c=.o)
TARGET := cstruct.dylib

# 构建目标
all: $(TARGET) cjpm_build

# 生成动态库
$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^
	@echo "\033[32mSuccessfully built $@\033[0m"

# 编译C源文件
$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# 执行仓颉构建命令
cjpm_build:
	@echo "\033[34mRunning cjpm build...\033[0m"
	cjpm build

# 清理生成文件
clean:
	rm -f $(OBJS) $(TARGET)
	@echo "\033[33mCleaned build artifacts\033[0m"

.PHONY: all cjpm_build clean