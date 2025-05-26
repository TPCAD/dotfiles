cmake_minimum_required(VERSION 3.10)

project(meow LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++23")

file(GLOB SRC_LIST "src/*.cpp")

add_executable(main ${SRC_LIST})
target_include_directories(main PRIVATE include)
