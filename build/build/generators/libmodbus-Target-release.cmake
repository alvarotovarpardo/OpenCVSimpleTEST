# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(libmodbus_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(libmodbus_FRAMEWORKS_FOUND_RELEASE "${libmodbus_FRAMEWORKS_RELEASE}" "${libmodbus_FRAMEWORK_DIRS_RELEASE}")

set(libmodbus_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET libmodbus_DEPS_TARGET)
    add_library(libmodbus_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET libmodbus_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${libmodbus_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${libmodbus_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### libmodbus_DEPS_TARGET to all of them
conan_package_library_targets("${libmodbus_LIBS_RELEASE}"    # libraries
                              "${libmodbus_LIB_DIRS_RELEASE}" # package_libdir
                              "${libmodbus_BIN_DIRS_RELEASE}" # package_bindir
                              "${libmodbus_LIBRARY_TYPE_RELEASE}"
                              "${libmodbus_IS_HOST_WINDOWS_RELEASE}"
                              libmodbus_DEPS_TARGET
                              libmodbus_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "libmodbus"    # package_name
                              "${libmodbus_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${libmodbus_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${libmodbus_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${libmodbus_LIBRARIES_TARGETS}>
                 )

    if("${libmodbus_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET libmodbus::libmodbus
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     libmodbus_DEPS_TARGET)
    endif()

    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${libmodbus_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${libmodbus_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${libmodbus_LIB_DIRS_RELEASE}>)
    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${libmodbus_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET libmodbus::libmodbus
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${libmodbus_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(libmodbus_LIBRARIES_RELEASE libmodbus::libmodbus)
