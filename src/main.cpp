#include <fmt/base.h>
#include "Example.hpp"

int main(){
    fmt::print("Hello World {}\n", Example::value());
    return 0;
}
