from conan import ConanFile
from conan.tools.cmake import cmake_layout


class ExampleRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"
    generators = "CMakeDeps", "CMakeToolchain"

    def requirements(self):
        self.requires("fmt/11.2.0")
        self.requires("gtest/1.16.0")
        self.requires("spdlog/1.15.3")

    def layout(self):
        cmake_layout(self)