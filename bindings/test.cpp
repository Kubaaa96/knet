#include <pybind11/pybind11.h>

int add(int first_param, int second_param) {
    return first_param + second_param;
}
// NOLINTNEXTLINE(misc-include-cleaner)
PYBIND11_MODULE(testpackage, module) {
    module.doc() = "Hehe";
    module.def("add", &add, "A function");
}
